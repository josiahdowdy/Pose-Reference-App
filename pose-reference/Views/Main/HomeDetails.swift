/* Josiah - Oct 29, 2020
 HomeDetails: 1st screen shown, called from ContentView   */

import SwiftUI
import UniformTypeIdentifiers
import Kingfisher
import struct Kingfisher.LocalFileImageDataProvider
//import MobileCoreServices
//import AuthenticationServices

struct HomeDetails: View {
    //@Environment(\.presentationMode) var presentationMode //This was on in 1st draft.
    @EnvironmentObject var prefs: Settings
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var userObject: UserObject
    
    @State private var selectorPoseAmount = 3
    @State var poseAmount = ["5", "10", "20", "30"] //Image(systemName: "infinity")
    @State var localPhotoAmount = ["All", "10", "20", "30"]
    @State private var selectorIndexTime = 1
    @State var time = ["30", "60", "120", "300"]
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
    @State var currentMemory: Memory?

    @Binding var startSession: Bool

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
            
            SessionStats(close: $openSessionStats, memory: $currentMemory)
            
            Spacer().frame(maxWidth: .infinity) //Attach bar to bottom
            
            Text("Random")
                .foregroundColor(isRandom ? .green : .gray)
            Toggle("Random", isOn: $isRandom)
                .labelsHidden()
             .overlay(
             RoundedRectangle(cornerRadius: 15)
             .stroke(lineWidth: 2)
             .foregroundColor(isRandom ? .green : .gray)
             )
            
            HStack {
                Text("Length:").padding(10)
                // Length time of pose
                Picker("Numbers", selection: $selectorIndexTime) {
                    ForEach(0 ..< time.count) { index in
                        Text(self.time[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
                         
            //Button("\(Image(systemName: "play.rectangle.fill")) Start") {
            
            Button("Start") {
                loadLocalPhotos()
            }
            .padding(20)
            .padding(.bottom, 20) //.buttonStyle(ButtonOnOffStyle())
             
        }.padding()                                                              //End Vstack
    }//End of View
    
    //Start of functions.
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
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
            timeObject.timeLength = Double(time[selectorIndexTime])!
            startTimer() //Do not start timer if there is no wifi.
            self.startSession = true //Tells the view to switch and start.
        }
    }  //End of load local photos

    //Don't confuse with start timer in Timer.swift
    private func startTimer() {
        timeObject.isTimerRunning = true
        timeObject.startTime = Date()
        timeObject.progressValue = 0.0
        timeObject.timeDouble = 0.0
        TimerView(timeObject: _timeObject, prefs: _prefs).startTimer()
    }
    //End of stack view.
}

struct HomeDetails_Previews: PreviewProvider {
    @EnvironmentObject var prefs: Settings
    //@Binding var startSession: Bool --> This doesn't work. Must use line below.
    @State static var startSessionA = false
    
    static var previews: some View {
        //Text("Need to add view")
        //HomeDetails(isPresented: $prefs.showMainScreen)
        Group {
            HomeDetails(startSession: $startSessionA)
                .environmentObject(Settings())
                .environmentObject(TimerObject())
                .environmentObject(UserObject())
        }
    }
}


















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
