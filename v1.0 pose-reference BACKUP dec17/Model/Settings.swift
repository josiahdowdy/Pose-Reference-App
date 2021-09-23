/*
 Josiah - Oct 29, 2020
 Main object used to keep track of draw session data.
 
 */

import Foundation

class Settings: ObservableObject {
    //@Published var timeLength = 10000
    //@Published var timeCountdown = 10000
    @Published var sPose = "penguin"
    @Published var sPoseCount = 20
    @Published var sTag = ""
    @Published var sURL = ""
    @Published var prefetchedURLS: [URL] = []
    //@Published var prefetchedURLone :URL = URL?
    @Published var startBoolean = false
    @Published var currentIndex = 0
    
    @Published var randomImages = UnsplashData() //Required to be in Settings to save the array (otherwise it got deleted.)
    @Published var disableSkip = true
    @Published var togglePhotoDisplay = true
    @Published var showMainMenu: Bool = true
    
    @Published var myURL: URL = URL(string: "https://duckduckgo.com/")!
   // @Published var localURL :URL = URL(string: "")
}
