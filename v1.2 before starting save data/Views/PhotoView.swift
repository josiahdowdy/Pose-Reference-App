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
import UniformTypeIdentifiers

struct PhotoView: View {
    @EnvironmentObject var prefs: Settings
    // @ObservedObject var prefs: Settings
    //let processor = BlackWhiteProcessor()
    
    //var myURL = URL.self
    var myURL: URL = URL(string: "https://duckduckgo.com/")!
    @State var isImporting: Bool = false
    
    ///URL conversion
   // var url: URL = URL(string: "https://duckduckgo.com/")!
  
    //@State var provider :URL
    

    var body: some View {
        Group(){
          //  imageView.kf.setImage(with: provider)
           
            //**this works** let myURL = URL(string: "file:///Users/josiahdowdy/Downloads/05.%20Benjisi%20Art/gnome1a.jpg")
           // KFImage(prefs.myURL,
           //KFImage(myURL,
            
        let testURL = URL(string: prefs.sURL)
            
            KFImage(testURL,
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage,
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
            ///end of fileImporter
        }
    }
 
    
    func loadPhoto(){
        prefs.currentIndex += 1
        if !(prefs.randomImages.photoArray.isEmpty) {
            prefs.sURL = (prefs.randomImages.photoArray[self.prefs.currentIndex].urls["regular"]!)
        } else if !(prefs.arrayOfURLStrings.isEmpty) {
            prefs.sURL = prefs.arrayOfURLStrings[self.prefs.currentIndex]
        } else {
            print("\nBoth Unsplash and local photo arrays are empty.\n")
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
