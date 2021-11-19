//
//  StatsButton.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-19.
//

import SwiftUI

struct StatsButton: View {
    //@Binding var prefs: GlobalVariables
    @EnvironmentObject var prefs: GlobalVariables


    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: {
                prefs.showStats.toggle()
            }, label: {
                Label("Stats", systemImage: "chart.bar.xaxis")
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
    private func showStats() {
        prefs.showStats.toggle()
    }
}

//struct StatsButton_Previews: PreviewProvider {
//    static var previews: some View {
//        StatsButton()
//    }
//}
