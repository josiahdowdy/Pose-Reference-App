/*
 Josiah - Oct 29, 2020
 1st file called by program.
 Loads HomeView.
 Initializes the global objects: for GlobalVariables, TimerObject, & UserObject
 */


//TODO: 
///When the app first launches, load all the photos…
///
///When the user deletes photos. Delete them from the bookmark array.
///

/*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
import SwiftUI
//import UIKit
//import CoreData
import Files

@main
struct pose_referenceApp: App {
    @ObservedObject var prefs = GlobalVariables()
    @ObservedObject var timeObject = TimerObject()
    @ObservedObject var userObject = UserObject()
    @ObservedObject var homeData = HomeViewModel()
    
    //@State var url : URL = URL(fileURLWithPath: "nil")
    
    
    let persistenceController = PersistenceController.shared

    @Environment(\.scenePhase) var scenePhase

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    var body: some Scene {
        WindowGroup {
            ContentView() //.preferredColorScheme(.dark) //isPresented: $prefs.showMainScreen
                .environmentObject(prefs)
                .environmentObject(timeObject)
               // .environmentObject(storedUserData)
                .environmentObject(homeData)
                .environment(\.managedObjectContext, persistenceController.container!.viewContext) //Shares data in WHOLE project.
            //  .environment(\.managedObjectContext, persistenceControllerCoreData.container.viewContext)
            //Storing data.
            //.environmentObject(persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
                
            case .background:
                print("Scene is in background")
                persistenceController.save()
                //persistenceControllerCoreData.saveCoreData()
            case .inactive:
                print("Scene is inactive")
            case .active:
                print("JD01: Scene is active")
                //loadBookmarkedPhotos()
            @unknown default:
                print("Apple must have changed something")
            }
        }
    }

    //Start funcs.
   
    /*
    func createFolder() {
        //create directory
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent("Poses")
        let docURL = URL(fileURLWithPath: documentsPath.path!)
        //let docURL = URL(fileURLWithPath: documentsDirectory)

        do {
            try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)

            if let fileURL = Bundle.main.url(forResource: "jump", withExtension: "png") {
               // let image = UIImage(contentsOfFile: fileURL.path)
                let dataPath = docURL.appendingPathComponent("Poses/jump")

                let data = img1! //.jpegData(compressionQuality: 1.0)
               // try data!.write(to: dataPath)

            }

        } catch let error as NSError {
            print(error)
        }
    }





    func copyAssetImages() { //imageName: String, image: Data
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(fileURLWithPath: documentsDirectory)//URL(string: documentsDirectory)!
        //       let dataPath = docURL.appendingPathComponent("Poses")

        //guard let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        if let fileURL = Bundle.main.url(forResource: "jump", withExtension: "png") {
            // if let fileURL = Bundle.main.url(forResource: "PhotoPack", withExtension: "") {
            print("2. JD00 → fileURL \(fileURL)")
            let image = UIImage(contentsOfFile: fileURL.path)
            let imageName = fileURL.lastPathComponent
            // if !FileManager.default.fileExists(atPath: fileURL.path) {
            let folderAndFileName = "Poses/".appending(imageName)
            let dataPath = docURL.appendingPathComponent(folderAndFileName)

            do {
                let data = image!.jpegData(compressionQuality: 1.0)
                try data!.write(to: dataPath) //writePath)

                print("\n5. JD00 → ACCESS GRANTED ******************\n")
            } catch let error {
                print("5. JD00: error saving file with error", error.localizedDescription)
            }
        } else {
            print("2. JD00: NOT FOUND")
        }
    }
    */
}
    
    // MARK: - Core Data Saving support
    
    //    func saveContext () {
    //        let context = persistentContainer.viewContext
    //        if context.hasChanges {
    //            do {
    //                try context.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nserror = error as NSError
    //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    //            }
    //        }
    //    }
    



//MARK: - Run functions for when app first launches.
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//
//        // ******** Run your function here **********
//        loadBookmarkedPhotos()
//        return true
//    }



// Going to BUild Menu Button and Pop Over Menu.....
/*
 class AppDelegate: NSObject, NSApplicationDelegate{
 
 // Status Bar Item...
 var statusItem: NSStatusItem?
 // PopOver...
 var popOver = NSPopover()
 
 func applicationDidFinishLaunching(_ notification: Notification) {
 
 // Menu View...
 let menuView = MenuView()
 
 // Creating PopOver....
 popOver.behavior = .transient
 popOver.animates = true
 // Setting Empty View Controller...
 // And Setting View as SwiftUI View...
 // with the help of Hosting Controller...
 popOver.contentViewController = NSViewController()
 popOver.contentViewController?.view = NSHostingView(rootView: menuView)
 
 // also Making View as Main View...
 popOver.contentViewController?.view.window?.makeKey()
 
 // Creating Status Bar Button....
 statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
 
 // Safe Check if status Button is Available or not...
 if let MenuButton = statusItem?.button{
 
 MenuButton.image = NSImage(systemSymbolName: "icloud.and.arrow.up.fill", accessibilityDescription: nil)
 MenuButton.action = #selector(MenuButtonToggle)
 }
 }
 
 // Button Action...
 @objc func MenuButtonToggle(sender: AnyObject){
 
 // For Safer Side....
 if popOver.isShown{
 popOver.performClose(sender)
 }
 else{
 // Showing PopOver....
 if let menuButton = statusItem?.button{
 
 // Top Get Button Location For Popover Arrow....
 self.popOver.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: NSRectEdge.minY)
 }
 }
 }
 }
 */


/*
 //MARK: - FUNCS
 private func loadBookmarkedPhotos() {
 //for photo in storedUserData.arrayWorkingDirectoryBookmark {
 //prefs.arrayOfURLStringsTEMP = restoreFileAccessArray(with: (storedUserData.arrayWorkingDirectoryBookmark))!
 
 print("JD84:", prefs.arrayOfURLStringsTEMP)
 
 //MARK: - Loads in array of photos.
 for i in 0..<storedUserData.arrayWorkingDirectoryBookmark.count {
 url = restoreFileAccess(with: storedUserData.arrayWorkingDirectoryBookmark[i])!
 
 //FIXME: BOOKMARK URL IS WORKING. NOW, ADD IT TO AN ARRAY.
 if (url.startAccessingSecurityScopedResource()) {
 prefs.arrayOfURLStrings.append(String(describing: url))
 //print("JD68: LOADING BOOKMARK. \(prefs.arrayOfURLStrings)")
 } else {
 print("JD67: False")
 }
 }
 print("\n•••••••••••••••••••••• JD68 LOADING BOOKMARK DONE ••••••••••••••••••••••------------------------------------")
 //print("JD68:  \(prefs.arrayOfURLStrings)")
 } //End func.
 
 private func restoreFileAccess(with bookmarkData: Data) -> URL? {
 do {
 var isStale = false
 let url = try URL(resolvingBookmarkData: bookmarkData, relativeTo: nil, bookmarkDataIsStale: &isStale)
 
 if isStale {
 // bookmarks could become stale as the OS changes
 print("Bookmark is stale, need to save a new one... ")
 saveBookmarkData(for: url)
 }
 return url
 } catch {
 print("Error resolving bookmark:", error)
 return nil
 }
 }
 
 private func saveBookmarkData(for workDir: URL) { //URL //for workDir: URL //[URL: Data]
 do {
 let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: nil, relativeTo: nil)
 //storedUserData.workingDirectoryBookmark = bookmarkData
 storedUserData.arrayWorkingDirectoryBookmark.append(bookmarkData)
 } catch {
 print("Failed to save bookmark data for \(workDir)", error)
 }
 }
 */
