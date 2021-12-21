//  ContentView.swift - Art Athlete - Created by josiah on 2021-10-17.
import SwiftUI
import CoreData
//import Files
import UniformTypeIdentifiers
import SlideOverCard

struct ContentView: View {
    @Environment(\.colorScheme) var currentDarkLightMode
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var storedUserData: StoredUserData

    @StateObject var sharedData: SharedViewModel = SharedViewModel()

    @State var isImporting: Bool = false
    @State var isSettingsPresented = false

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

  //  @StateObject var homeData: HomeViewModel = HomeViewModel()
    @EnvironmentObject var homeData: HomeViewModel// = HomeViewModel()

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
                    HomeScreenButtonsView() //homeData: homeData
                        .environmentObject(homeData)
                        .environmentObject(sharedData)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(AnyTransition.move(edge: .leading)).animation(.default)
                }
            }

            if prefs.startSession {
                DrawingView(testData: testData, startSession: $startSession)
            }
        }
        .slideOverCard(isPresented: $prefs.showSettings, options: [.hideExitButton]) { //$isSettingsPresented
            ArtAthleteSettings() //(notifyMeAbout: $notifyMeAbout, playNotificationSounds: $playNotificationSounds, profileImageSize: $profileImageSize, sendReadReceipts: $sendReadReceipts)
                .environmentObject(homeData)
        }
        .slideOverCard(isPresented: $prefs.showStats, options: [.hideExitButton]) {
            StatsView(userStats: testData)
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



/*
 public func scanAllFolders() {
 //        if (UIDevice.current.userInterfaceIdiom == .mac) {
 //            print("JD451: mac")
 //            Folder.documents!.subfolders.recursive.forEach { folder in
 //                homeData.folders.append(Product(type: .Poses, title: folder.name, subtitle: "xx", count: folder.files.count()))
 //                /// Different on mac --> folder.files vs Folder.documents!.files
 //            }
 //        }

 ///important --> when running "My Mac (designed for ipad)", this if statement is used.
 // if (UIDevice.current.userInterfaceIdiom == .pad) {
 //     print("JD451: iPad")
 Folder.documents!.subfolders.recursive.forEach { folder in
 homeData.folders.append(Product(title: folder.name, count: folder.files.count()))
 }
 //   }

 //        if (UIDevice.current.userInterfaceIdiom == .phone) {
 //            print("JD451: PHONE")
 //            print("JD451: phone - Folder.documents! \(Folder.documents!) ")
 //            // Its NOT library - current - documents - home - root -
 //            Folder.documents!.subfolders.recursive.forEach { folder in
 //                homeData.folders.append(Product(type: .Poses, title: folder.name, subtitle: "xx", count: folder.files.count()))
 //            }
 //        }
 } //End func.
 */

/*
 if (prefs.showSettings) {

 SlideOverCard($position, backgroundStyle: $background) {
 SlideOverCardCustom($position, backgroundStyle: $background) {
 .slideOverCard(isPresented: $isPresented) {
 // Here goes your awesome content

 //Text("Settings")
 ArtAthleteSettings(notifyMeAbout: $notifyMeAbout, playNotificationSounds: $playNotificationSounds, profileImageSize: $profileImageSize, sendReadReceipts: $sendReadReceipts)
 .environmentObject(homeData)
 }
 }

 if (prefs.showStats) {
 SlideOverCardCustom($position, backgroundStyle: $background) {
 //SlideOverCard($position, backgroundStyle: $background) { //CardPosition.top
 StatsView(userStats: testData)
 }
 }
 */
