//  ContentView.swift - Art Athlete
//  Created by josiah on 2021-10-17.

import SwiftUI
import CoreData
import Files
import SlideOverCard
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var storedUserData: StoredUserData

    @StateObject var sharedData: SharedViewModel = SharedViewModel()
    @State private var position = CardPosition.top
    @State private var background = BackgroundStyle.blur

    @State var isImporting: Bool = false
    
    @State var pause = false

    @State var url : URL = URL(fileURLWithPath: "nil")
    @State var testUrlResourceKey = Set<URLResourceKey>() //FIXME: Not sure how to use this yet...


    //Settings vars.
    @State var notifyMeAbout : Bool = true
    @State var playNotificationSounds : Bool = false
    @State var profileImageSize : Bool = true
    @State var sendReadReceipts : Bool = true

    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: UserData.entity(), sortDescriptors: []) var testData: FetchedResults<UserData>

    @State var startSession = false
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/

    //MARK: - UI
    var body: some View {
        if !(prefs.introIsFinished) {
            IntroScreen()
        }

        ZStack(alignment: Alignment.top) {
            if (prefs.introIsFinished) {
                if (!prefs.startSession) {
                    HomeScreenButtonsView()
                        .environmentObject(sharedData)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(AnyTransition.move(edge: .leading)).animation(.default)
                }
            }

            if prefs.startSession {
                DrawingView(testData: testData, startSession: $startSession)
            }

            if (prefs.showSettings) {
                SlideOverCard($position, backgroundStyle: $background) {
                   //Text("Settings")
                    ArtAthleteSettings(notifyMeAbout: $notifyMeAbout, playNotificationSounds: $playNotificationSounds, profileImageSize: $profileImageSize, sendReadReceipts: $sendReadReceipts)
                }
            }

            if (prefs.showStats) {
                SlideOverCard($position, backgroundStyle: $background) {
                    StatsView(userStats: testData)
                }
            }
        }
    }
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/

    //MARK: - FUNCTIONS
} //End Struct.





//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//       // ContentView()
//            //.environmentObject(GlobalVariables())
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .environmentObject(GlobalVariables())
//    }
//}

