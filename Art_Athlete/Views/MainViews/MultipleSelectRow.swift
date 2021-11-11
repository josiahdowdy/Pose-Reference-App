//
//  MultipleSelectRow.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-06.
//

import SwiftUI
import Files

struct MultipleSelectRow : View {
    @EnvironmentObject var prefs: GlobalVariables
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors: []
    ) var foldersData : FetchedResults<PhotoFolders>


    //Core Data
    @State var rowSelection = Set<PhotoFolders>()

    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors:[])
    var cdNumbers: FetchedResults<PhotoFolders>

    // @State var cdEditMode = EditMode.active


    var body: some View {
        NavigationView {
            //   List(foldersData, id: \.self, selection: $rowSelection){ name in //*this works*
            List(selection: $rowSelection) {
                ForEach(cdNumbers, id: \.self) { name in
                        HStack {
                            Text(name.wrappedFolderName)
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
    }


    //•••••••••START FUNCTIONS•••••••••
    /*••••••••••••••••••••••••••••••••
     ••••••••••••••••••••••••••••••••••
     ••••••••••••••••••••••••••••••••••
     ••••••••••••••••••••••••••••••••••
     ••••••••••••••••••••••••••••••••*/
    private var cdArraySave: some View {
        return Button(action: cdSaveArray) {
            Image(systemName: "square.and.arrow.down")
        }.disabled(rowSelection.count <= 0)
    }

    private func cdSaveArray() {
        prefs.arrayOfFolders.removeAll()

        for selectedItem in self.rowSelection{
       // ForEach(rowSelection, id: \.self) { i in
            //self.context.delete(selectedItem)
            prefs.arrayOfFolders.append(selectedItem.wrappedFolderName)

            /*••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
             saveFile works, when I have just added new folders. BUT, if I am trying to select the URLs of
             folders loaded in a previous session, then I don't have permission to view them.
             ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••*/
          //  saveFile(url: selectedItem.wrappedFolderURL) //selectedFiles[i]
            print("J2: \(selectedItem.wrappedFolderURL)")
            prefs.arrayOfURLStrings.append(String(describing: selectedItem.wrappedFolderURL))


            do {
                let folderSelected = try Folder(path: selectedItem.wrappedFolderURL.path)

                for file in try Folder(path: folderSelected.path).files {
                    print(file.name)
                    prefs.arrayOfURLStrings.append(String(describing: file.url))
                }

               // prefs.arrayOfURLStrings.append(String(describing: folderSelected.files))
                            //.append(String(describing: actualPath))
            } catch {
                print(error.localizedDescription)
            }
             //selectedItem.folderURL!.path

            //folderSelected.folder.files.append()

            //prefs.arrayOfURLStrings.append(selectedItem.folderURL!.path)
            print("JD03: \(prefs.arrayOfURLStrings)")
        }

        try? self.context.save()
        rowSelection = Set<PhotoFolders>()



        print(prefs.arrayOfFolders)


        print(prefs.arrayOfURLStrings)

//        for i in 0...(selectedFiles.count-1) { //selectedFiles.count
//            //print("\n\(i)") //This prints out the photo data
//            saveFile(url: selectedFiles[i])
//        }
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
            // #####################################################################
            // # Using Set<MyNumber>()
            self.context.delete(selectedItem)
            // ########  OR  ############
            // # Using Set<UUID>()
            // self.moc.delete(cdNumbers.first(where:  {$0.id == selectedItem})!)
            // #####################################################################
        }
        try? self.context.save()

        // #####################################################################
        // # Using Set<MyNumber>()
        //rowSelection = Set<PhotoFolders>()
        rowSelection = Set<PhotoFolders>()
        // ########  OR  ############
        // # Using Set<UUID>()
        // rowSelection = Set<UUID>()
        // #####################################################################
    }

    // #####################################################################
    // Core data selecction is affected by the presence of the cdOnSwipeDelete function
    // IE: The selection column is shown in edit mode only if
    // this functuion is referenced by ForEach{}.onDelete()
    // #####################################################################
    private func cdOnSwipeDelete(with indexSet: IndexSet) {

        indexSet.forEach { index in
            let number = cdNumbers[index]
            self.context.delete(number)
        }
        try? self.context.save()
    }




    func saveFile (url: URL) {
        var actualPath: URL

        if (CFURLStartAccessingSecurityScopedResource(url as CFURL)) { // <- here

            let fileData = try? Data.init(contentsOf: url)
            let fileName = url.lastPathComponent

            actualPath = getDocumentsDirectory().appendingPathComponent(fileName)

            // print("\nactualPath = \(actualPath)\n") //Prints out the actual path.
            do {
                try fileData?.write(to: actualPath)
                prefs.arrayOfURLStrings.append(String(describing: actualPath))
                //print("\nString: arrayOfURLStrings: \n\(prefs.arrayOfURLStrings)\n")
                if(fileData == nil){
                    print("Permission error! ...in saveFile function from MultipleSelectRow.")
                }
                else {
                    //print("Success.")
                }
            } catch {
                print("Josiah1: \(error.localizedDescription)")
            }
            CFURLStopAccessingSecurityScopedResource(url as CFURL) // <- and here

        }
        else {
            print("Permission error!")
        }

        func getDocumentsDirectory() -> URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    }

}

