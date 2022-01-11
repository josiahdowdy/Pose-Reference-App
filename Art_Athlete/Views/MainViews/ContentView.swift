//  ContentView.swift - Art Athlete - Created by josiah on 2021-10-17.
import SwiftUI
import CoreData
import UniformTypeIdentifiers
import SlideOverCard
//import Files

struct ContentView: View {
    @EnvironmentObject var prefs: GlobalVariables
    @Environment(\.managedObjectContext) var context
    let persistenceController = PersistenceController.shared

    @FetchRequest(entity: UserData.entity(), sortDescriptors: []) var userData: FetchedResults<UserData>

    @State var startSession = false

    //init() { print("JD00: [Content View]")  }
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/

    //MARK: - UI
    var body: some View {
//        if !(prefs.introIsFinished) {
//            IntroScreen()
//        }

        ZStack(alignment: Alignment.top) {
            if (prefs.introIsFinished) {
               if (!prefs.startSession) {
                    HomeScreenButtonsView()
                        .environmentObject(prefs)
                        .environment(\.managedObjectContext, persistenceController.container!.viewContext)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                       // .transition(AnyTransition.move(edge: .leading)).animation(.default)
                }
            }

            if prefs.startSession {
                DrawingView(userData: userData, startSession: $startSession)//(userData: userData, startSession: $startSession)
                    .environmentObject(prefs)
            }
        }
        .slideOverCard(isPresented: $prefs.showSettings, options: [.hideExitButton]) { //$isSettingsPresented
            ArtAthleteSettings()
                .environmentObject(prefs)
        }
        .slideOverCard(isPresented: $prefs.showStats, options: [.hideExitButton]) { //$prefs.showStats
            StatsView(userStats: userData) //showStats: $prefs.showStats,
                .environmentObject(prefs)
        }
    } //End View
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: FUNCTIONS

} //End Struct.

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//       // ContentView()
//            //.environmentObject(GlobalVariables())
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .environmentObject(GlobalVariables())
//    }
//}


