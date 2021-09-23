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
    
    
    var body: some Scene {
        WindowGroup {
           HomeView()
                .environmentObject(prefs)
                .environmentObject(timeObject)
                .environmentObject(userObject)
 
           // ContentView()
        }
    }
}
