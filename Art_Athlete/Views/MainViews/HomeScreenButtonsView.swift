//  HomeScreenButtonsView.swift - Art_Athlete
//  Created by josiah on 2021-11-02.

import SwiftUI
import UniformTypeIdentifiers
import Files
import SlideOverCard
import Laden


struct HomeScreenButtonsView: View {
    //@ObservedObject var dataProvider = DataProvider.shared
    
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    @Environment(\.managedObjectContext) var context
    @State var isAddingPhotos: Bool = false
    @State var showPhotos: Bool = false
    @State private var isLoading = true
    @State private var isloadingPhotos = false

    @State public var totalPhotosLoaded = 0

    @State var rowSelection = Set<String>()

   


    //@State var isImporting: Bool = false
    // @Binding var startSession: Bool
    @State var error = ""

    @State var url : URL = URL(fileURLWithPath: "nil")

 

    //@State var cdSelection = Set<PhotoFolders>()
    @State var cdSelection = Set<FoldersEntity>()

    //@State private var editMode: EditMode = .inactive
    //@State var cdEditMode = EditMode.inactive

    @State private var shouldLoadingView = true


    //MARK: - VIEW FOR ANIMATION
    var laden: some View {
        Laden.CircleLoadingView(
            color: .white, size: CGSize(width: 30, height: 30), strokeLineWidth: 3
        )
    }

    /*\___/\ ((
     \`@_@'/  ))
     {_:Y:.}_//
     ----------{_}^-'{_}----------*/

    //MARK: - VIEW
    var body: some View {
        NavigationView {
            VStack {
                //FileImporterView() //This loads in photos MARK: [BLUE BOX]

                HStack {
                    LoadFoldersButton(totalPhotosLoaded: $totalPhotosLoaded, isloadingPhotos: $isloadingPhotos)

//                    Button(action: {
//                        storedUserData.arrayWorkingDirectoryBookmark.removeAll()
//                    }, label: {
//                        Image(systemName: "folder.fill.badge.minus")
//                    })

                 //   Text(String(totalPhotosLoaded))
                }

                //LoadFoldersButton(isImporting: true)
                MultipleSelectRow(rowSelection: $rowSelection, totalPhotosLoaded: $totalPhotosLoaded)

                if UIDevice.current.userInterfaceIdiom == (.phone) {
                    countPickerView()
                    timePickerView()
                    StartButton(rowSelection: $rowSelection) }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    settingsButton()
                }
                
                //ToolbarItem(placement: .navigationBarTrailing) { HStack{ } }
            }

            VStack {  // MARK: - Shows the main screen (right side).
                VStack {
                    //  FileImporterView()
                    if !(isloadingPhotos) {
                        // laden.hidden()
                        Text(prefs.error)
                       // Text(String("Array Bookmarks: \(storedUserData.arrayWorkingDirectoryBookmark.count)"))

                        Spacer().frame(maxWidth: .infinity)

                        countPickerView()
                        timePickerView()
                        StartButton(rowSelection: $rowSelection)


                    } else {
                        // laden
                        Text("Loading Photos...please wait...")
                    }
                } //End VStack.
            }
            .if(isloadingPhotos) { $0.foregroundColor(.blue) } //.overlay(Laden.BarLoadingView()) } //.foregroundColor(.red) }
        } //NavigationView
    } //End UI.

    /*__/,|   (`\
     _.|o o  |_   ) )
     -(((---(((-----*/

    //MARK: - FUNCTIONS
}

//MARK: - Extension
extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}

/* IMPORTANT - WORKS. HEART BUTTON. FUNCTIONS TO LOAD PHOTO.
 //- AsyncImage. UI.
 if (showPhotos) {
 // Image(uiImage: UIImage(data: storedUserData.photo) ?? UIImage(named: "/Users/josiahdowdy/Library/Mobile Documents/com~apple~CloudDocs/Screenshots") ?? UIImage())
 Text("Enjoy!")
 if #available(iOS 15.0, *) {
 AsyncImage(url: url)
 .frame(width: 100, height: 100)
 if !(prefs.arrayOfURLStrings.isEmpty) {
 AsyncImage(url: URL(string: prefs.arrayOfURLStrings[0]))
 .frame(width: 100, height: 100)
 }
 } else {
 // Fallback on earlier versions
 }
 } //

 private var showPhotoButton: some View {
 return Button(action: showPhotoFunction) {
 Image(systemName: "heart")
 }
 }


 private func showPhotoFunction() {
 //- Show Photo Here.
 url = restoreFileAccess(with: storedUserData.workingDirectoryBookmark)!

 //BOOKMARK URL IS WORKING. NOW, ADD IT TO AN ARRAY.
 if (url.startAccessingSecurityScopedResource()) {
 print("JD67: TRUE")
 prefs.arrayOfURLStrings.append(String(describing: url))
 print("JD68: prefs.arrayOfURLStrings \(prefs.arrayOfURLStrings[0])")
 } else {
 print("JD67: False")
 }

 if !(showPhotos) {
 showPhotos = true
 } else {
 showPhotos = false
 }

 print("JD69: showPhoto - ", showPhotos)
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
 //    saveBookmarkData(for: url)
 }
 return url
 } catch {
 print("Error resolving bookmark:", error)
 return nil
 }
 } */


/*

 //           let bookmarkedData = storedUserData.workingDirectoryBookmark//URL(string: storedUserData.workingDirectoryBookmark)
 // let imageData = UIImage(data: bookmarkedData)// try Data(contentsOf: bookmarkedData) //storedUserData.recoveredURL.downloadURL)//cdFolders[0].wrappedFolderURL)

 //      print("JD44: bookmarkedData \(bookmarkedData)")

 // let img = UIImage(data: try bookmarkedData.toData())
 //    print("JD45: img \(String(describing: img))")


 //   storedUserData.photo = (img?.pngData())!
 //let imageData = try Data(contentsOf: bookmarkedData ) //storedUserData.recoveredURL
 //            print("JD44: imageData \(String(describing: imageData))")
 //       let img = UIImage(data: bookmarkedData)
 //        print("JD45: img \(String(describing: img))")
 //
 //       storedUserData.photo = (img?.jpegData(compressionQuality: 1.0))! //img?.pngData()

 */
//
//struct HomeScreenButtonsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeScreenButtonsView()
//    }
//}




//  trailing:
//EditButton()
//                    Button(action: {
//                        withAnimation {
//                            isImporting = false
//
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                isImporting = true
//                            }
//                        }
//                    }, label: {
//                        Image(systemName: "folder.badge.plus")
//                    })

//AddButton(editMode: $editMode, isImporting: isImporting)
//                        NavigationLink(destination: Text("Stats View")) {
//                            Label("Settings", systemImage: "chart.bar.xaxis")//Text("Stats")
//                        }
//                    )
//                .toolbar {
//                    Button(action: showSettings) {
//                        Label("Settings", systemImage: "gearshape.fill")
//                    }
//                }



//            List(selection: $cdSelection) {
//                //ForEach(cdNumbers, id: \.id) { number in
//                ForEach(cdNumbers, id: \.self) { data in
//                    //  ForEach(items) { data in
//                    // Text("Row \(data)")  #IMPORTANT# Shows all the data in the row.
//                    // Text(data.wrappedFolderName)
//                    Text(data.name ?? "POOP")
//                }
//                .onDelete(perform: cdOnSwipeDelete)
//                //                        .onDelete(perform: onDelete)
//                //                        .onMove(perform: onMove)
//                //                        .onMove(perform: relocate)
//            }
//
//            .navigationBarTitle("P2: \(cdSelection.count)")
//            .environment(\.editMode, self.$cdEditMode)
//            .navigationBarItems(leading: cdDeleteButton, trailing: EditButton())
//
//

/*
 .fileImporter(
 isPresented: $isImporting, allowedContentTypes: [UTType.folder], //, UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
 allowsMultipleSelection: false,
 onCompletion: { result in
 do {
 guard let selectedFolder: URL = try result.get().first else { return }
 //
 //                        let name = selectedFolder.lastPathComponent
 //                        let url = selectedFolder
 //                        let note = Note(name: name, isFolderSelected: false, url: url)

 //  DataProvider.shared.create(note: note)

 //                    storedUserData.storedFolderURL = selectedFolder

 //                    storedUserData.arrayOfFolderURLs.append(selectedFolder.path)
 //  storedUserData.workingDirectoryBookmark = selectedFolder

 //Store photo urls in array.
 var arrayFiles = [String]()
 for i in try Folder(path: selectedFolder.path).files {
 arrayFiles.append(i.path) //Save the photo urls into the array.
 }

 //  for file in try Folder(path: selectedFolder.path).files {
 //storedUserData.arrayPhotoURLs = [file]
 //                        storedUserData.arrayOfFolderNames.append(file.name)
 //                        storedUserData.arrayOfFolderURLs.append(file.path)
 //                        storedUserData.arrayPhotoDownloadPath.append(file.url.downloadURL)
 //     }
 } catch { print("failed") }
 })






 //--------END VIEW-------------


 //        if (UIDevice.current.userInterfaceIdiom == .phone) {
 //            //  print("Not phone")
 //            Text("Only shows on iPhone.")
 //        }

 /*
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
  print("Permission error!")
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
  */





 /*
  ToolbarItem(placement: .navigationBarLeading) {
  Button(action: {
  //   iOSSettingsBarView()

  }) {
  //Image(systemName: "gearshape.fill") }
  Text("Settings") }
  }

  ToolbarItem(placement: .navigationBarTrailing) {
  Button(action: {
  self.isAddingPhotos = true }) {
  Image(systemName: "plus") }
  */


 //  }




 //-----END VARIABLES------
 //    init() {
 //        let coloredAppearance = UINavigationBarAppearance()
 //        coloredAppearance.configureWithOpaqueBackground()
 //        coloredAppearance.backgroundColor = .systemBrown
 //        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
 //        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
 //
 //        UINavigationBar.appearance().standardAppearance = coloredAppearance
 //        UINavigationBar.appearance().compactAppearance = coloredAppearance
 //        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
 //
 //        UINavigationBar.appearance().tintColor = .white
 //    }
 //-----END VARIABLES------
 //    init() {
 //        let coloredAppearance = UINavigationBarAppearance()
 //        coloredAppearance.configureWithOpaqueBackground()
 //        coloredAppearance.backgroundColor = .systemBrown
 //        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
 //        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
 //
 //        UINavigationBar.appearance().standardAppearance = coloredAppearance
 //        UINavigationBar.appearance().compactAppearance = coloredAppearance
 //        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
 //
 //        UINavigationBar.appearance().tintColor = .white
 //    }
 */
