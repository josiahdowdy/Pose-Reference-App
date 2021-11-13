//
//  MultipleSelectRow.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-06.
//

import SwiftUI
import Files
import UniformTypeIdentifiers

struct MultipleSelectRow : View {
    @ObservedObject var userSettings = StoredUserData()
    @EnvironmentObject var prefs: GlobalVariables
    @Environment(\.managedObjectContext) var context

    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors: []
    ) var foldersData : FetchedResults<PhotoFolders>


    //Core Data
    @State var rowSelection = Set<PhotoFolders>()

    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors:[])
    var cdFolders: FetchedResults<PhotoFolders>

    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \PhotoFolders.folderURL, ascending: true)])
    var folderURLFetchRequest: FetchedResults<PhotoFolders>

    @FetchRequest(entity: PhotosArray.entity(), sortDescriptors:[])
    var cdPhotosSelected: FetchedResults<PhotosArray>


    // @State var cdEditMode = EditMode.active


    var body: some View {
        NavigationView {
            //   List(foldersData, id: \.self, selection: $rowSelection){ name in //*this works*
            List(selection: $rowSelection) {

                ForEach(cdFolders, id: \.self) { name in
                    HStack {
                        Text(name.wrappedFolderName)
                        Text(name.wrappedFolderURL.path).font(.caption2)
                    }
                }
                .onDelete(perform: cdOnSwipeDelete)



            }
        }
        // the next line is the modifier
        .environment(\.editMode, .constant(EditMode.active)) // *IMPORTANT* Allows checkbox to appear.
        .navigationBarTitle(Text("#: \(rowSelection.count)"))

        .navigationBarItems(leading: cdDeleteButton, trailing: cdArraySave)//, trailing: EditButton()
        //  .environment(\.editMode, self.$cdEditMode)
    } //•••••••••END VIEW•••••••••


    /*•••••••••START FUNCTIONS•••••••••••••••••••••••••••••••••••••••••••
     ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••*/
    private var cdArraySave: some View {
        return Button(action: cdSaveArray) {
            Image(systemName: "square.and.arrow.down")
        }.disabled(rowSelection.count <= 0)
    }

    private func cdSaveArray() {
        print("JD00: userSettings.arrayPhotoURLs: \(userSettings.arrayPhotoURLs)")

        //prefs.arrayOfFolders.removeAll()

        for selectedItem in self.rowSelection{

            let url = selectedItem.wrappedFolderURL

            let savedURL = restoreFileAccess(with: userSettings.workingDirectoryBookmark)

            CFURLCreateBookmarkData(nil, userSettings.storedFolderURL.downloadURL as CFURL, options: [userSettings.storedFolderURL], nil, nil, nil)

         //   CFURLCreateBookmarkData(<#T##allocator: CFAllocator!##CFAllocator!#>, <#T##url: CFURL!##CFURL!#>, <#T##options: CFURLBookmarkCreationOptions##CFURLBookmarkCreationOptions#>, <#T##resourcePropertiesToInclude: CFArray!##CFArray!#>, <#T##relativeToURL: CFURL!##CFURL!#>, <#T##error: UnsafeMutablePointer<Unmanaged<CFError>?>!##UnsafeMutablePointer<Unmanaged<CFError>?>!#>)

            print("JD21: \(String(describing: savedURL))")

            if (CFURLStartAccessingSecurityScopedResource(url as CFURL)) {
                print("JD28: ACCESS GRANTED TO SECURITY RESOURCES.")

             //   prefs.arrayOfFolders.append(selectedItem.wrappedFolderURL)

                do {
                    //LOAD AND SAVE URLS FOR IMAGES IN FOLDERS.
               //     userSettings.url = selectedItem.wrappedFolderURL

                    userSettings.storedFolderURL = selectedItem.wrappedFolderURL

                    do {
                        for file in try Folder(path: userSettings.storedFolderURL.path ).files {  //userSettings.url.path
                            print("JD06: \(file.url) - \(file.name)")
                            prefs.arrayOfURLStrings.append(String(describing: file.url.downloadURL))
                            userSettings.arrayPhotoURLs.append(file.url.downloadURL) //(String(describing: file.url))
                        }
                    } catch {
                        print("JD19: Catch Error")
                    }
                  //  saveBookmarkData(for: selectedItem.wrappedFolderURL)

                    saveBookmarkData(for: userSettings.storedFolderURL)

                    CFURLStopAccessingSecurityScopedResource(url as CFURL) // <- and here

                }

                try? self.context.save()


            } else {
                print("JD22: Failed access to security scoped resources.")

            }


           //
            print("JD04: prefs.arrayOfFolders : \(prefs.arrayOfFolders)")
            print("JD05: prefs.arrayOfURLStrings : \(prefs.arrayOfURLStrings)")
            print("JD06: userSettings.arrayPhotoURLs: \(userSettings.arrayPhotoURLs)")

        }
    }


    private func saveBookmarkData(for workDir: URL) {
        do {
            let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: nil, relativeTo: nil)

            // save in UserDefaults
            userSettings.workingDirectoryBookmark = bookmarkData

            print("JD22: \(userSettings.workingDirectoryBookmark)") //\(String(describing: userSettings.workingDirectoryBookmark))")
        } catch {
            print("Failed to save bookmark data for \(workDir)", error)
        }
    }

    private func restoreFileAccess(with bookmarkData: Data) -> URL? {
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmarkData, relativeTo: nil, bookmarkDataIsStale: &isStale)
            if isStale {
                // bookmarks could become stale as the OS changes
                print("Bookmark is stale, need to save a new one... ")
                saveBookmarkData(for: url)
            }
            return url
        } catch {
            print("Error resolving bookmark:", error)
            return nil
        }
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        // Start accessing a security-scoped resource.
        guard url.startAccessingSecurityScopedResource() else {
            // Handle the failure here.
            return
        }

        // Make sure you release the security-scoped resource when you finish.
        defer { url.stopAccessingSecurityScopedResource() }

        // Use file coordination for reading and writing any of the URL’s content.
        var error: NSError? = nil
        NSFileCoordinator().coordinate(readingItemAt: url, error: &error) { (url) in

            let keys : [URLResourceKey] = [.nameKey, .isDirectoryKey]

            // Get an enumerator for the directory's content.
            guard let fileList =
                    FileManager.default.enumerator(at: url, includingPropertiesForKeys: keys) else {
                        Swift.debugPrint("*** Unable to access the contents of \(url.path) ***\n")
                        return
                    }

            for case let file as URL in fileList {
                // Start accessing the content's security-scoped URL.
                guard url.startAccessingSecurityScopedResource() else {
                    // Handle the failure here.
                    continue
                }

                // Do something with the file here.
                Swift.debugPrint("chosen file: \(file.lastPathComponent)")

                // Make sure you release the security-scoped resource when you finish.
                url.stopAccessingSecurityScopedResource()
            }
        }
    }

    // Core Data Functions
    private var cdDeleteButton: some View {
        return Button(action: cdDeleteNumbers) {
            Image(systemName: "trash")
            //            if cdEditMode == .active {
            //                Image(systemName: "trash")
            //            }
            // #####################################################################
            // Even with a commented .disable rule, the trash can deletes nothing
            // #####################################################################
        }.disabled(rowSelection.count <= 0)
    }

    private func cdDeleteNumbers() {
        for selectedItem in self.rowSelection{
            self.context.delete(selectedItem)
        }
        try? self.context.save()
        rowSelection = Set<PhotoFolders>()
    }

    // #####################################################################
    // Core data selecction is affected by the presence of the cdOnSwipeDelete function
    // IE: The selection column is shown in edit mode only if
    // this functuion is referenced by ForEach{}.onDelete()
    // #####################################################################
    private func cdOnSwipeDelete(with indexSet: IndexSet) {

        indexSet.forEach { index in
            let number = cdFolders[index]
            self.context.delete(number)
        }
        try? self.context.save()
    }


//    func saveFile (url: URL) {
//        var actualPath: URL
//
//        if (CFURLStartAccessingSecurityScopedResource(url as CFURL)) { // <- here
//
//            let fileData = try? Data.init(contentsOf: url)
//            let fileName = url.lastPathComponent
//
//            actualPath = getDocumentsDirectory().appendingPathComponent(fileName)
//
//            // print("\nactualPath = \(actualPath)\n") //Prints out the actual path.
//            do {
//                try fileData?.write(to: actualPath)
//                prefs.arrayOfURLStrings.append(String(describing: actualPath))
//                //print("\nString: arrayOfURLStrings: \n\(prefs.arrayOfURLStrings)\n")
//                if(fileData == nil){
//                    print("Permission error! ...in saveFile function from MultipleSelectRow.")
//                }
//                else {
//                    //print("Success.")
//                }
//            } catch {
//                print("Josiah1: \(error.localizedDescription)")
//            }
//            CFURLStopAccessingSecurityScopedResource(url as CFURL) // <- and here
//
//        }
//        else {
//            print("Permission error!")
//        }
//
//        func getDocumentsDirectory() -> URL {
//            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        }
//    }


}






/*


 /*••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
  saveFile works, when I have just added new folders. BUT, if I am trying to select the URLs of
  folders loaded in a previous session, then I don't have permission to view them.
  ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••*/
 //  saveFile(url: selectedItem.wrappedFolderURL) //selectedFiles[i]
 // print("J2: \(selectedItem.wrappedFolderURL)")
 //   prefs.arrayOfURLStrings.append(String(describing: selectedItem.wrappedFolderURL))

 */
