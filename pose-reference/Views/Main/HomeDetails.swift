/*
 Josiah - Oct 29, 2020
 HomeDetails:
 1st screen shown
 User enters search data here.
 Calls Model.swift to load photo JSON from Unsplash, when user presses Start.
 */


import SwiftUI
import UniformTypeIdentifiers
import Kingfisher
import struct Kingfisher.LocalFileImageDataProvider
import MobileCoreServices
//import AuthenticationServices

struct HomeDetails: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: Settings
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
    @State var wifiError = ""
    
    @State private var showingSheet = false
    @State private var showStats = false
    @State private var showSettings = false
    @State private var sort: Int = 0
    
    @State private var totalImagesImported: Int = 0
    
    @State var isImporting: Bool = false
    @State var fileName = "" //To save file URL in.
    
    ///Binding means value comes from outside the view scope. 
    @Binding var isPresented: Bool
    
    ///Import photo files.
    @State var importFiles = false
    @State var files = [URL]()
    
    var body: some View {
        //Popup main sheet: Has all display info for text and buttons for start sheet.
        HStack {
            Spacer()
            
            VStack(alignment: .center) {
                MenuView(unsplashPhotos: $prefs.unsplashPhotosView, localPhotos: $prefs.localPhotosView, showStats: $showStats, showSettings: $showSettings)
                    .sheet(isPresented: $showStats) {
                        return StatsView()
                            .environmentObject(self.userObject)
                            .environmentObject(self.prefs)
                            .environmentObject(self.timeObject)
                    }
                    .sheet(isPresented: $showSettings) {
                        return SettingsView()
                            .environmentObject(self.userObject)
                            .environmentObject(self.prefs)
                            .environmentObject(self.timeObject)
                    }
                
                Text("Art Athlete").font(.largeTitle).padding(.top, 20)
                Text("\(prefs.userName)").padding(.top, 10) //the artist
                // Button("\(Image(systemName: "gearshape.fill"))")
                //Text("Poses drawn today: \(userObject.totalPosesDrawnToday)").padding(.top, 10)
                
                ///Wifi message
                if !(error.isEmpty) {
                    if !(prefs.localPhotosView) { //|| !(unsplashPhotos))
                        //Text("\(Image(systemName: "wifi.exclamationmark")) \(wifiError)").font(.footnote).padding(20) //xmark.octagon.fill
                        Text(wifiError)
                    }
                    
                   Text(error)
                    
                }
                
                /// Import local photos
                if (prefs.localPhotosView) {
                    Button(action: {
                        isImporting = false
                        
                        //fix broken picker sheet
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isImporting = true
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "photo")
                                .font(.system(size: 20))
                            
                            Text("Files \(prefs.sPoseCount)")
                                .font(.headline)
                        }.padding(6)
                        
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        //.padding(.horizontal)
                    })
                }
            } //End of Vstack
            .toolbar {
                Menu("Action") {
                }
            }
            
            Spacer() //Space in Vstack to the button for files
        } //End of HStack
        .padding()
        
        .fileImporter(
            isPresented: $isImporting, allowedContentTypes: [UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
            allowsMultipleSelection: true,
            onCompletion: { result in
                do {
                    let selectedFiles = try result.get()
                    prefs.sPoseCount = selectedFiles.count
                    //let oneURL :String
                    // for i in 1...totalFiles { files.append(saveFile(url: selectedFiles[i]))     }
                    for i in 0...(selectedFiles.count-1) { //selectedFiles.count
                        //print("\n\(i)") //This prints out the photo data
                        saveFile(url: selectedFiles[i])
                        //prefs.arrayOfURLStrings
                    }
                    self.error = ""
                } catch {
                    // Handle failure.
                    print("failed")
                }
            })
        
        //} //End of Vstack
        ///End of top part of homeDetails (before bottom rows and start.
        //}
        //} //End HStack1 poo
        
        Spacer().frame(maxWidth: .infinity) //Attach bar to bottom
        
        
        VStack {
            Text("Random")
                .foregroundColor(isRandom ? .green : .gray)
            Toggle("Random", isOn: $isRandom)
                .labelsHidden()
        }.padding()
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 2)
                    .foregroundColor(isRandom ? .green : .gray)
            )
        
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
    }//End of View
    
    ///Start of functions.
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    ///Save the photos into the app.
    ///url is the variable name it comes in as
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
    
    func passInfo() {
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
        }
        
        prefs.tag = tag
        timeObject.timeLength = Double(time[selectorIndexTime])!
    }
    
    func loadLocalPhotos(){
        if (isRandom) {
            prefs.arrayOfURLStrings.shuffle()
        }
        
        if (prefs.arrayOfURLStrings.isEmpty) {
            self.error = "Error loading images..."
        } else {
            passInfo()
            prefs.startBoolean.toggle()
            //self.presentationMode.wrappedValue.dismiss() //Hide sheet.
            
            prefs.sURL = prefs.arrayOfURLStrings[0]
            self.presentationMode.wrappedValue.dismiss() //Hide sheet.
            startTimer() //Do not start timer if there is no wifi.
            
            //prefs.disableSkip = true//.toggle()
        }
    }  ///End of load local photos
    
    ///load Unsplash Photos
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
                self.wifiError = "Error loading images, check wifi connection."
                self.error = "Unsplash photo loading limits reached this hour, they are reset at the top of every hour."
            } else {
                prefs.sURL = (prefs.randomImages.photoArray[0].urls["\(prefs.imageQuality)"]!)
                
                prefs.sPhotographer = (prefs.randomImages.photoArray[0].user?.name)! // ?? "nil"
                print("\ncount: \(prefs.randomImages.photoArray.count)\n")
                prefs.portfolioURL.append(prefs.randomImages.photoArray[0].user?.username ?? "davidprspctive")
                prefs.portfolioURL.append("?utm_source=Drawing_Reference_Timer&utm_medium=referral")
                //print("\n** \(String(describing: prefs.portfolioURL)) **\n")
                self.presentationMode.wrappedValue.dismiss() //Hide sheet.
                startTimer() //Do not start timer if there is no wifi.
            }
            
            //prefetchPhotos()
            prefs.disableSkip = false//prefs.disableSkip.toggle()
            print("\n * This is loaded after JSON is loaded. *\n")
            //prefs.myURL = URL(string: prefs.sURL)!
        }
    } ///End of load Unsplash photos
    
    
    //Don't confuse with start timer in Timer.swift
    private func startTimer() {
        timeObject.isTimerRunning = true
        timeObject.startTime = Date()
        timeObject.progressValue = 0.0
        timeObject.timeDouble = 0.0
        TimerView(timeObject: _timeObject, prefs: _prefs).startTimer()
    }
}



/*
 struct HomeDetails_Previews: PreviewProvider {
 static var previews: some View {
 Text("Need to add view")
 // HomeDetails()
 }
 }
 
 //////
 
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


