/*
 Josiah - Oct 29, 2020
 PhotoView:
 Shows the photo --> it is loaded by HomeView()
 Handles photo size, and unsplash text + author name.
 */

/*  import class Kingfisher.ImageCache
import class Kingfisher.KingfisherManager
import class Kingfisher.ImageDownloader
import class Kingfisher.SessionDataTask         */

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.LocalFileImageDataProvider
import protocol Kingfisher.ImageDataProvider


struct PhotoView: View {
    @EnvironmentObject var prefs: Settings
    // @ObservedObject var prefs: Settings
    //let processor = BlackWhiteProcessor()
    
    var myURL = URL.self
    

    var body: some View {
        Group(){
           // let provider = LocalFileImageDataProvider(fileURL: myURL)
            KFImage(prefs.myURL,
           // KFImage(source: .network(provider as! Resource),
            
        options: [
            .transition(.fade(0.2)),
            .cacheOriginalImage,
            //.processor(BlackWhiteProcessor)
            //.alsoPrefetchToMemory
            //.scaleFactor(UIScreen.main.scale), //I'm not sure I need this, it doesn't seem to have an effect.
        ])
        .onSuccess { r in
            // r: RetrieveImageResult
            print("success: \(r)")
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
        .resizable()
        .scaledToFit() //PERFECT! resizable + scaledToFit  ....
        //.aspectRatio(contentMode: .fill)  //scaleFactor + this = the smaller, but nice image!!!
        .edgesIgnoringSafeArea(.top)
        .cornerRadius(20)
        .shadow(radius: 5)
        }
    }
 
    
    func loadPhoto(){
        prefs.currentIndex += 1
        if !(prefs.randomImages.photoArray.isEmpty) {
            prefs.sURL = (prefs.randomImages.photoArray[self.prefs.currentIndex].urls["regular"]!)
        }
    }
    
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

 /*
 Group {
     AnimatedImage(url: URL(string: joURL))
         .onFailure { error in
             print("Error: \(error)")
         }
         .resizable() //.frame (width: geometry.size.width)
         .placeholder(UIImage(systemName: "name of photo"))
         .transition(.fade)
         //.scaledToFit()
         .aspectRatio(contentMode: .fill)//.fill)
         .clipShape(RoundedRectangle(cornerRadius: 7.0))
         .shadow(radius: 16)
         //.playbackRate(30.0)
         .onTapGesture {
             //loadPhoto()
         }
 }
*/
