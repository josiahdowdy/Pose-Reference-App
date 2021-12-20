/* Josiah - Oct 29, 2020 - Main object used to keep track of draw session data. */


import Foundation

class GlobalVariables: ObservableObject {
    init() {
        sPose = "hi"
    }

    //----------STRINGS---------------------------------------------------------------
    @Published var sPose = ""

    @Published var tag = ""
    @Published var sURL = ""
    @Published var error = ""
    @Published var portfolioURL :String = ""  //"https://www.unsplash.com/@"

    //----------ARRAYS---------------------------
    @Published var arrayOfURLStrings = [String]()
    @Published var arrayOfURLStringsTEMP = [URL]()
    @Published var currentlySelectedFolders = [URL]()
    @Published var arrayOfFolderNames = [String]()

   // @Published var nsarrayURLS: CFArray = ["hi"]

    @Published var randomImages = UnsplashData() //Still needed till I update...
    @Published var time = [5, 30, 60, 120, 300]
    @Published var homeManyPhotosToDraw = [5, 10, 20, 60, 90]
    @Published var arrayOfFolders = [String]()

    //----------INTS------------------------
    @Published var currentIndex = 0
    @Published var selectorIndexTime = 2
    @Published var selectorCountTime = 2
    @Published var userSessionPoseCount = 0
    @Published var totalFilesSelected = 0
    @Published var sPoseCount = 30
    @Published var totalPhotosLoaded = 0
    
    //----------BOOLS----------------------------------------------------------------
    @Published var startSession = false
    @Published var showMainScreen = true
    @Published var showHomeView = false
    @Published var falseBool = false
    @Published var showLoadingAnimation = false
    @Published var isBookmarkDeletePending = false
    @Published var doesFolderAlreadyExist = false
    @Published var showNavBar = false


    //@Published var localPhotosView = true
    @Published var disableSkip = true
    @Published var togglePhotoDisplay = true
    
    @Published var localPhotos = false
    @Published var hideTimer = false
    @Published var numberTimer = false
    @Published var isRandom = true
    @Published var sessionFirstStarted = false
    @Published var introIsFinished = true
    @Published var showSettings = false
    @Published var showStats = false

    @Published var addFolder = false
//
//    @Published var selectedItems: Set<String> //Set<PhotoFolders>
//    @Published var items: Array<String>
//
//    init() {
//        self.items = ["A","B","C"]
//        self.selectedItems = ["A"]
//    }
//
    

    
    //----------IMAGE EFFECTS-------------------------------------------------
    @Published var processorDefault = true//DefaultImageProcessor.default
    @Published var processorBlack = false//BlackWhiteProcessor()
    @Published var flippedVertically = false
    @Published var flippedHorizontally = false

    @Published var userName: String = ""
    
    @Published var myURL: URL = URL(string: "https://unsplash.com/")!
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Collections
    //@Published var collection = false
    //@Published var collectionSpecific = false
    //@Published var collectionName = ""
    //@Published var collectionID :String = ""
    //let IDPortraitsDark = 162326  //https://unsplash.com/collections/162326/dark-portraits
    //let IDportraitsDarkMAX = 736
    //@Published var darkPortrait = false
    
    
    //@Published var sPhotographer = ""

    // @Published var localURL :URL = URL(string: "")
    //@Published var imageQuality = "regular"
    // //?utm_source=Drawing_Reference_Timer&utm_medium=referral"
    //@Published var randomImages = UnsplashData() //Required to be in Settings to save the array (otherwise it got deleted.)
    //@Published var prefetchedURLone :URL = URL?
    //@Published var unsplashPhotosView = false
    //@Published var showMainMenu: Bool = true
    //@Published var prefetchedURLS: [URL] = []
}
