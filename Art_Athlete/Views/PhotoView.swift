/* Josiah - Oct 29, 2020
 PhotoView: Shows the photo.  */

/*  import class Kingfisher.ImageCache
 import class Kingfisher.KingfisherManager
 import class Kingfisher.ImageDownloader
 import class Kingfisher.SessionDataTask
 //import struct Kingfisher.LocalFileImageDataProvider
 //import protocol Kingfisher.ImageDataProvider
 //import UniformTypeIdentifiers     */

import SwiftUI
//import Files
import Kingfisher //needs fixed for macOS

struct PhotoView: View {
    @EnvironmentObject var prefs: GlobalVariables
    
    private var processorBlack = BlackWhiteProcessor()
    //private var processorDefault = DefaultImageProcessor.default()
    
    //let processor = BlackWhiteProcessor()
    //@Binding var userLink :String
    //var myURL: URL = URL(string: "https://duckduckgo.com/")!
    //@State var isImporting: Bool = false
    
    var body: some View {
        Group(){
            ZStack(alignment: .bottomTrailing) {
                let testURL = URL(string: prefs.sURL)
                let processorDefault =  DefaultImageProcessor.default
                            
                if(prefs.processorDefault == true){
                    KFImage(testURL)
                    /* options: [
                     .transition(.fade(0.2)),
                     .cacheOriginalImage,
                     .processor(processor)
                     ])      */
                        .onSuccess { r in
                            // r: RetrieveImageResult
                            //print("success: \(r)")
                            
                        }
                        .onFailure { e in
                            // e: KingfisherError
                            print("failure: \(e)")
                        }
                        .placeholder {
                            // Placeholder while downloading.
                            Image(systemName: "arrow.2.circlepath.circle")
                                .font(.largeTitle)
                                .opacity(0.3)
                        }
                        .setProcessor(processorDefault) // as! ImageProcessor
                        .resizable()
                        .scaledToFit() //PERFECT! resizable + scaledToFit  ....
                    //.aspectRatio(contentMode: .fill)  //scaleFactor + this = the smaller, but nice image!!!
                        .edgesIgnoringSafeArea(.top)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .rotationEffect(.degrees(prefs.flippedVertically ? 180.0 : 0.0 ))
                        .rotation3DEffect(.degrees(prefs.flippedHorizontally ? 180.0 : 0.0), axis: (x: 0.0, y: -1.0, z: 0.0))
                } else if (prefs.processorBlack == true) {
                    KFImage(testURL)
                    /* options: [
                     .transition(.fade(0.2)),
                     .cacheOriginalImage,
                     .processor(processor)
                     ])      */
                        .onSuccess { r in
                            // r: RetrieveImageResult
                            //print("success: \(r)")
                        }
                        .onFailure { e in
                            // e: KingfisherError
                            print("failure: \(e)")
                        }
                        .placeholder {
                            // Placeholder while downloading.
                            Image(systemName: "arrow.2.circlepath.circle")
                                .font(.largeTitle)
                                .opacity(0.3)
                        }
                    //if(prefs.processorBlack).setProcessor(processorBlack)
                        .setProcessor(processorBlack) // as! ImageProcessor
                        .resizable()
                        .scaledToFit() //PERFECT! resizable + scaledToFit  ....
                    //.aspectRatio(contentMode: .fill)  //scaleFactor + this = the smaller, but nice image!!!
                        .edgesIgnoringSafeArea(.top)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .rotationEffect(.degrees(prefs.flippedVertically ? 180.0 : 0.0))
                        .rotation3DEffect(.degrees(prefs.flippedHorizontally ? 180.0 : 0.0), axis: (x: 0.0, y: -1.0, z: 0.0))
                }
            } //End ZStack
        } //End Group.
    } //End View.
    
    //----------FUNCTIONS------------------------------------------------------
    //Load a local image
    func saveImage(imageName: String, image: Data) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try image.write(to: fileURL)
            print("Image ID: \(imageName) saved. Data: \(image)")
        } catch let error {
            print("error saving file with error", error)
        }
    }
}




/* This is ONLY for Unpsplash photos.
 func loadPhoto(){
 prefs.currentIndex += 1
 if !(prefs.randomImages.photoArray.isEmpty) {
 prefs.sURL = (prefs.randomImages.photoArray[self.prefs.currentIndex].urls[self.prefs.imageQuality]!)
 //prefs.sURL = (prefs.randomImages.photoArray[self.prefs.currentIndex])
 prefs.sPhotographer = (prefs.randomImages.photoArray[self.prefs.currentIndex].user?.name ?? "nil")
 prefs.portfolioURL = "https://www.unsplash.com/@"
 prefs.portfolioURL.append(prefs.randomImages.photoArray[self.prefs.currentIndex].user?.username ?? "davidprspctive")
 prefs.portfolioURL.append("?utm_source=Drawing_Reference_Timer&utm_medium=referral")
 
 } else if !(prefs.arrayOfURLStrings.isEmpty) {
 prefs.sURL = prefs.arrayOfURLStrings[self.prefs.currentIndex]
 } else {
 print("\nPhoto array is empty.\n")
 }
 }
 */







/*
 if (prefs.localPhotos != true) {
 HStack{
 Text("Photo by").font(.caption)
 let portfolioURL = prefs.portfolioURL
 Link("\(prefs.sPhotographer)", destination: URL(string: userLink)!).font(.caption)
 .background(Color.black)
 .foregroundColor(.white)
 ?utm_source=Drawing_Reference_Timer&utm_medium=referral
 Text ("on").font(.caption)
 Link("Unsplash", destination: URL(string: "https://www.unsplash.com/?utm_source=Drawing_Reference_Timer&utm_medium=referral")!)
 .font(.caption).background(Color.black)
 .foregroundColor(.white)
 .padding(4)           }
 } */



/*
 .fileImporter(
 isPresented: $isImporting,
 allowedContentTypes: [UTType.plainText, UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
 allowsMultipleSelection: true, //false
 onCompletion: { result in
 
 if let urls = try? result.get() {
 //  prefs.myURL.startAccessingSecurityScopedResource()
 urls[0].startAccessingSecurityScopedResource()
 print("\n\n**PhotoView:\n urls[0]: \(urls[0]) ** \n\n")
 prefs.myURL = urls[0]
 
 
 //let url = URL(fileURLWithPath: )
 //let provider = LocalFileImageDataProvider(fileURL: prefs.myURL)
 
 print("urls: \(urls)")
 
 
 let urlString = "\(urls[0])"
 prefs.sURL = urlString
 print("urlString: \(prefs.sURL)")
 
 print("\n\n**PhotoView:\n prefs.myURL: \(prefs.myURL) ** \n\n")
 }
 }
 )
 */
//end of fileImporter
