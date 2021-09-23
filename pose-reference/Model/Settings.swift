/*
 Josiah - Oct 29, 2020
 Main object used to keep track of draw session data.
 
 */

import Foundation
import Kingfisher

class Settings: ObservableObject {
    @Published var sPose = ""
    @Published var sPoseCount = 30
    @Published var imageQuality = "regular"
    
    @Published var localPhotosView = true
    @Published var unsplashPhotosView = false
    
    @Published var tag = ""
    
    @Published var sURL = ""
    @Published var sPhotographer = ""
    
    //@Published var updatePhotographer: String = "" { didSet { sPhotographer = updatePhotographer } }
    @Published var textsMatch: Bool = false
    
    @Published var portfolioURL :String = "https://www.unsplash.com/@" //?utm_source=Drawing_Reference_Timer&utm_medium=referral"
    
    @Published var arrayOfURLStrings = [String]()
    @Published var prefetchedURLS: [URL] = []
    //@Published var prefetchedURLone :URL = URL?
    @Published var startBoolean = false
    @Published var localPhotos = false
    @Published var currentIndex = 0
    
    @Published var randomImages = UnsplashData() //Required to be in Settings to save the array (otherwise it got deleted.)
    @Published var disableSkip = true
    @Published var togglePhotoDisplay = true
    @Published var showMainMenu: Bool = true
    @Published var userName: String = ""
    
    @Published var myURL: URL = URL(string: "https://unsplash.com/")!
   // @Published var sPoseCount = 30
   // @Published var localURL :URL = URL(string: "")
    
    ///Collections'
    @Published var collection = false
    //@Published var collectionSpecific = false
    @Published var collectionName = ""
    @Published var collectionID :String = ""
    let IDPortraitsDark = 162326  //https://unsplash.com/collections/162326/dark-portraits
    let IDportraitsDarkMAX = 736
    @Published var darkPortrait = false
    
    //@Published var processorBW = false
    @Published var processorDefault = true//DefaultImageProcessor.default
    @Published var processorBlack = false//BlackWhiteProcessor()
   // @Published var processorDefault = DefaultImageProcessor.default
    
    var getDarkPortrait: Bool {
        get {
            return darkPortrait
        }
    }
    
    ///Tags
    
    //Generate random images.
    /*
    func randomImagesCollection(){
        let randomImageIndex = Int.random(in: 0...IDportraitsDarkMAX)
        let imageWidth = 480
        let imageHeight = 480
        
        let url = "https://source.unsplash.com/collection/\(IDPortraitsDark)/\(imageWidth)x\(imageHeight)/?sig=\(randomImageIndex)"
        
        
    }
 */
}
