//
//  StatsButton.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-19.
//

import SwiftUI

struct StatsButton: View {
    //@Binding var prefs: GlobalVariables
    @Environment(\.colorScheme) var currentDarkLightMode
    @EnvironmentObject var prefs: GlobalVariables

    @Binding var showStats: Bool


    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: {
                showStats.toggle()
                //prefs.showStats.toggle()
                prefs.showSettings = false
            }, label: {
                Label("Stats", systemImage: "chart.bar.xaxis")
                    .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
            })
            //  if (prefs.localPhotosView) { }
        }
//
//        if (prefs.showSettings) {
//            SlideOverCard($position, backgroundStyle: $background) {
//                //Text("Settings")
//                ArtAthleteSettings(notifyMeAbout: $notifyMeAbout, playNotificationSounds: $playNotificationSounds, profileImageSize: $profileImageSize, sendReadReceipts: $sendReadReceipts)
//            }
//        }
    }

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
//    private func showStats() {
//        prefs.showStats.toggle()
//    }
}

//struct StatsButton_Previews: PreviewProvider {
//    static var previews: some View {
//        StatsButton()
//    }
//}
