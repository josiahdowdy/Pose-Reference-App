/* Josiah - Oct 29, 2020 */
import SwiftUI

@main
struct pose_referenceApp: App {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var prefs = GlobalVariables()
    let persistenceController = PersistenceController.shared
    @AppStorage("isFirstLaunch") public var isFirstLaunch = true

   // init() { print("JD00 → *****************    1 ") }

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: createFolder)
                .environmentObject(prefs)
                .environment(\.managedObjectContext, persistenceController.container!.viewContext)//Shares data in WHOLE project.

            //.preferredColorScheme(.dark)
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
    func createFolder() {
      //  isFirstLaunch = true //MARK: TRUE for testing ONLY.
        if (isFirstLaunch) {
            let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            let logsPath = documentsPath.appendingPathComponent("Poses")
            let landscapesPath = documentsPath.appendingPathComponent("Landscapes")
            let animalPath = documentsPath.appendingPathComponent("Animals")
            let docURL = URL(fileURLWithPath: documentsPath.path!)

            let poseImages: [UIImage] = [
                UIImage(named: "dance.jpeg")!,
                UIImage(named: "jump.jpeg")!,
                UIImage(named: "standing.jpeg")!,
                UIImage(named: "dance2.jpeg")!,
                UIImage(named: "couple.jpeg")!
            ]

            let poseNames: [String] = [
                "dance.jpeg",
                "jump.jpeg",
                "standing.jpeg",
                "dance2.jpeg",
                "couple.jpeg"
            ]

            let landscapeImages: [UIImage] = [
                UIImage(named: "China.jpeg")!,
                UIImage(named: "Hawaii.jpeg")!,
                UIImage(named: "NewZealand.jpeg")!,
                UIImage(named: "NewZealand2.jpeg")!,
                UIImage(named: "UK.jpeg")!
            ]

            let landscapeNames: [String] = [
                "China.jpeg",
                "Hawaii.jpeg",
                "NewZealand.jpeg",
                "NewZealand2.jpeg",
                "UK.jpeg"
            ]

            let animalImages: [UIImage] = [
                UIImage(named: "cat.jpeg")!,
                UIImage(named: "dog_running.jpeg")!,
                UIImage(named: "dogs.jpeg")!,
                UIImage(named: "wolf.jpeg")!,
                UIImage(named: "wolfpack.jpeg")!
            ]

            let animalNames: [String] = [
                "cat.jpeg",
                "dog_running.jpeg",
                "dogs.jpeg",
                "wolf.jpeg",
                "wolfpack.jpeg"
            ]

            do {
                try FileManager.default.createDirectory(atPath: animalPath!.path, withIntermediateDirectories: true, attributes: nil)

                for i in 0...(animalImages.count-1) {
                    prefs.countingTest += 1
                    print("JD00: \(prefs.countingTest)")
                    let dataPath = docURL.appendingPathComponent("Animals/\(animalNames[i])")
                    let data = animalImages[i].jpegData(compressionQuality: 1.0)
                    try data!.write(to: dataPath)
                }

                try FileManager.default.createDirectory(atPath: landscapesPath!.path, withIntermediateDirectories: true, attributes: nil)

                for i in 0...(landscapeImages.count-1) {
                    prefs.countingTest += 1
                    print("JD00: \(prefs.countingTest)")
                    let dataPath = docURL.appendingPathComponent("Landscapes/\(landscapeNames[i])")
                    let data = landscapeImages[i].jpegData(compressionQuality: 1.0)
                    try data!.write(to: dataPath)
                }

                try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)

                for i in 0...(poseImages.count-1) {
                    prefs.countingTest += 1
                    print("JD00: \(prefs.countingTest)")
                    let dataPath = docURL.appendingPathComponent("Poses/\(poseNames[i])")
                    let data = poseImages[i].jpegData(compressionQuality: 1.0)
                    try data!.write(to: dataPath)
                }




            } catch let error as NSError {
                print(error)
            }
            isFirstLaunch = false
        }
    }
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
