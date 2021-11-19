//
//  iOSSettingsBarView.swift
//  pose-reference
//
//  Created by josiah on 2021-10-29.
//

/*
import SwiftUI

struct iOSSettingsBarView: View {
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    
    
    @State private var showStats = false
    @State private var showSettings = false
    
    var body: some View {
        //This is the top right settings menu.
        //.sheet(popover(isPresented: $showSettings, content: DotMenuView(localPhotos: $prefs.localPhotosView, showStats: $showStats, showSettings: $showSettings)))
        /*
         Button("Settings") {
         //self.error = "Memorize on: photo interval of 2 seconds on and 3 seconds off."
         showSettings = true
         }
         .sheet(isPresented: $showSettings) {
         return DotMenuView(localPhotos: $prefs.localPhotosView, showStats: $showStats, showSettings: $showSettings)
         } */
        
        DotMenuView(showStats: $showStats, showSettings: $showSettings) //unsplashPhotos: $prefs.unsplashPhotosView,
        
            .sheet(isPresented: $showStats) {
                return StatsView()
                //.environmentObject(self.userObject)
                    .environmentObject(self.prefs)
                    .environmentObject(self.timeObject)
            }
            .sheet(isPresented: $showSettings) {
                return SettingsView()
                //  .environmentObject(self.userObject)
                    .environmentObject(self.prefs)
                    .environmentObject(self.timeObject)
            }
    }
}

struct iOSSettingsBarView_Previews: PreviewProvider {
    static var previews: some View {
        iOSSettingsBarView()
    }
}
*/
