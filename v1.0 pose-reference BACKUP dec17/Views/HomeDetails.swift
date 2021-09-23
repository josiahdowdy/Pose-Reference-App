/*
 Josiah - Oct 29, 2020
 HomeDetails:
 1st screen shown
 User enters search data here.
 Calls Model.swift to load photo JSON from Unsplash, when user presses Start.
 
 */

import SwiftUI
import class Kingfisher.ImagePrefetcher
import UniformTypeIdentifiers
import KingfisherSwiftUI
//import protocol Kingfisher.ImageDataProvider
import struct Kingfisher.LocalFileImageDataProvider
import MobileCoreServices
import UniformTypeIdentifiers

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
    @State private var selectorPoseType = 0
    @State var pose = ["Pose","Face","Landscape", "City", "Animal"]
    
    //@State private var selectorCollection :Int = 0
    //@State var collection = ["B&W","Insects", "Fruit", "Random"]
    @State var tag = ""
    
    @State var urlArray = [String]()
    
    @State var name = ""
    @State var error = ""
    @State var wifiError = ""

    @State private var showingSheet = false
    @State private var showStats = false
    
    @State private var totalImagesImported: Int = 0
    
    @State private var isImporting: Bool = false

    @State private var localPhotos = true
    @State private var unsplashPhotos = false
    
    //Test Youtube "Importing an image into Swift UI
    @State private var showingImagePicker = false
    //@State var selectedPhotoInArrayURL: URL
    @State private var inputImage: UIImage?

    
    var body: some View {
        //Popup main sheet: Has all display info for text and buttons for start sheet.
        HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Text("Artist Pose Reference").font(.largeTitle).padding(.top, 20)
                        //Text("\(userObject.userName)").padding(.top, 10) //the artist
                        Text("Poses drawn today: \(userObject.totalPosesDrawnToday)").padding(.top, 10)
                        if !(error.isEmpty) {
                            Text("\(Image(systemName: "wifi.exclamationmark")) \(wifiError)").font(.footnote).padding(20) //xmark.octagon.fill
                        }
                        if !(error.isEmpty) {
                            Text("\(Image(systemName: "xmark.octagon.fill")) \(error)").font(.footnote).padding(20) //
                        }
                        
                        Button("Stats") {
                            self.showStats.toggle()
                        }.sheet(isPresented: $showStats) {
                            StatsView(timeObject: _timeObject, prefs: _prefs, userObject: _userObject)
 
                        //.environmentObject(prefs: _prefs, timeObject: _timeObject)
                        //HomeDetails(prefs: _prefs, name: "Artist!")
                        }.padding(20)
                        
                        /// Toggle Local Photos
                        Toggle(isOn: $localPhotos) {
                            Text("Import photos")
                        }.padding()
                        
                        if !localPhotos {
                            Toggle(isOn: $unsplashPhotos) {
                                Text("Unsplash Photos")
                                }.padding()
                        }
                        
                        /// Import local photos
                        if localPhotos {
                            //Import files
                            HStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 20))
             
                                Text("Photo library")
                                    .font(.headline)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                            
                            Text("Total images: \(totalImagesImported)")
                        
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
                 
                                    Text("Files")
                                        .font(.headline)
                                }
                                
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .padding(.horizontal)
                            })
                        }
                    }
                    Spacer()
                }
        .padding()
        /*
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [UTType.plainText, UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
            allowsMultipleSelection: true, //false
            onCompletion: { result in
                    if let urls = try? result.get() {
                      // you can do with the file urls here
                        //prefs.randomImages.photoArray = urls.
                        totalImagesImported = urls.count
                        
                        let url = URL(string: "\(urls[0])")
                        //prefs.randomImages.photoArray = url
                        //prefs.sURL = url
                    }
                  }
        )   */
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [UTType.plainText, UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
            allowsMultipleSelection: true, //false
            onCompletion: { result in
                    if let urls = try? result.get() {
                        totalImagesImported = urls.count
                        //selectedPhotoInArrayURL = URL(string: "\(urls[0])") ?? URL(string: ")
                        print("urls: \(urls)")
                        print("urls[0] is: \(urls[0])")
                        let urlString = "\(urls)"
                        prefs.sURL = urlString
                        
                        prefs.myURL = URL(fileURLWithPath: prefs.sURL)
                        
                        print("\n\n** prefs.myURL: \(prefs.myURL) ** \n\n")
                
                        
                       // prefs.localURL = LocalFileImageDataProvider(fileURL: urls[0])
                    }
                  }
        )

        Spacer().frame(maxWidth: .infinity) //Attach bar to bottom
        
        Text("Session settings").fontWeight(.light).padding(.top, 10)
        
        if localPhotos {
            HStack {
                Text("Photos:").padding(10)
                // How many poses
                Picker("Numbers", selection: $selectorPoseAmount) {
                    ForEach(0 ..< localPhotoAmount.count) { index in
                        Text(self.localPhotoAmount[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        
        if unsplashPhotos {
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
        }
        
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

        if unsplashPhotos {
            // Pose TYPE (face, animale, etc) Select
            Picker("Poses", selection: $selectorPoseType) {
                ForEach(0 ..< pose.count) { index in
                    Text(self.pose[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        
        /*
        // Collection
        Picker("Collection: ", selection: $selectorCollection) {
            ForEach(0 ..< collection.count) { index in
                Text(self.collection[index]).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
 */
        
        TextField("Enter photo tag(s)...", text: $prefs.sTag).padding(15)
        
        Button("Start") {
            passInfo()
            prefs.startBoolean.toggle()
            
            if unsplashPhotos {
                loadUnsplashPhotos() { (urlData) in
                    //print("\nurlData: \(urlData.count)\n")
                }
            }
            else if localPhotos {
                loadLocalPhotos()
            }
        }.padding(.bottom, 20)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
         // you get from the urls parameter the urls from the files selected
    }
    
    func passInfo() {
        prefs.sPose = pose[selectorPoseType] //Type
        prefs.sPoseCount = Int(poseAmount[selectorPoseAmount])! //Amount (10)
        //prefs.timeLength = Int(time[selectorIndexTime])! //Time (30 seconds)
        //prefs.timeCountdown = Int(time[selectorIndexTime])!
        prefs.sTag = tag
        
        timeObject.timeLength = Double(time[selectorIndexTime])!

       // prefs.sURL = randomImages.photoArray[0].urls["full"]! //.append("&query=\(prefs.sPose)")
    }
    
    func loadLocalPhotos(){
        //prefs.sURL = url
    }
    
    func loadUnsplashPhotos(completion: @escaping([Photo]) -> Void){
        var apiData :[Photo] = []
        let imageQuality = "regular"

        //var returnedData:[Photo] = []
        DispatchQueue.main.asyncAfter(deadline: .now()) {//DispatchQueue.global(qos: .background).async {
            //if user tag not null     then
            if prefs.sTag.isEmpty  {
                apiData = prefs.randomImages.loadData(pose: prefs.sPose, count: prefs.sPoseCount)
            } else {
                apiData = prefs.randomImages.loadData(pose: prefs.sTag, count: prefs.sPoseCount)
            }
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
                prefs.sURL = (prefs.randomImages.photoArray[0].urls["\(imageQuality)"]!)
                self.presentationMode.wrappedValue.dismiss() //Hide sheet.
                startTimer() //Do not start timer if there is no wifi.
            }

            //prefetchPhotos()
            prefs.disableSkip.toggle()
            print("\n * This is loaded after JSON is loaded. *\n")
            prefs.myURL = URL(string: prefs.sURL)!
        }
    }
    
    //Don't confuse with start timer in Timer.swift
    private func startTimer() {
        timeObject.isTimerRunning.toggle()
        timeObject.startTime = Date()
        timeObject.progressValue = 0.0
        timeObject.timeDouble = 0.0
        TimerView(timeObject: _timeObject, prefs: _prefs).startTimer()
    }

    /*
    func prefetchPhotos() {
        //Prefetch: You could prefetch some images and cache them before you display them on the screen.
        //let kf = KFImage.ImageBinder.ObjectWillChangePublisher.prefe
        
        //let urls = ["https://example.com/image1.jpg", "https://example.com/image2.jpg"]
                 //  .map { URL(string: $0)! }
        
        prefs.prefetchedURLS = prefs.randomImages.urlArray
                   .map { URL(string: $0)! }
        
        
       // prefs.randomImages.urlArray
        
        let prefetcher = ImagePrefetcher(urls: prefs.prefetchedURLS, completionHandler:  {
            skippedResources, failedResources, completedResources in
            print("These resources are prefetched: \(completedResources)")
        })
        prefetcher.start()
        
        /*
         let prefetcher = ImagePrefetcher(urls: urls) {
             skippedResources, failedResources, completedResources in
             print("These resources are prefetched: \(completedResources)")
         }
         prefetcher.start()
         */
        
        // Later when you need to display these images:
      //  imageView.kf.setImage(with: urls[0])
      //  anotherImageView.kf.setImage(with: urls[1])
    }
      
 */
    
}

struct HomeDetails_Previews: PreviewProvider {
    static var previews: some View {
        Text("Need to add view")
       // HomeDetails()
    }
}
