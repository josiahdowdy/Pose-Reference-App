/*
 Josiah - Oct 29, 2020
 1st file called by program.
 Loads HomeView.
 Initializes the global objects: for GlobalVariables, TimerObject, & UserObject
 */

import SwiftUI

@main
struct pose_referenceApp: App {
    @ObservedObject var prefs = GlobalVariables()
    @ObservedObject var timeObject = TimerObject()
    @ObservedObject var userObject = UserObject()

    let persistenceController = PersistenceController.shared
    
    // Connecting App Delegate...
    //@NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView() //isPresented: $prefs.showMainScreen
                .environmentObject(prefs)
                .environmentObject(timeObject)
               // .environmentObject(userObject)
                .environment(\.managedObjectContext, persistenceController.container.viewContext) //Storing data.
            
                //.environmentObject(persistenceController.container.viewContext)
        }
        
        #if os(macOS)
            Settings {
                SettingsMacView()
            }
        #endif
    }
}


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
