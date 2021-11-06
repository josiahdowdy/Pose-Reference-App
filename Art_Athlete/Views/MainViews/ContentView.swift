//
//  ContentView.swift
//  pose-reference
//
//  Created by josiah on 2021-10-17.
//

import SwiftUI
import CoreData
//import CheckDevice
import SlideOverCard
import UniformTypeIdentifiers




struct ContentView: View {
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject

    @State private var position = CardPosition.top
    @State private var background = BackgroundStyle.blur

    @State var isImporting: Bool = false
    
    @State var pause = false

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
    
    var body: some View {
        //        if #available(iOS 15.0, *) {
        //  BaseView()
        //
        //        } else {
        //            // Fallback on earlier versions
        //        }

        if !(prefs.introIsFinished) {
            IntroScreen()
        }

        ZStack(alignment: Alignment.top) {

            if (prefs.introIsFinished) {
                if (!prefs.startSession) {
                    HomeScreenButtonsView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                        .transition(AnyTransition.move(edge: .leading)).animation(.default)
                        .fileImporter(
                            isPresented: $isImporting, allowedContentTypes: [UTType.folder],
                            allowsMultipleSelection: false, //set to true to select multiple folders. But then I need to put them in an array.
                            onCompletion: { result in
                                do {

                                    guard let selectedFolder: URL = try result.get().first else { return }
                                    //arrayOfPhotos = selectedFolder.pathComponents
                                    let newFolder = PhotoFolders(context: context)
                                    newFolder.folderURL = selectedFolder //Save the folder URL.

                                    let folderName: String = selectedFolder.lastPathComponent

                                    newFolder.folderName = folderName//newFolder.folderURL(newFolder.folderURL as
                                } catch { print("failed importing") }
                            })
                }
                if prefs.startSession {
                    DrawingView(testData: testData, startSession: $startSession)
                }
            }


            if (prefs.showSettings) {
                SlideOverCard($position, backgroundStyle: $background) {
                    VStack {
                        HStack {
                            Text("Settings")//.font(.title)
                                .bold()
                                .foregroundColor(Color("ColorAccentWhite"))
                                .background(Color("ColorGrayTwo"))
                                .cornerRadius(2)
                                .font(.subheadline)
                            //    .alignmentGuide(.center, computeValue: { _ in 90 } )
                            Button("Done") {
                                prefs.showSettings = false
                            }.alignmentGuide(.trailing, computeValue: { _ in 90 } )
                        }

                        toggleSwitch()

                        Spacer()
                    }
                }
            }

            if (prefs.addFolder) {
                
            }
        }
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
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//       // ContentView()
//            //.environmentObject(GlobalVariables())
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .environmentObject(GlobalVariables())
//    }
//}

