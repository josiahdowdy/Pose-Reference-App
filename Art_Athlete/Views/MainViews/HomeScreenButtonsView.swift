//
//  HomeScreenButtonsView.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-02.
//
import SwiftUI
import UniformTypeIdentifiers


struct HomeScreenButtonsView: View {
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    @Environment(\.managedObjectContext) var context
    @State var isAddingPhotos: Bool = false
    @State var isImporting: Bool = false
    // @Binding var startSession: Bool
    @State var error = ""

    @State var isRandom: Bool = true
    //var folderData : FetchedResults<PhotoFolders>

    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors: []
    ) var folderData : FetchedResults<PhotoFolders>


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
    ////\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
    //-----------------START VIEW------------------------
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                VStack {
                    FileImporterView() //This loads in photos.

                    //LoadFoldersButton()
                    //Text("Display the button options here.")
                    FoldersView(folderData: folderData) 
                }
                // .navigationViewStyle(.stack)
                //.navigationTitle("Main Screen")
                //.navigationViewStyle(StackNavigationViewStyle())
                // .phoneOnlyStackNavigationView()
                //  .iPadOnly()
                .padding()

                // .navigationBarTitle("Art Athlete")

                .navigationBarItems(
                    leading:
                        HStack {
                            NavigationLink(destination:
                                            VStack {
                                //FileImporterView()
                                Spacer().frame(maxWidth: .infinity)

                                timePickerView()


                                Button("Start") { //Button("\(Image(systemName: "play.rectangle.fill")) Start") {
                                    //   NavBarView().loadLocalPhotos()
                                    loadLocalPhotos()
                                }
                                .keyboardShortcut(.defaultAction)
                                .padding(20)
                                .padding(.bottom, 20) //.buttonStyle(ButtonOnOffStyle())
                            }) {
                                Label("Home", systemImage: "house")
                            }
                            NavigationLink(destination: Text("Study View")) {
                                Label("Study", systemImage: "menucard")
                            }
//                            //Load new folders.
//                            NavigationLink(destination: Text("ok")) {
//                               LoadFoldersButton()//Label("Study", systemImage: "menucard")
//                            }
                        },
                    trailing:
                        NavigationLink(destination: Text("Stats View")) {
                            Label("Settings", systemImage: "chart.bar.xaxis")//Text("Stats")
                        }
                )
                .toolbar {
                    Button(action: showSettings) {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    Button(action: addFolders) {
                        Label("Add Folder", systemImage: "gearshape.fill")
                    }


                }
                
            } else {
                // Fallback on earlier versions
                Text("Version is before iOS 15")
            }

            VStack {
              //  FileImporterView()
                Spacer().frame(maxWidth: .infinity)

                timePickerView()

                Button("Start") { //Button("\(Image(systemName: "play.rectangle.fill")) Start") {
                    //   NavBarView().loadLocalPhotos()
                    loadLocalPhotos()
                }
                .keyboardShortcut(.defaultAction)
                .padding(20)
                .padding(.bottom, 20) //.buttonStyle(ButtonOnOffStyle())
            }
            
            
        }



//        if (UIDevice.current.userInterfaceIdiom == .phone) {
//            //  print("Not phone")
//            Text("Only shows on iPhone.")
//        }





    } //--------END VIEW-------------
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


    
    //---------START FUNCTIONS-------
    private func showSettings() {
        prefs.showSettings.toggle()
    }

    private func addFolders() {
        prefs.addFolder.toggle()
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
            //ContentView().$startSession = true
            
            
            
            //self.presentationMode.wrappedValue.dismiss() //Josiah Oct15 //Hide sheet.
            //   self.startSession = true //Tells the view to switch and start.
            //ContentView().startSession = true
            //prefs.sessionFirstStarted = false
            //saveData()
            //TimerView().newUserInfo()
            //passInfo()
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
