/*
 Josiah - Oct 29, 2020
 1st file called by program.
 Loads HomeView.
 Initializes the global objects: for Settings, TimerObject, & UserObject
*/

import SwiftUI

@main
struct pose_referenceApp: App {
    //@StateObject private var prefs = Settings()
    @ObservedObject var prefs = Settings()
    @ObservedObject var timeObject = TimerObject()
    @ObservedObject var userObject = UserObject()
    
    let persistenceController = PersistenceController.shared
    
    
    var body: some Scene {
        WindowGroup {
            
            
           //HomeView() //this is the first view loaded
            HomeDetails()
                .environmentObject(prefs)
                .environmentObject(timeObject)
                .environmentObject(userObject)
                //.environmentObject(persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
           // ContentView()
        }
    }
    
    
}
