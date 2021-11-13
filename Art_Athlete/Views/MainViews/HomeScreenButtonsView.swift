//
//  HomeScreenButtonsView.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-02.
//
import SwiftUI
import UniformTypeIdentifiers
import Files


struct HomeScreenButtonsView: View {
    //@ObservedObject var dataProvider = DataProvider.shared
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    @Environment(\.managedObjectContext) var context
    @State var isAddingPhotos: Bool = false
    //@State var isImporting: Bool = false
    // @Binding var startSession: Bool
    @State var error = ""

    @State var isRandom: Bool = true
    //var folderData : FetchedResults<PhotoFolders>

    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors: []
    ) var cdFolders : FetchedResults<PhotoFolders>

    // Core Data variables
    @State var cdSelection = Set<PhotoFolders>()

    @State private var editMode: EditMode = .inactive
    @State var cdEditMode = EditMode.inactive

    //@State private var items: [PhotoFolders] = []

    //@FetchRequest(entity: PhotoFolders.entity(), sortDescriptors:[])
    //var cdNumbers: FetchedResults<PhotoFolders>

             /*\___/\ ((
              \`@_@'/  ))
              {_:Y:.}_//
    ----------{_}^-'{_}----------*/

    //MARK: - VIEW
    var body: some View {
        NavigationView {
            VStack {
                // FileImporterView() //This loads in photos MARK: [BLUE BOX]
                //LoadFoldersButton()
                FoldersView(folderData: cdFolders)

                LoadFoldersButton()

//                LoadFoldersButton(isImporting: true)
                MultipleSelectRow(cdFolders: cdFolders)
            }
            .toolbar(content: {

            })
            /*
            .navigationBarItems(
                leading:
                    HStack {
                        NavigationLink(destination:
                                        VStack {
                            //FileImporterView()
                            //Spacer().frame(maxWidth: .infinity)

                           // timePickerView()

                        }) {
                            Label("Home", systemImage: "house")
                        }
                    } //,
                trailing:
                    EditButton()
                NavigationLink(destination: Text("Stats View")) {
                    Label("Settings", systemImage: "chart.bar.xaxis")//Text("Stats")
                }
            ) */
//            .navigationBarItems {
//
//                HStack {
//                    Button(action: showSettings) {
//                        Label("Settings", systemImage: "gearshape.fill")
//                    }
//                    Button(action: addFolders) { //
//                        Label("Add Folder", systemImage: "heart")
//                    }
//            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        // imageData[current].description = description
                        showSettings()
                        // showSheet = false
                    }, label: {
                        Image(systemName: "gearshape")
                    })
                }

               // ToolbarItem {

                //}
            }
        }

            VStack {  // MARK: - Shows the main screen (right side).
                //  FileImporterView()
                Spacer().frame(maxWidth: .infinity)

                countPickerView()
                timePickerView()

                Button("Start \(Image(systemName: "play.rectangle.fill"))") { //Button(" Start") {
                    //   NavBarView().loadLocalPhotos()
                    loadLocalPhotos()
                }
                .keyboardShortcut(.defaultAction)
                .padding(20)
                .padding(.bottom, 20) //.buttonStyle(ButtonOnOffStyle())
            } //End VStack.
        } //End UI.
    
       /*__/,|   (`\
     _.|o o  |_   ) )
   -(((---(((-----*/

    //MARK: - FUNCTIONS
    private func showSettings() {
        prefs.showSettings.toggle()
    }

    private func addFolders() {
        prefs.addFolder.toggle()
    //    isImporting = true
    }


    //Don't confuse with start timer in Timer.swift
    private func startTimer() {
        timeObject.isTimerRunning = true
        timeObject.startTime = Date()
        timeObject.progressValue = 0.0
        timeObject.timeDouble = 0.0
        TimerView(timeObject: _timeObject, prefs: _prefs).startTimer() //, startSession: $startSession
        let newSession = UserData(context: context)
        newSession.date = Date()
    }

    func loadLocalPhotos(){
        print("JD01 : loadLocalPhotos() : \(prefs.arrayOfURLStrings)")
        print("JD20: \(prefs.arrayOfURLStrings.count)")
        if (prefs.arrayOfURLStrings.count < prefs.homeManyPhotosToDraw[prefs.selectorCountTime]) {
            prefs.sPoseCount = prefs.arrayOfURLStrings.count
        } else {
            prefs.sPoseCount = prefs.homeManyPhotosToDraw[prefs.selectorCountTime]
        }

        if (isRandom) {
            prefs.arrayOfURLStrings.shuffle()
        }

        if (prefs.arrayOfURLStrings.isEmpty) {
            prefs.error = "Error loading images..." //Error Oct16 HomeView().error
        } else {
            //prefs.startBoolean.toggle()
            prefs.error = ""
            prefs.sURL = prefs.arrayOfURLStrings[0]
            prefs.localPhotos = true
            prefs.disableSkip = false
            timeObject.timeChosen = Double(prefs.time[prefs.selectorIndexTime]) //Double(prefs.time[prefs.selectorIndexTime])!

            startTimer()
            prefs.startSession = true
        }
    }  //End of load local photos

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
        //---------END FUNCTIONS---------

    }
}



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

 //                    userSettings.storedFolderURL = selectedFolder

 //                    userSettings.arrayOfFolderURLs.append(selectedFolder.path)
 //  userSettings.workingDirectoryBookmark = selectedFolder

 //Store photo urls in array.
 var arrayFiles = [String]()
 for i in try Folder(path: selectedFolder.path).files {
 arrayFiles.append(i.path) //Save the photo urls into the array.
 }

 //  for file in try Folder(path: selectedFolder.path).files {
 //userSettings.arrayPhotoURLs = [file]
 //                        userSettings.arrayOfFolderNames.append(file.name)
 //                        userSettings.arrayOfFolderURLs.append(file.path)
 //                        userSettings.arrayPhotoDownloadPath.append(file.url.downloadURL)
 //     }
 } catch { print("failed") }
 })






 //--------END VIEW-------------


 //        if (UIDevice.current.userInterfaceIdiom == .phone) {
 //            //  print("Not phone")
 //            Text("Only shows on iPhone.")
 //        }






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
