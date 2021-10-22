/* Josiah - Oct 29, 2020
 HomeScreen: 1st screen shown, called from ContentView   */

import SwiftUI
import UniformTypeIdentifiers
import Kingfisher
import struct Kingfisher.LocalFileImageDataProvider
import CoreData
import PhotosUI
import LocalAuthentication

//import MobileCoreServices
//import AuthenticationServices

struct HomeScreen: View {
    //@Environment(\.presentationMode) var presentationMode //This was on in 1st draft.
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    //@EnvironmentObject var userObject: UserObject
    //@EnvironmentObject var memory: Memory
    //@EnvironmentObject var store: CalendarStore
    @EnvironmentObject var user: UserEntity


    
    
    //@Environment(\.managedObjectContext) private var viewContext
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(entity: UserEntity.entity(), sortDescriptors: []) //, predicate: NSPredicate(format: "status != %@", Status.completed.rawValue)
    var entityData: FetchedResults<UserEntity>
    
  
    
    //@ObservedObject var objectUserEntity = UserEntity()
    
    
    // Memories.....
    //@State var currentMemory: Memory?
    
    //@FetchRequest(entity: Memory.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Memory.timestamp, ascending: false)], animation: .easeInOut) var results : FetchedResults<Memory>
    
    //@FetchRequest(fetchRequest: UserObject.getListItemFetchRequest()) var userObjects: FetchedResults<UserObject>
    
    //@Environment(\.managedObjectContext) var context
    //@Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var selectorPoseAmount = 3
    @State var poseAmount = ["5", "10", "20", "30"] //Image(systemName: "infinity")
    @State var localPhotoAmount = ["All", "10", "20", "30"]
    //@State private var selectorIndexTime = 1
    //@State var time = ["30", "60", "120", "300"]
    @State private var selectorPoseType = 4
    @State var pose = ["Nature","People","Wallpapers", "Interiors", "Animals"]
    
    @State var tag = ""
    @State var urlArray = [String]()
    @State var isRandom: Bool = true
    @State var name = ""
    @State var error = ""
    //@State var wifiError = ""
    
    //@State private var showingSheet = false
    //@State private var showStats = false
    //@State private var showSettings = false
    @State private var sort: Int = 0
    
    @State private var totalImagesImported: Int = 0
    
    @State var isImporting: Bool = false
    @State var fileName = "" //To save file URL in.

    //@Binding var isPresented: Bool //Josiah Oct16
    
    //Import photo files.
    @State var importFiles = false
    @State var files = [URL]()
    
    @State var openSessionStats = false

    @Binding var startSession: Bool
    
    @State private var checked = false
    //-------------END VARIABLES------------------------------------------------------------
    

    //-------------START VIEW------------------------------------------------------------
    var body: some View {
        
        //Popup main sheet: Has all display info for text and buttons for start sheet.
        VStack {
            HStack {
                Spacer()
                if (prefs.showMainScreen) {
                    HomeView()
                }
            }
            
            //Text(hope.posesToday)
            
            //List(userEntity, id: \.self)
            //print("userEntity: \(userEntity, id: \.self)")
            
            
            UserSessionStats()
            
            
            
            //SessionStats(close: $openSessionStats, memory: $currentMemory) //Database
            Spacer().frame(maxWidth: .infinity) //Attach bar to bottom
            
            //Text(newSession.posesToday)
            
            //Text("Poses drawn today: \(currentMemory?.userPoseCount)")
           // Text("\nuserPoseCount: \(memory.userPoseCount)\n")
            
            //UserObjectView(userObject: userObjects)
            /*
            List {
                ForEach(userObjects, id: \.self) { item in
                    NavigationLink(destination: UserObjectView(userObject: item)) {
                        Text("\(item.name) - \(item.posesDrawn)")
                    }
                }
                //.onDelete(perform: deleteItem)
                //.onMove(perform: moveItem)
            } */
            
            /*
            VStack{
                //Josiah
                //This is where the list of data is opened.
                ForEach(results){memory in
                    CardView(memory: memory)
                        .contextMenu {
                            Button("Delete"){
                               // context.delete(memory)
                               // try? context.save()
                            }
                            
                            Button("Edit"){
                                currentMemory = memory
                             //   createMemory.toggle()
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            */
            toggleSwitch()
            timePickerView()
            
            Button("Start") { //Button("\(Image(systemName: "play.rectangle.fill")) Start") {
                loadLocalPhotos()
            }
            .keyboardShortcut(.defaultAction)
            .padding(20)
            .padding(.bottom, 20) //.buttonStyle(ButtonOnOffStyle())
        }.padding()                                                              //End Vstack
    }//------------------END OF VIEW------------------------------------------------------
    
    
    
    
    
    //-------------------FUNCTIONS-----------------------------------------------
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func updateData() {
        let currentSession = UserEntity(context: viewContext)
        currentSession.posesToday = Int16(prefs.userSessionPoseCount)
    }
    
    public func updateDetails() {
        print("UPDATE DETAILS.")
        
    }
    
    func saveData() {
        //Create the id for the session. Each session has its own row in the data table.
        //hope.posesToday = 10
        //print(prefs.userSessionPoseCount)
        
        let newSession = UserEntity(context: viewContext)
        
        //prefs.sessionFirstStarted.toggle()
        
        //print(prefs.sessionFirstStarted)
        //
        
        //if (!prefs.sessionFirstStarted) {
            newSession.posePhotoLength = Int16(prefs.time[prefs.selectorIndexTime])
            let myFormatter = DateFormatter()
            myFormatter.timeStyle = .short
            let dateString = myFormatter.string(from: Date())
            //newSession.id = UUID()
            newSession.dateString = dateString
            //prefs.sessionFirstStarted.toggle()
            
        //} else {
            //just update the pose count
            newSession.posesToday = Int16(prefs.userSessionPoseCount)
        //}

        //Save the new session.
        do {
            try viewContext.save()
            print("\n New session saved.\n")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //Don't confuse with start timer in Timer.swift
    private func startTimer() {
        timeObject.isTimerRunning = true
        timeObject.startTime = Date()
        timeObject.progressValue = 0.0
        timeObject.timeDouble = 0.0
        TimerView(timeObject: _timeObject, prefs: _prefs).startTimer()
    }
    
    func loadLocalPhotos(){
        if (isRandom) {
            prefs.arrayOfURLStrings.shuffle()
        }
        
        if (prefs.arrayOfURLStrings.isEmpty) {
            prefs.error = "Error loading images..." //Error Oct16 HomeView().error
        } else {
            //passInfo()
            prefs.error = ""
            prefs.sURL = prefs.arrayOfURLStrings[0]
            prefs.localPhotos = true
            prefs.startBoolean.toggle()
            prefs.disableSkip = false
            //self.presentationMode.wrappedValue.dismiss() //Josiah Oct15 //Hide sheet.
            timeObject.timeLength = Double(prefs.time[prefs.selectorIndexTime]) //Double(prefs.time[prefs.selectorIndexTime])!
            prefs.sessionFirstStarted = false
             //<#T##self: UserSessionStats##UserSessionStats#>
                //.environmentObject(prefs)
            /*
            //Create the id for the session. Each session has its own row in the data table.
            let newSession = UserEntity(context: viewContext)
            newSession.posePhotoLength = Int16(prefs.time[prefs.selectorIndexTime])
            
            let myFormatter = DateFormatter()
            myFormatter.timeStyle = .short
            let dateString = myFormatter.string(from: Date())
            
            newSession.dateString = dateString
            //newSession.date = "hi"//dateString //.formatted(date: .abbreviated, time: .shortened)
            //newSession.posesToday = 
            
            //Save the new session.
            do {
                try viewContext.save()
                print("\n New session saved.\n")
            } catch {
                print(error.localizedDescription)
            } */
            //UserSessionStats().newSession()
            saveData()
            startTimer() //Do not start timer if there is no wifi.
            self.startSession = true //Tells the view to switch and start.
        }
    }  //End of load local photos
    
    
    //End of stack view.
}

/*
struct HomeDetails_Previews: PreviewProvider {
    @EnvironmentObject var prefs: GlobalVariables
    //@Binding var startSession: Bool --> This doesn't work. Must use line below.
    @State static var startSessionA = false
    
    static var previews: some View {
        //Text("Need to add view")
        //HomeScreen(isPresented: $prefs.showMainScreen)
        Group {
            HomeScreen(startSession: $startSessionA)
                .environmentObject(GlobalVariables())
                .environmentObject(TimerObject())
                .environmentObject(UserObject())
        }
    }
}

*/
















/*
 if (prefs.localPhotosView) {
 /*
  HStack {
  Text("Count:").padding(10)
  // How many poses
  Picker("Numbers", selection: $selectorPoseAmount) {
  ForEach(0 ..< localPhotoAmount.count) { index in
  Text(self.localPhotoAmount[index]).tag(index)
  }
  }
  .pickerStyle(SegmentedPickerStyle())
  }
  */
 }
 
 
 */



///Save the photos into the app.
///url is the variable name it comes in as
//
//
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
 print(error.localizedDescription)
 }
 CFURLStopAccessingSecurityScopedResource(url as CFURL) // <- and here
 
 }
 else {
 print("Permission error!")
 }
 }
 
 if (prefs.unsplashPhotosView) {
 HStack {
 Text("Photos:").padding(10)
 // How many poses
 Picker("Numbers", selection: $selectorPoseAmount) {
 ForEach(0 ..< poseAmount.count) { index in
 Text(self.poseAmount[index]).tag(index)
 }
 }
 .pickerStyle(SegmentedPickerStyle())
 }
 }//End if
 
 if (prefs.unsplashPhotosView) {
 // Pose TYPE (face, animale, etc) Select
 if !(prefs.collection) {
 Picker("Poses", selection: $selectorPoseType) {
 ForEach(0 ..< pose.count) { index in
 Text(self.pose[index]).tag(index)
 }
 }
 .pickerStyle(SegmentedPickerStyle())
 }
 
 TextField("Enter photo tag(s)...", text: $prefs.tag).padding(15)
 TextField("Enter photo collection name...", text: $prefs.collectionName).padding(15)
 
 CollectionButtons()
 
 }
 
 //Button("\(Image(systemName: "play.rectangle.fill")) Start") {
 Button("Start") {
 if (prefs.unsplashPhotosView) {
 loadUnsplashPhotos() { (urlData) in
 //print("\nurlData: \(urlData.count)\n")
 }
 }
 else if (prefs.localPhotosView) {
 loadLocalPhotos()
 prefs.localPhotos = true
 prefs.disableSkip = false
 }
 }.padding(20)
 .padding(.bottom, 20)
 //.buttonStyle(ButtonOnOffStyle())
 
 */



/*  IMPORTANT DO NOT DELETE
 //load Unsplash Photos
 func loadUnsplashPhotos(completion: @escaping([Photo]) -> Void){
 var apiData :[Photo] = []
 
 DispatchQueue.main.asyncAfter(deadline: .now()) {//DispatchQueue.global(qos: .background).async {
 apiData = prefs.randomImages.loadData(pose: prefs.sPose, count: prefs.sPoseCount, collection: prefs.collectionID) //?? nil
 
 //This loads before JSON finishes in Model.swift
 DispatchQueue.main.async {
 print("\n* apiData: \(apiData.count) *")
 completion(apiData)
 }
 }
 
 DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
 if (prefs.randomImages.photoArray.isEmpty) {
 //self.wifiError = "Error loading images, check wifi connection."
 //self.error = "Unsplash photo loading limits reached this hour, they are reset at the top of every hour."
 } else {
 prefs.sURL = (prefs.randomImages.photoArray[0].urls["\(prefs.imageQuality)"]!)
 
 prefs.sPhotographer = (prefs.randomImages.photoArray[0].user?.name)! // ?? "nil"
 print("\ncount: \(prefs.randomImages.photoArray.count)\n")
 prefs.portfolioURL.append(prefs.randomImages.photoArray[0].user?.username ?? "davidprspctive")
 prefs.portfolioURL.append("?utm_source=Drawing_Reference_Timer&utm_medium=referral")
 //print("\n** \(String(describing: prefs.portfolioURL)) **\n")
 //self.presentationMode.wrappedValue.dismiss() //Josiah Oct15 //Hide sheet.
 startTimer() //Do not start timer if there is no wifi.
 }
 
 //prefetchPhotos()
 prefs.disableSkip = false//prefs.disableSkip.toggle()
 print("\n * This is loaded after JSON is loaded. *\n")
 //prefs.myURL = URL(string: prefs.sURL)!
 }
 } ///End of load Unsplash photos
 */


/*
 func passInfo() {
 /*
  if (prefs.collection) {
  prefs.sPose = ""
  } else {
  prefs.sPose = pose[selectorPoseType]
  }
  
  //IF user choose their own photos, they can play as many as they select.
  if (prefs.unsplashPhotosView == true) {
  print("\n poop")
  prefs.sPoseCount = Int(poseAmount[selectorPoseAmount])!
  } else {
  } */
 
 //prefs.tag = tag
 //timeObject.timeLength = Double(time[selectorIndexTime])!
 }
 
 */
