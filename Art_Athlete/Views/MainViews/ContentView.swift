//  ContentView.swift - Art Athlete
//  Created by josiah on 2021-10-17.

import SwiftUI
import CoreData
//import CheckDevice
import SlideOverCard
import UniformTypeIdentifiers
//import CoreLocation

//TODO: - Selected down form the dropdown.

//FIXME: - CAN ADD these lines to view.


struct ContentView: View {
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject

    @State private var position = CardPosition.top
    @State private var background = BackgroundStyle.blur

    @State var isImporting: Bool = false
    
    @State var pause = false

    //Settings vars.
    @State var notifyMeAbout : Bool = true
    @State var playNotificationSounds : Bool = false
    @State var profileImageSize : Bool = true
    @State var sendReadReceipts : Bool = true

    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: UserData.entity(), sortDescriptors: []
        //sortDescriptors: [NSSortDescriptor(keyPath: \UserData.countPoses, ascending: true)]
    ) var testData: FetchedResults<UserData> //Memory
    
    //@FetchRequest(entity: UserEntity.entity(), sortDescriptors: [])
    //var userObject: FetchedResults<UserEntity>
    //, predicate: NSPredicate(format: "status != %@", Status.completed.rawValue)
    
    @FetchRequest(
        entity: PhotoFolders.entity(), sortDescriptors: []
    ) var photoData : FetchedResults<PhotoFolders>
    
    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors: []
    ) var folderData : FetchedResults<PhotoFolders>

    //@State private var startSession = false
    @State var startSession = false

    //private let locationManager = CLLocationManager()
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
        }


    }
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/

    //MARK: - FUNCTIONS
}


/*
 VStack{
 if (!prefs.startSession) {//!startSession {
 NavBarView(photoData: photoData, folderData: folderData) //startSession: $startSession,
 //   .frame(maxWidth: .infinity, maxHeight: .infinity)
 // .background(Color.blue)
 .transition(AnyTransition.move(edge: .leading)).animation(.default)

 }
 if prefs.startSession {//prefs.startSession {
 DrawingView(testData: testData, startSession: $startSession)
 // .frame(maxWidth: .infinity, maxHeight: .infinity)
 //.background(Color.green)
 //   .transition(AnyTransition.move(edge: .trailing)).animation(.default)
 }
 } */
//    func endSession(){
//        self.startSession = false
//        pause = false
//        //self.timeObject.endSessionBool.toggle()
//        prefs.disableSkip.toggle()
//        TimerView(timeObject: _timeObject, prefs: _prefs).stopTimer() //, startSession: $startSession
//        //prefs.startBoolean.toggle()
//        prefs.randomImages.photoArray.removeAll()
//        prefs.currentIndex = 0
//
//        prefs.localPhotos = false
//        prefs.arrayOfURLStrings.removeAll()
//    }



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//       // ContentView()
//            //.environmentObject(GlobalVariables())
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .environmentObject(GlobalVariables())
//    }
//}

