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
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var sharedData: SharedViewModel
    //@EnvironmentObject var storedUserData: StoredUserData
    @ObservedObject var storedUserData = StoredUserData()
    //@AppStorage("arrayOfFolderNames") var arrayOfFolderNames: [String] = []
    @AppStorage("storedFileURLs") var storedFileURLs: [[URL]] = [[]]
    //@AppStorage("fileName") var fileName: [[String]] = [[]]

    @EnvironmentObject var homeData: HomeViewModel
    
    //@ObservedObject var dataProvider = DataProvider.shared
    
    @State private var alertShowing = false
    @State private var editMode: EditMode = .inactive

    //@State var rowSelection = Set<FoldersEntity>()
    @Binding var rowSelection: Set<String>

    //@State var testUrlResourceKey = Set<URLResourceKey>()
    @State var url : URL = URL(fileURLWithPath: "nil")
    @State var selectAll = false

    //@State var arrayOfFolderNames: [String] = []

    @Binding var totalPhotosLoaded: Int

    @FetchRequest(entity: FoldersEntity.entity(), sortDescriptors:[])
    var fetchFolders: FetchedResults<FoldersEntity>

    @FetchRequest(entity: PhotosEntity.entity(), sortDescriptors:[])
    var fetchPhotos: FetchedResults<PhotosEntity>

    @ObservedObject var folderArrayModel: FoldersArrayModel

    //@FetchRequest(entity: FoldersEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FoldersEntity.folderName, ascending: false)]) var fetchFolderNameOnce : FetchedResults<FoldersEntity>

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
           // FolderRowsView(folderArrayModel: folderArrayModel, rowSelection: $rowSelection)
              //  .environmentObject(homeData)
            ShowAllFolders()
        }
        .onAppear(perform: scanAllFolders)
        //.environment(\.editMode, .constant(EditMode.active)) // *IMPORTANT* Allows checkbox to appear.
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                 //   EditButton()
                    //self.cdArraySave
                    self.cdDeleteButton
                 //   StatsButton()
                }
            }
        }
    } //End view.
    /*•••••••••••••END VIEW••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••*/

    /*__/,|   (`\
     _.|o o  |_   ) )
     -(((---(((-----*/

    /*•••••••••START FUNCTIONS•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••*/
    //MARK: - VIEWBUILDER. •••••••••••••••••••••
    @ViewBuilder
    func ShowAllFolders()->some View{
        List {
            ForEach(homeData.folders) { product in
                Text("\(product.title) - \(product.count)")
            }
            .onDelete(perform: removeFolders)
        }
        //                List(selection: $rowSelection) {
        //                    ForEach(homeData.folders, id: \.self) { product in
        //                        Text("\(product.title) - \(product.count)")
        //                    }
        //                    .onDelete(perform: removeRows)
        //                    //.onDelete(perform: self.deleteItem)
        //                }

    }


    func removeFolders(at offsets: IndexSet) {
        homeData.folders = homeData.folders.enumerated().filter { (i, item) -> Bool in
            let removed = offsets.contains(i)
            if removed {
                testPoopDelFolder(folder: item)
                //AdjustProfileRemove(period: item)
            }
            return !removed
        }.map { $0.1 }
    }

    private func testPoopDelFolder(folder: Product) {
        print("JD460: \(folder.title)")
        let folderName = folder.title
        let url = Folder.documents!.path

        if (Folder.documents!.containsSubfolder(named: folderName)) {
            do {
                let folder = try Folder(path: url.appending(folderName))
                try folder.delete()
            } catch {

            }
        }
    }

    private func scanAllFolders() {
        homeData.folders.removeAll()
        if (UIDevice.current.userInterfaceIdiom == .mac) {
            print("JD451: mac")
            Folder.documents!.subfolders.recursive.forEach { folder in
                homeData.folders.append(Product(type: .Poses, title: folder.name, subtitle: "Ballerina", count: folder.files.count(), productImage: "AppleWatch6"))
//                let newFolder = FoldersModel(name: folder.name)
//                folderArrayModel.folderArray.append(newFolder)
                //MARK: Different on mac --> folder.files vs Folder.documents!.files
            }
        }

        //MARK: important --> when running "My Mac (designed for ipad)", this if statement is used.
        if !(UIDevice.current.userInterfaceIdiom == .mac) {
            print("JD451: NOT mac")
            Folder.documents!.subfolders.recursive.forEach { folder in
                homeData.folders.append(Product(type: .Poses, title: folder.name, subtitle: "Ballerina", count: folder.files.count(), productImage: "AppleWatch6"))
//                let newFolder = FoldersModel(name: folder.name)
//                folderArrayModel.folderArray.append(newFolder)
            }
        }
    } //End func.

    ////(selection: $rowSelection) { //homeData, id: \.self, selection: $rowSelection



    func removeRows(at offsets: IndexSet) {
        homeData.folders.remove(atOffsets: offsets)
       // homeData.folders.contains(where: Product)

        for i in offsets {
            print("JD460: \(i)")
        }


      //  var arrOfStoredFolders = Folder.documents!.subfolders
     //   var arrOfListFolders = homeData.folders
       // homeData.folders.

       // var arrayOfFolderNamesInList: Array<String>



        //
       // print("JD460: \(arrayOfFolderNamesInList)")

        /*
         For each photo folder in finder,
         1. Check in each of the homeData names
         2. if there is a match, a the folder name exists,
         3. we do NOT want to delete that folder.
         4. But, if there is NO match
         5. Then delete that folder.
         */
        for fol in homeData.folders {
          //  var array1 = arrOfStoredFolders.filter { !arrayOfFolderNamesInList.contains($0) }

            var isFolderFound = false
//
//            if (Folder.documents!.containsFile(named: fol.title)) {
//                isFolderFound = true
//            } else {
//                Folder.documents!.subfolders.recursive.contains(where: (Folder.documents!.containsFile(named: fol.title)))
//            }

            print("JD451: array")

            Folder.documents!.subfolders.recursive.forEach { folder in
                print("JD451: \(folder.name) = \(fol.title)")

              //  if folder.
                if (folder.name == fol.title) {
                    print("JD451: Match.")
                    isFolderFound = true

                }

//                do {
//                    if !(isFolderFound) {
//                        print("JD451: No matching folder name.")
//                        try folder.delete()
//                    }
//                } catch {
//                    print("error in delete sandbox")
//                }
            }

        }
        deleteFolderData()
    }

    private func deleteFolderData() {
        Folder.documents!.subfolders.recursive.forEach { folder in
            print("JD451: Name : \(folder.name), parent: \(String(describing: folder.parent))")
            do {
                try folder.delete()
            } catch {
                print("error in delete sandbox")
            }
        }
    }

    //homeData.products.contains($0)
    private func deleteNumbers() {
//        for id in rowSelection {
//            if let index = homeData.folders.lastIndex(where: { $0 == id  }) { //{ $0 == id })  {
//                homeData.folders.remove(at: index)
//            }
//        }
        rowSelection = Set<String>()
    }

    private func deleteAllPhotosInSandbox() {
        Folder.documents!.subfolders.recursive.forEach { folder in
            print("JD451: Name : \(folder.name), parent: \(String(describing: folder.parent))")
            do {
                try folder.delete()
            } catch {
                print("error in delete sandbox")
            }

            //            for file in folder.files {
            //                print("JD451: ", file.name)
            //
            //                file.delete()
            //            }
        }
    }

    private var cdDeleteButton: some View {
        //print("JD33: cdDeleteButton - Why is this getting called each time a button is pressed?")
        if editMode == .inactive {
            return  Button(action: {}) {
                Image(systemName: "")
            }
        } else {
            return Button(action: cdDeleteFolders) { //cdDeleteFolders
                Image(systemName: "trash")
                //            if cdEditMode == .active {
                //                Image(systemName: "trash")
                //            }
                // #####################################################################
                // Even with a commented .disable rule, the trash can deletes nothing
                // #####################################################################
            }//.disabled(rowSelection.count <= 0)
        }
    }

    private func cdDeleteFolders() {
//        for selectedItem in self.rowSelection{
//            if homeData.folders.contains(Product.ID.contains(selectedItem)) {
//                let index = homeData.folders.firstIndex(of: selectedItem)
//
//                homeData.folders.remove(at: index!)
//                // storedFileURLs.remove(at: index!)
//                //print("JD401: ", storedUserData.arrayOfFolderNames)
//            }
//        }

       // deleteFolder(at: rowSelection)

      //  homeData.folders.remove(at: rowSelection)

//        for selectedItem in self.rowSelection{
//            if homeData.folders.contains(Product(selectedItem)) {
//                let index = homeData.folders.firstIndex(of: selectedItem)
//
//                homeData.folders.remove(at: index!)
//                // storedFileURLs.remove(at: index!)
//                //print("JD401: ", storedUserData.arrayOfFolderNames)
//            }
//        }

        //Remove selected items from the array.
        //        for selectedItem in self.rowSelection{
        //            if storedUserData.arrayOfFolderNames.contains(selectedItem) {
        //                let index = storedUserData.arrayOfFolderNames.firstIndex(of: selectedItem)
        //
        //                storedUserData.arrayOfFolderNames.remove(at: index!)
        //               // storedFileURLs.remove(at: index!)
        //                print("JD401: ", storedUserData.arrayOfFolderNames)
        //            }
        //        }
        // deleteBookmarkURLs()
        //try? self.context.save()
        rowSelection = Set<String>()
        //        rowSelection = Set<FoldersEntity>()
        //deleteAllPhotosInSandbox()

        print("JD404: ", storedFileURLs)
    }

    private func deleteAllRows() {
        //storedUserData.arrayOfFolderNames.removeAll()
        storedFileURLs.removeAll()
        PersistenceController.shared.clearDatabase()
        try? self.context.save()
        rowSelection = Set<String>()
        //rowSelection = Set<FoldersEntity>()
    }

    // #####################################################################
    // Core data selecction is affected by the presence of the cdOnSwipeDelete function
    // IE: The selection column is shown in edit mode only if
    // this functuion is referenced by ForEach{}.onDelete()
    // #####################################################################
    private func cdOnSwipeDelete(with indexSet: IndexSet) {
        indexSet.forEach { index in
            let number = fetchFolders[index]
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
} //End Struct.


/*
 //MARK: - OLD working lists to display folders.
 //      List(cdFolders, id: \.self, selection: $rowSelection){ name in //*this works*

                                                                          //TODO: - Working list.
                                                                          //            List(selection: $rowSelection) {
                                                                          //                ForEach(folderArrayModel, id: \.name) { folder in
                                                                          //                    Text(folder.folderName)
                                                                          //                    //...
                                                                          //                }
                                                                          //                .onDelete(perform: cdOnSwipeDelete)
                                                                          //            }
                                                                          //            .listStyle(InsetListStyle())

                                                                          // //

                                                                          //  Form {
                                                                          // ForEach(0..<$storedUserData.arrayOfFolderNames.count) { number in
                                                                          // ForEach(storedUserData.arrayOfFolderNames, id: \.self) {

                                                                          //                    ForEach(fileName), id: \.self) {
                                                                          //                        Text($0)
                                                                          //                    }
                                                                          // Text(storedUserData.arrayOfFolderNames[number])
                                                                          // .onReceive(storedUserData.$arrayOfFolderNames, perform: UIBackgroundRefreshStatus)

                                                                          /*
                                                                           List(selection: $rowSelection) {
                                                                           ForEach(fetchPhotos, id: \.self) { name in //cdFolders
                                                                           HStack {
                                                                           Text(name.folderRel!.wrappedFolderName)
                                                                           //Text(" - \(name.wrappedFolderURL.path)").font(.caption2)
                                                                           // Text(" - \(name.wrappedFolderURL)").font(.caption2)
                                                                           }
                                                                           //     .onTapGesture {  loadFolderArray(folderURL: name.wrappedFolderURL) }
                                                                           }
                                                                           .onDelete(perform: cdOnSwipeDelete)
                                                                           }
                                                                           .listStyle(InsetListStyle())

                                                                           List() {  //selection: $rowSelection
                                                                           ForEach(fetchFolders, id: \.self) { folder in
                                                                           Section(header: Text(folder.wrappedFolderName)) {
                                                                           ForEach(folder.photosArray, id: \.self) { photo in
                                                                           Text(photo.wrappedFolderName)
                                                                           }
                                                                           }
                                                                           }
                                                                           }
                                                                           */
                                                                          */

 /*   public func loadSelectedBookmarkedPhotos() {
  //for photo in storedUserData.arrayWorkingDirectoryBookmark {
  //prefs.arrayOfURLStringsTEMP = restoreFileAccessArray(with: (storedUserData.arrayWorkingDirectoryBookmark))!

  //print("JD84:", prefs.arrayOfURLStringsTEMP)
  print("JD105")

  for selectedItem in self.rowSelection{
  print("JD104")
  //MARK: - Loads in array of photos.
  for i in 0..<storedUserData.arrayWorkingDirectoryBookmark.count {
  print("JD103")

  do {
  //var error: NSError? = nil
  //print("JD102:", selectedItem.wrappedFolderURL.path)
  var isStale = false

  if (selectedItem.wrappedFolderURL.startAccessingSecurityScopedResource()) {
  //if (selectedItem.)
  for file in try Folder(path: selectedItem.wrappedFolderURL.path).files {
  print("JD101")
  if storedUserData.arrayWorkingDirectoryBookmark.contains(file.url.dataRepresentation) { // //selectedItem.folderURL!.dataRepresentation
  let url = try URL.init(resolvingBookmarkData: storedUserData.arrayWorkingDirectoryBookmark[i],   relativeTo: nil, bookmarkDataIsStale: &isStale)

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

  //            url = restoreFileAccess(with: storedUserData.arrayWorkingDirectoryBookmark[i])!
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

  //storedUserData.workingDirectoryBookmark = bookmarkData
  storedUserData.arrayWorkingDirectoryBookmark.append(bookmarkData)
  } catch {
  print("Failed to save bookmark data for \(workDir)", error)
  }
  }

  */
 //FIXME: - Will only work if a folder is a selected, NOT a photo.
 /*   public func loadSelectedPhotos() { //with bookmarkData: Data

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
  //storedUserData.arrayPhotoURLs.append(file.url.downloadURL) //(String(describing: file.url))
  }
  }  catch {
  print("JD19: Catch Error", error)
  }
  }

  // print("JD00: storedUserData.arrayPhotoURLs: \(storedUserData.arrayPhotoURLs)")
  //prefs.arrayOfFolders.removeAll()
  } */



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

  //fileData.append(restoreFileAccess(with: storedUserData.arrayWorkingDirectoryBookmark.contains(putThePhotoDataHere)))


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

   for i in 0..<storedUserData.arrayWorkingDirectoryBookmark.count {
   print("JD141: Now looping saved bookmark array.")

   url = restoreFileAccess(with: storedUserData.arrayWorkingDirectoryBookmark[i])!

   //FIXME: BOOKMARK URL IS WORKING. NOW, ADD IT TO AN ARRAY.
   if (url.startAccessingSecurityScopedResource()) {
   print("JD142: Access granted. Working yes.")

   //TODO: - If the files have the same parent folder name as selectedItem, then delete it.
   // if (selectedItem.folderURL == storedUserData.arrayWorkingDirectoryBookmark.remove(at: <#T##Int#>))
   storedUserData.arrayWorkingDirectoryBookmark.remove(at: i)

   if let index = storedUserData.arrayWorkingDirectoryBookmark.firstIndex(of: url.dataRepresentation) {
   storedUserData.arrayWorkingDirectoryBookmark.remove(at: index)
   print("JD122: \(storedUserData.arrayWorkingDirectoryBookmark.count)")
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
   //                        if let index = storedUserData.arrayWorkingDirectoryBookmark.firstIndex(of: data) {
   //                            storedUserData.arrayWorkingDirectoryBookmark.remove(at: index)
   //                            print("JD122: \(storedUserData.arrayWorkingDirectoryBookmark.count)")
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
   //                        print("JD120: \(storedUserData.arrayWorkingDirectoryBookmark.count)")
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










 /*


  /*
   for selectedItem in self.rowSelection{
   let url = selectedItem.wrappedFolderURL
   storedUserData.storedFolderURL = url

   print("JD60: \(storedUserData.storedFolderURL.downloadURL)")
   // saveBookmarkData(for: url)

   //FIXME: - Is restoreFileAccess working? No.
   //It does load in the URL correctly, but the image does not show.
   let savedURL = restoreFileAccess(with: storedUserData.workingDirectoryBookmark)


   storedUserData.recoveredURL = savedURL//!.downloadURL

   prefs.arrayOfURLStrings.append(storedUserData.recoveredURL.path)
   print("JD65: prefs.arrayOfURLStrings \(prefs.arrayOfURLStrings)")
   print("JD61: storedUserData.recoveredURL \(storedUserData.recoveredURL)")

   //  CFURLCreateBookmarkData(nil, storedUserData.storedFolderURL.downloadURL as CFURL, options: [storedUserData.storedFolderURL], nil, nil, nil)

   print("JD36: cdFolders.count", cdFolders.count)

   // print("JD21: \(String(describing: restoredURL))")

   print("JD21: \(String(describing: savedURL))")

   if (CFURLStartAccessingSecurityScopedResource(url as CFURL?)) { //url as CFURL
   print("JD28: ACCESS GRANTED TO SECURITY RESOURCES in CD save array..")
   //prefs.arrayOfFolders.append(selectedItem.wrappedFolderURL)

   do {
   //LOAD AND SAVE URLS FOR IMAGES IN FOLDERS.
   //     storedUserData.url = selectedItem.wrappedFolderURL


   //storedUserData.storedFolderURL = selectedItem.wrappedFolderURL
   //TODO: - FOR loop in Security Access
   do {
   var error: NSError? = nil

   //                        //FIXME: - Will only work if a folder is a selected, NOT a photo.
   //                        for file in try Folder(path: selectedItem.wrappedFolderURL.path).files {  //storedUserData.url.path
   //                            print("JD63: \(file.url.downloadURL) - \(file.name) - \(file.path)")
   //
   //                            prefs.arrayOfURLStrings.append(String(describing: file.url.downloadURL))
   //
   //                            //TODO: - Working, image data stored properly.
   //                            print("JD62: file.url \(file.url)")
   //                            let imageData = try Data(contentsOf: file.url)
   //                            let img = UIImage(data: imageData)
   //                            //  storedUserData.photo = (img?.pngData())! //?? img?.jpegData(compressionQuality: 1)
   //
   //                            storedUserData.photo = (img?.jpegData(compressionQuality: 1))!//.append(img)
   //                            //Image(uiImage: UIImage(data: student.picture ?? Data()) ?? UIImage())
   //
   //                            //storedUserData.arrayPhotoURLs.append(file.url.downloadURL) //(String(describing: file.url))
   //                        }
   } catch {
   print("JD19: Catch Error", error)
   }
   //  saveBookmarkData(for: selectedItem.wrappedFolderURL)
   // saveBookmarkData(for: storedUserData.storedFolderURL)
   CFURLStopAccessingSecurityScopedResource(url as CFURL?) // <- and here
   }
   try? self.context.save()
   } else {
   print("JD22: Failed access to security scoped resources.")
   }

   // print("JD04: prefs.arrayOfFolders : \(prefs.arrayOfFolders)")
   //  print("JD05: prefs.arrayOfURLStrings : \(prefs.arrayOfURLStrings)")
   // print("JD06: storedUserData.arrayPhotoURLs: \(storedUserData.arrayPhotoURLs)")
   } */

  //storedUserData.url.path
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
  url = restoreFileAccess(with: storedUserData.workingDirectoryBookmark)!

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
  print("JD00: storedUserData.arrayPhotoURLs: \(storedUserData.arrayPhotoURLs)")
  //prefs.arrayOfFolders.removeAll()
  for selectedItem in self.rowSelection{
  let url = selectedItem.wrappedFolderURL
  storedUserData.storedFolderURL = url

  print("JD60: \(storedUserData.storedFolderURL.downloadURL)")
  // saveBookmarkData(for: url)

  //FIXME: - Is restoreFileAccess working? No.
  //It does load in the URL correctly, but the image does not show.
  let savedURL = restoreFileAccess(with: storedUserData.workingDirectoryBookmark)

  storedUserData.recoveredURL = savedURL!//!.downloadURL

  prefs.arrayOfURLStrings.append(storedUserData.recoveredURL.path)
  print("JD65: prefs.arrayOfURLStrings \(prefs.arrayOfURLStrings)")
  print("JD61: storedUserData.recoveredURL \(storedUserData.recoveredURL)")

  //  CFURLCreateBookmarkData(nil, storedUserData.storedFolderURL.downloadURL as CFURL, options: [storedUserData.storedFolderURL], nil, nil, nil)

  print("JD36: cdFolders.count", cdFolders.count)

  // print("JD21: \(String(describing: restoredURL))")

  print("JD21: \(String(describing: savedURL))")

  if (CFURLStartAccessingSecurityScopedResource(url as CFURL?)) { //url as CFURL
  print("JD28: ACCESS GRANTED TO SECURITY RESOURCES in CD save array..")
  //prefs.arrayOfFolders.append(selectedItem.wrappedFolderURL)

  do {
  //LOAD AND SAVE URLS FOR IMAGES IN FOLDERS.
  //     storedUserData.url = selectedItem.wrappedFolderURL


  //storedUserData.storedFolderURL = selectedItem.wrappedFolderURL
  //TODO: - FOR loop in Security Access
  do {
  var error: NSError? = nil

  //FIXME: - Will only work if a folder is a selected, NOT a photo.
  for file in try Folder(path: selectedItem.wrappedFolderURL.path).files {  //storedUserData.url.path
  print("JD63: \(file.url.downloadURL) - \(file.name) - \(file.path)")

  prefs.arrayOfURLStrings.append(String(describing: file.url.downloadURL))

  //TODO: - Working, image data stored properly.
  print("JD62: file.url \(file.url)")
  let imageData = try Data(contentsOf: file.url)
  let img = UIImage(data: imageData)
  //  storedUserData.photo = (img?.pngData())! //?? img?.jpegData(compressionQuality: 1)

  storedUserData.photo = (img?.jpegData(compressionQuality: 1))!//.append(img)
  //Image(uiImage: UIImage(data: student.picture ?? Data()) ?? UIImage())

  //storedUserData.arrayPhotoURLs.append(file.url.downloadURL) //(String(describing: file.url))
  }
  } catch {
  print("JD19: Catch Error", error)
  }
  //  saveBookmarkData(for: selectedItem.wrappedFolderURL)
  // saveBookmarkData(for: storedUserData.storedFolderURL)
  CFURLStopAccessingSecurityScopedResource(url as CFURL?) // <- and here
  }
  try? self.context.save()
  } else {
  print("JD22: Failed access to security scoped resources.")
  }
  print("JD04: prefs.arrayOfFolders : \(prefs.arrayOfFolders)")
  print("JD05: prefs.arrayOfURLStrings : \(prefs.arrayOfURLStrings)")
  print("JD06: storedUserData.arrayPhotoURLs: \(storedUserData.arrayPhotoURLs)")
  }
  }

  private func saveBookmarkData(for workDir: URL) { //URL //for workDir: URL //[URL: Data]
  do {
  let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: nil, relativeTo: nil)

  // save in UserDefaults
  storedUserData.workingDirectoryBookmark = bookmarkData
  print("JD22: \(storedUserData.workingDirectoryBookmark)")
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

  //storedUserData.storedFolderData = try! Data.init(contentsOf: url)
  //    selectedItem. = try! Data.init(contentsOf: url)
  //storedUserData.storedFolderURL) //selectedItem.wrappedURL

  // print("JD31: storedUserData.storedFolderData: ", storedUserData.storedFolderData)

  // storedUserData.workingDirectoryBookmark)//storedUserData.workingDirectoryBookmark)

  //    CFURLCreateBookmarkData(nil, storedUserData.storedFolderURL.downloadURL as CFURL, options: [storedUserData.storedFolderURL], nil, nil, nil)

  //    let url = selectedItem.wrappedFolderURL
  */
 // */
