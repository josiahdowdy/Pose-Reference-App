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
import UIKit
import CoreData

@main
struct pose_referenceApp: App {
    @ObservedObject var userSettings = StoredUserData()
    @ObservedObject var prefs = GlobalVariables()
    @ObservedObject var timeObject = TimerObject()
    //@ObservedObject var userObject = UserObject()

    @State var url : URL = URL(fileURLWithPath: "nil")

    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase

    //@NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

                /*\___/\ ((
                 \`@_@'/  ))
                 {_:Y:.}_//
      ----------{_}^-'{_}----------*/
    
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    var body: some Scene {
        WindowGroup {
            ContentView() //isPresented: $prefs.showMainScreen
                .environmentObject(prefs)
                .environmentObject(timeObject)
               // .environmentObject(userObject)
                .environment(\.managedObjectContext, persistenceController.container.viewContext) //Shares data in WHOLE project.

            //Storing data.

                //.environmentObject(persistenceController.container.viewContext)
            
                //This saves the data when it is changed.

        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {

            case .background:
                print("Scene is in background")
                persistenceController.save()
            case .inactive:
                print("Scene is inactive")
            case .active:
                print("JD01: Scene is active")
                //loadBookmarkedPhotos()
            @unknown default:
                print("Apple must have changed something")
            }
        }

        .commands {
            SidebarCommands()
        }
//        #if os(macOS)
//            Settings {
//                SettingsMacView()
//            }
//        #endif
    }

    //MARK: - FUNCS
    private func loadBookmarkedPhotos() {
        //for photo in userSettings.arrayWorkingDirectoryBookmark {
        //prefs.arrayOfURLStringsTEMP = restoreFileAccessArray(with: (userSettings.arrayWorkingDirectoryBookmark))!

        print("JD84:", prefs.arrayOfURLStringsTEMP)

        //MARK: - Loads in array of photos.
        for i in 0..<userSettings.arrayWorkingDirectoryBookmark.count {
            url = restoreFileAccess(with: userSettings.arrayWorkingDirectoryBookmark[i])!

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
            //userSettings.workingDirectoryBookmark = bookmarkData
            userSettings.arrayWorkingDirectoryBookmark.append(bookmarkData)
        } catch {
            print("Failed to save bookmark data for \(workDir)", error)
        }
    }


}


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
