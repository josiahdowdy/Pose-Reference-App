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
    // MARK: - VARIABLES
    
    @ObservedObject var userSettings = StoredUserData()
    //@ObservedObject var dataProvider = DataProvider.shared
    @EnvironmentObject var prefs: GlobalVariables
    
    @State private var alertShowing = false
    @State private var editMode: EditMode = .inactive
    
    @Environment(\.managedObjectContext) var context

    @State var rowSelection = Set<PhotoFolders>()

    @State var testUrlResourceKey = Set<URLResourceKey>()



    @State var url : URL = URL(fileURLWithPath: "nil")
    @State var selectAll = false

    //@State public var totalPhotosLoaded = 0
    @Binding var totalPhotosLoaded: Int

    var cdFolders: FetchedResults<PhotoFolders>

    var cdPhotos: FetchedResults<PhotosArray>


    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors: []
    ) var fetchFolderNameOnce : FetchedResults<PhotoFolders>


    // @State var cdEditMode = EditMode.active

/*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    // MARK: - UI
    var body: some View {
        //  NavigationView {
        HStack {
            Button(action: {
                print("Select All Photos")
                if !(selectAll) {
                    selectAll.toggle()
                    deleteAllRows()
                    //select all photos.
                } else {
                    selectAll.toggle()
                    //unSelect all photos.
                }
            }) {
                Image(systemName: selectAll ? "checkmark.circle.fill" : "checkmark.circle") //Text("Pause")
            }.keyboardShortcut(.space).buttonStyle(BorderlessButtonStyle())

            Text("Photos").font(.title)
        }

        VStack {
            //      List(cdFolders, id: \.self, selection: $rowSelection){ name in //*this works*

           //TODO: - Working list.
            List(selection: $rowSelection) {
                ForEach(cdFolders, id: \.self) { name in
                    HStack {
                        Text(name.wrappedFolderName)
                        //Text(" - \(name.wrappedFolderURL.path)").font(.caption2)
                       // Text(" - \(name.wrappedFolderURL)").font(.caption2)
                    }
                    .onTapGesture {
                        loadFolderArray(folderURL: name.wrappedFolderURL)
                    }
                }
                .onDelete(perform: cdOnSwipeDelete)
            }
            .listStyle(InsetListStyle())

     /*       List(selection: $rowSelection) {
                ForEach(fetchFolderNameOnce, id: \.self) { folder in
                    Section(header: Text(folder.wrappedFolderName)) {
                        ForEach(folder.photosArraySorted, id: \.self) { photo in
                            Text(photo.wrappedName)
                        } //FIXME: - I only want to show one folder name each.
                    } */





                    //     Text(photo.wrappedName)
                    //}
                    //
           //     }
                //  .onDelete(perform: cdOnSwipeDelete)
           // }
            

         //   .navigationTitle("Photos") // Photos"

        }
        .environment(\.editMode, .constant(EditMode.active)) // *IMPORTANT* Allows checkbox to appear.
       // .navigationBarTitle(Text("#: \(rowSelection.count)"))
        //.navigationBarItems( leading: cdArraySave )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    //self.cdArraySave
                    self.cdDeleteButton
                    StatsButton()
                }
            }
        }
    }
    /*•••••••••••••END VIEW••••••••••••*/

       /*__/,|   (`\
     _.|o o  |_   ) )
     -(((---(((-----*/

    /*•••••••••START FUNCTIONS•••••••••*/
    private var cdDeleteButton: some View {
        //print("JD33: cdDeleteButton - Why is this getting called each time a button is pressed?")
        return Button(action: cdDeleteFolders) {
            Image(systemName: "trash")
            //            if cdEditMode == .active {
            //                Image(systemName: "trash")
            //            }
            // #####################################################################
            // Even with a commented .disable rule, the trash can deletes nothing
            // #####################################################################
        }.disabled(rowSelection.count <= 0)
    }

    private func deletePrefsSavedURLs() {

    }

    private func cdDeleteFolders() {
        for selectedItem in self.rowSelection{
            self.context.delete(selectedItem)
            totalPhotosLoaded -= rowSelection.count
            //selectedItem.
            //selectedItem.workingDirectoryBookmark
            //userSettings.arrayWorkingDirectoryBookmark.remove[0]

            // print("JD90: ", selectedItem.workingDirectoryBookmark!)
        }
       // deleteBookmarkURLs()
        try? self.context.save()
        rowSelection = Set<PhotoFolders>()

        loadCurrentFileURLs()
    }

    private func loadCurrentFileURLs() {
        prefs.isBookmarkDeletePending = true
        prefs.arrayOfURLStringsTEMP.removeAll()

        //Do I fetchrequest the photosURLs that are saved?

       // prefs.arrayOfURLStringsTEMP.append()
    }


 /*   private func deleteBookmarkURLs() {
        var actualPath: URL
        //var filesToDelete: [URL]
      //  var urlTest: Data
      //  var fileData: [Data]


        for selectedItem in self.rowSelection{
            let fileData = try? Data.init(contentsOf: selectedItem.folderURL!)
            print("JD150: ", fileData)
        let fileName = url.lastPathComponent

        actualPath = getDocumentsDirectory().appendingPathComponent(fileName)

            //fileData.append(restoreFileAccess(with: userSettings.arrayWorkingDirectoryBookmark.contains(putThePhotoDataHere)))


           // try fileData?.write(to: actualPath)

           // filesToDelete.append(actualPath)
          //  prefs.arrayOfURLStrings.append(String(describing: actualPath))

            if(fileData == nil){
                print("Permission error!")
            }
            else {
                print("Success.")
            }
        }

        func getDocumentsDirectory() -> URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }




        print("JD121: delete bookmarks.")
    /*    for selectedItem in self.rowSelection{
            //print("JD140: ", selectedItem.folderURL) //This gets the folder URL.
            do {

                for i in 0..<userSettings.arrayWorkingDirectoryBookmark.count {
                    print("JD141: Now looping saved bookmark array.")

                    url = restoreFileAccess(with: userSettings.arrayWorkingDirectoryBookmark[i])!

                    //FIXME: BOOKMARK URL IS WORKING. NOW, ADD IT TO AN ARRAY.
                    if (url.startAccessingSecurityScopedResource()) {
                        print("JD142: Access granted. Working yes.")

                        //TODO: - If the files have the same parent folder name as selectedItem, then delete it.
                       // if (selectedItem.folderURL == userSettings.arrayWorkingDirectoryBookmark.remove(at: <#T##Int#>))
                        userSettings.arrayWorkingDirectoryBookmark.remove(at: i)

                        if let index = userSettings.arrayWorkingDirectoryBookmark.firstIndex(of: url.dataRepresentation) {
                            userSettings.arrayWorkingDirectoryBookmark.remove(at: index)
                            print("JD122: \(userSettings.arrayWorkingDirectoryBookmark.count)")
                            // testUrlResourceKey.remove(at: index) // Set<URLResourceKey>.Index
                            //self.context.delete(selectedItem)
                        }
                        //print("JD68: LOADING BOOKMARK. \(prefs.arrayOfURLStrings)")
                    } else {
                        print("JD67: False")
                    }
                }
                url.stopAccessingSecurityScopedResource()

               // let url = try URL(resolvingBookmarkData: bookmarkData[0], bookmarkDataIsStale: &isStale)


                //let url = selectedItem.wrappedFolderURL

                //                    if (CFURLStartAccessingSecurityScopedResource(url as CFURL)) {
                //                        print("JD126: Access Granted.")
                //                        // if url.startAccessingSecurityScopedResource() {
                //
                //
                //                     //   let data = try Data(contentsOf: selectedItem.folderURL!)
                //
                //                        if let index = userSettings.arrayWorkingDirectoryBookmark.firstIndex(of: data) {
                //                            userSettings.arrayWorkingDirectoryBookmark.remove(at: index)
                //                            print("JD122: \(userSettings.arrayWorkingDirectoryBookmark.count)")
                //                            // testUrlResourceKey.remove(at: index) // Set<URLResourceKey>.Index
                //                            //self.context.delete(selectedItem)
                //                        }
                //
                //                        //guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                //
                //                        //guard
                //                        //let data = try Data(contentsOf: selectedItem.folderURL!) //else { return }
                //
                //
                //                        print("JD120: \(userSettings.arrayWorkingDirectoryBookmark.count)")
                //
                //
                //                        //done accessing the url
                //                        CFURLStopAccessingSecurityScopedResource(selectedItem.wrappedFolderURL as CFURL)


            //selectedItem.folderURL!.dataRepresentation
        } catch {
            print("JD110: ", error)
        }
        }   */
        try? self.context.save()
        rowSelection = Set<PhotoFolders>()
        print("JD131: deleteBookmarkURLs done")
    }//End Func. */


    private func deleteAllRows() {
        PersistenceController.shared.clearDatabase()
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

    private func loadFolderArray(folderURL: URL) {
        if let index = prefs.currentlySelectedFolders.firstIndex(of: folderURL) {
            prefs.currentlySelectedFolders.remove(at: index)
        } else {
            prefs.currentlySelectedFolders.append(folderURL)
        }

        print("JD106: \(prefs.currentlySelectedFolders)")

//        prefs.currentlySelectedFolders.contains(folderURL) {
//            if let index = animals.firstIndex(of: "chimps") {
//                animals.remove(at: index)
//            }
//
//        }
    }

    public func loadSelectedBookmarkedPhotos() {
        //for photo in userSettings.arrayWorkingDirectoryBookmark {
        //prefs.arrayOfURLStringsTEMP = restoreFileAccessArray(with: (userSettings.arrayWorkingDirectoryBookmark))!

        //print("JD84:", prefs.arrayOfURLStringsTEMP)
        print("JD105")

        for selectedItem in self.rowSelection{
            print("JD104")
        //MARK: - Loads in array of photos.
            for i in 0..<userSettings.arrayWorkingDirectoryBookmark.count {
                print("JD103")
                
                do {
                    //var error: NSError? = nil
                    print("JD102:", selectedItem.wrappedFolderURL.path)
                    var isStale = false

                    if (selectedItem.wrappedFolderURL.startAccessingSecurityScopedResource()) {
                        for file in try Folder(path: selectedItem.wrappedFolderURL.path).files {
                            print("JD101")
                        if userSettings.arrayWorkingDirectoryBookmark.contains(file.url.dataRepresentation) { // //selectedItem.folderURL!.dataRepresentation
                                let url = try URL.init(resolvingBookmarkData: userSettings.arrayWorkingDirectoryBookmark[i],   relativeTo: nil, bookmarkDataIsStale: &isStale)

                                print("JD100")
                               // if (url.startAccessingSecurityScopedResource()) {
                                    prefs.arrayOfURLStrings.append(String(describing: url.path))
                             //   } else { print("JD67: No Access to security resources.") }
                            }
                        }
                    }
                } catch {
                    print("Error resolving bookmark:", error)
                   // return nil
                }

                //            url = restoreFileAccess(with: userSettings.arrayWorkingDirectoryBookmark[i])!
                //
                //            //FIXME: BOOKMARK URL IS WORKING. NOW, ADD IT TO AN ARRAY.
                //            if (url.startAccessingSecurityScopedResource()) {
                //                prefs.arrayOfURLStrings.append(String(describing: url))
                //                //print("JD68: LOADING BOOKMARK. \(prefs.arrayOfURLStrings)")
                //            } else {
                //                print("JD67: False")
                //            }
            }
        }
        print("\n•••••••••••••••••••••• JD68 LOADING BOOKMARK DONE ••••••••••••••••••••••------------------------------------")
        //print("JD99:  \(prefs.arrayOfURLStrings)")
        url.stopAccessingSecurityScopedResource()
    } //End func.

    private func restoreFileAccess(with bookmarkData: Data) -> URL? {
        do {
            var isStale = false
            let url = try URL.init(resolvingBookmarkData: bookmarkData, options: URL.BookmarkResolutionOptions.withoutUI,  relativeTo: nil, bookmarkDataIsStale: &isStale)

            //Options: URL.bookmarkResolutionOptions.withSecurityScope

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

    private func saveBookmarkData(for workDir: URL) { //URL //for workDir: URL //[URL: Data]
        do {

  //MARK: --> Works --> //let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: nil, relativeTo: nil)

            let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: nil, relativeTo: nil)

            //userSettings.workingDirectoryBookmark = bookmarkData
            userSettings.arrayWorkingDirectoryBookmark.append(bookmarkData)
        } catch {
            print("Failed to save bookmark data for \(workDir)", error)
        }
    }

    public func loadSelectedPhotos() { //with bookmarkData: Data
        //FIXME: - Will only work if a folder is a selected, NOT a photo.
        print("JD89: loadSelectedPHotos started")
        for selectedItem in self.rowSelection{
            print("JD90: loadSelectedPHotos started")
            do {
                var _: NSError? = nil //error
               // var isStale = false

               // let loadedArray = try URL.init(resolvingBookmarkData: bookmarkData, options: URL.bookmarkResolutionOptions.withSecurityScope,  relativeTo: nil, bookmarkDataIsStale: &isStale)

                //var i = 1
                
                for file in try Folder(path: selectedItem.wrappedFolderURL.path).files {
                    print("JD63: \(file.url.downloadURL) - \(file.name) - \(file.path)")
                    prefs.arrayOfURLStrings.append(String(describing: file.url.downloadURL))
                    //userSettings.arrayPhotoURLs.append(file.url.downloadURL) //(String(describing: file.url))
                }
            }  catch {
                print("JD19: Catch Error", error)
            }
        }

       // print("JD00: userSettings.arrayPhotoURLs: \(userSettings.arrayPhotoURLs)")
        //prefs.arrayOfFolders.removeAll()
    }
} //End Struct.









    /*


     /*
      for selectedItem in self.rowSelection{
      let url = selectedItem.wrappedFolderURL
      userSettings.storedFolderURL = url

      print("JD60: \(userSettings.storedFolderURL.downloadURL)")
      // saveBookmarkData(for: url)

      //FIXME: - Is restoreFileAccess working? No.
      //It does load in the URL correctly, but the image does not show.
      let savedURL = restoreFileAccess(with: userSettings.workingDirectoryBookmark)


      userSettings.recoveredURL = savedURL//!.downloadURL

      prefs.arrayOfURLStrings.append(userSettings.recoveredURL.path)
      print("JD65: prefs.arrayOfURLStrings \(prefs.arrayOfURLStrings)")
      print("JD61: userSettings.recoveredURL \(userSettings.recoveredURL)")

      //  CFURLCreateBookmarkData(nil, userSettings.storedFolderURL.downloadURL as CFURL, options: [userSettings.storedFolderURL], nil, nil, nil)

      print("JD36: cdFolders.count", cdFolders.count)

      // print("JD21: \(String(describing: restoredURL))")

      print("JD21: \(String(describing: savedURL))")

      if (CFURLStartAccessingSecurityScopedResource(url as CFURL?)) { //url as CFURL
      print("JD28: ACCESS GRANTED TO SECURITY RESOURCES in CD save array..")
      //prefs.arrayOfFolders.append(selectedItem.wrappedFolderURL)

      do {
      //LOAD AND SAVE URLS FOR IMAGES IN FOLDERS.
      //     userSettings.url = selectedItem.wrappedFolderURL


      //userSettings.storedFolderURL = selectedItem.wrappedFolderURL
      //TODO: - FOR loop in Security Access
      do {
      var error: NSError? = nil

      //                        //FIXME: - Will only work if a folder is a selected, NOT a photo.
      //                        for file in try Folder(path: selectedItem.wrappedFolderURL.path).files {  //userSettings.url.path
      //                            print("JD63: \(file.url.downloadURL) - \(file.name) - \(file.path)")
      //
      //                            prefs.arrayOfURLStrings.append(String(describing: file.url.downloadURL))
      //
      //                            //TODO: - Working, image data stored properly.
      //                            print("JD62: file.url \(file.url)")
      //                            let imageData = try Data(contentsOf: file.url)
      //                            let img = UIImage(data: imageData)
      //                            //  userSettings.photo = (img?.pngData())! //?? img?.jpegData(compressionQuality: 1)
      //
      //                            userSettings.photo = (img?.jpegData(compressionQuality: 1))!//.append(img)
      //                            //Image(uiImage: UIImage(data: student.picture ?? Data()) ?? UIImage())
      //
      //                            //userSettings.arrayPhotoURLs.append(file.url.downloadURL) //(String(describing: file.url))
      //                        }
      } catch {
      print("JD19: Catch Error", error)
      }
      //  saveBookmarkData(for: selectedItem.wrappedFolderURL)
      // saveBookmarkData(for: userSettings.storedFolderURL)
      CFURLStopAccessingSecurityScopedResource(url as CFURL?) // <- and here
      }
      try? self.context.save()
      } else {
      print("JD22: Failed access to security scoped resources.")
      }

      // print("JD04: prefs.arrayOfFolders : \(prefs.arrayOfFolders)")
      //  print("JD05: prefs.arrayOfURLStrings : \(prefs.arrayOfURLStrings)")
      // print("JD06: userSettings.arrayPhotoURLs: \(userSettings.arrayPhotoURLs)")
      } */

     //userSettings.url.path
     //print("JD63: \(file.url.downloadURL) - \(file.name) - \(file.path)")

     //If the URL is in the bookmarkArray, then load it and append it.
     //                    if loadedArray.contains(loadedArray, file.url) {
     //                        let url = try URL.init(resolvingBookmarkData: bookmarkData[i], options: URL.bookmarkResolutionOptions.withSecurityScope,  relativeTo: nil, bookmarkDataIsStale: &isStale)
     //
     //                        prefs.arrayOfURLStrings.append(String(describing: file.url.downloadURL))
     //
     //                    }
     //
     //                    i += 1






    public var cdArraySave: some View {
        print("CD34: cdArraySave")
        return Button(action: showPhotoFunction) { //cdSaveArray
            Image(systemName: "square.and.arrow.down")
        }.disabled(rowSelection.count <= 0)
    }

    private func showPhotoFunction() {
        //TODO: - Show Photo Here.
        url = restoreFileAccess(with: userSettings.workingDirectoryBookmark)!

        //FIXME: BOOKMARK URL IS WORKING. NOW, ADD IT TO AN ARRAY.
        if (url.startAccessingSecurityScopedResource()) {
            print("JD67: TRUE")
            prefs.arrayOfURLStrings.append(String(describing: url))
            print("JD68: prefs.arrayOfURLStrings \(prefs.arrayOfURLStrings[0])")
        } else {
            print("JD67: False")
        }
    }
    
    private func cdSaveArray() {
        print("JD00: userSettings.arrayPhotoURLs: \(userSettings.arrayPhotoURLs)")
        //prefs.arrayOfFolders.removeAll()
        for selectedItem in self.rowSelection{
            let url = selectedItem.wrappedFolderURL
            userSettings.storedFolderURL = url

            print("JD60: \(userSettings.storedFolderURL.downloadURL)")
           // saveBookmarkData(for: url)

            //FIXME: - Is restoreFileAccess working? No.
            //It does load in the URL correctly, but the image does not show.
            let savedURL = restoreFileAccess(with: userSettings.workingDirectoryBookmark)

            userSettings.recoveredURL = savedURL!//!.downloadURL

            prefs.arrayOfURLStrings.append(userSettings.recoveredURL.path)
            print("JD65: prefs.arrayOfURLStrings \(prefs.arrayOfURLStrings)")
            print("JD61: userSettings.recoveredURL \(userSettings.recoveredURL)")

            //  CFURLCreateBookmarkData(nil, userSettings.storedFolderURL.downloadURL as CFURL, options: [userSettings.storedFolderURL], nil, nil, nil)

            print("JD36: cdFolders.count", cdFolders.count)

           // print("JD21: \(String(describing: restoredURL))")

            print("JD21: \(String(describing: savedURL))")

            if (CFURLStartAccessingSecurityScopedResource(url as CFURL?)) { //url as CFURL
                print("JD28: ACCESS GRANTED TO SECURITY RESOURCES in CD save array..")
                //prefs.arrayOfFolders.append(selectedItem.wrappedFolderURL)

                do {
                    //LOAD AND SAVE URLS FOR IMAGES IN FOLDERS.
                    //     userSettings.url = selectedItem.wrappedFolderURL


                    //userSettings.storedFolderURL = selectedItem.wrappedFolderURL
                    //TODO: - FOR loop in Security Access
                    do {
                        var error: NSError? = nil

                        //FIXME: - Will only work if a folder is a selected, NOT a photo.
                        for file in try Folder(path: selectedItem.wrappedFolderURL.path).files {  //userSettings.url.path
                            print("JD63: \(file.url.downloadURL) - \(file.name) - \(file.path)")

                            prefs.arrayOfURLStrings.append(String(describing: file.url.downloadURL))

                            //TODO: - Working, image data stored properly.
                            print("JD62: file.url \(file.url)")
                            let imageData = try Data(contentsOf: file.url)
                            let img = UIImage(data: imageData)
                                //  userSettings.photo = (img?.pngData())! //?? img?.jpegData(compressionQuality: 1)

                            userSettings.photo = (img?.jpegData(compressionQuality: 1))!//.append(img)
                            //Image(uiImage: UIImage(data: student.picture ?? Data()) ?? UIImage())

                            //userSettings.arrayPhotoURLs.append(file.url.downloadURL) //(String(describing: file.url))
                        }
                    } catch {
                        print("JD19: Catch Error", error)
                    }
                    //  saveBookmarkData(for: selectedItem.wrappedFolderURL)
                    // saveBookmarkData(for: userSettings.storedFolderURL)
                    CFURLStopAccessingSecurityScopedResource(url as CFURL?) // <- and here
                }
                try? self.context.save()
            } else {
                print("JD22: Failed access to security scoped resources.")
            }
            print("JD04: prefs.arrayOfFolders : \(prefs.arrayOfFolders)")
            print("JD05: prefs.arrayOfURLStrings : \(prefs.arrayOfURLStrings)")
            print("JD06: userSettings.arrayPhotoURLs: \(userSettings.arrayPhotoURLs)")
        }
    }

    private func saveBookmarkData(for workDir: URL) { //URL //for workDir: URL //[URL: Data]
        do {
            let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: nil, relativeTo: nil)
            
            // save in UserDefaults
            userSettings.workingDirectoryBookmark = bookmarkData
            print("JD22: \(userSettings.workingDirectoryBookmark)")
        } catch {
            print("Failed to save bookmark data for \(workDir)", error)
        }
    }
    
    private func restoreFileAccess(with bookmarkData: Data) -> URL? { //[URL: Data]) -> URL? {
        do {
            var isStale = false
            
            //            for url in bookmarkData {
            //                let url2 = try URL(resolvingBookmarkData: bookmarkData[url], relativeTo: nil, bookmarkDataIsStale: &isStale)
            //
            //            }
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
    } */
    
    // Core Data Functions


    
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
    
    







/*
 
 
 /*••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
  saveFile works, when I have just added new folders. BUT, if I am trying to select the URLs of
  folders loaded in a previous session, then I don't have permission to view them.
  ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••*/
 //  saveFile(url: selectedItem.wrappedFolderURL) //selectedFiles[i]
 // print("J2: \(selectedItem.wrappedFolderURL)")
 //   prefs.arrayOfURLStrings.append(String(describing: selectedItem.wrappedFolderURL))




 // NoteListCell(note: cdFolders)

 //            List {
 //                ForEach(dataProvider.allNotes) { note in
 //                    //Make these into buttons you click.
 //
 //                    NoteListCell(note: note)
 //                        .onTapGesture {
 //                            var i = 0
 //                            if (note.isFolderSelected) {
 //                                note.isFolderSelected = false
 //                            } else {
 //                              //  note.isFolderSelected = true
 //                            }
 //                            i += 1
 //                            print("JD32: note.isFolderSelected", note.isFolderSelected)
 //                            //rowSelection.append(note)
 //                        }
 //                }
 //                .onDelete(perform: dataProvider.delete)
 //                .onMove(perform: dataProvider.move)





 //for selectedItem in dataProvider.allNotes {
 //    if (selectedItem.isFolderSelected) {

 //userSettings.storedFolderData = try! Data.init(contentsOf: url)
 //    selectedItem. = try! Data.init(contentsOf: url)
 //userSettings.storedFolderURL) //selectedItem.wrappedURL

 // print("JD31: userSettings.storedFolderData: ", userSettings.storedFolderData)

 // userSettings.workingDirectoryBookmark)//userSettings.workingDirectoryBookmark)

 //    CFURLCreateBookmarkData(nil, userSettings.storedFolderURL.downloadURL as CFURL, options: [userSettings.storedFolderURL], nil, nil, nil)

 //    let url = selectedItem.wrappedFolderURL
 */
