//  ContentView.swift - Art Athlete
//  Created by josiah on 2021-10-17.

import SwiftUI
import CoreData
//import CheckDevice
import Files
import SlideOverCard
import UniformTypeIdentifiers
//import CoreLocation

//TODO: - Selected down form the dropdown.


//FIXME: - CAN ADD these lines to view.


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
        //sortDescriptors: [NSSortDescriptor(keyPath: \UserData.countPoses, ascending: true)]
     //Memory
    
    //@FetchRequest(entity: UserEntity.entity(), sortDescriptors: [])
    //var userObject: FetchedResults<UserEntity>
    //, predicate: NSPredicate(format: "status != %@", Status.completed.rawValue)
    
    

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
       // .onAppear(perform: loadBookmarkedPhotos())
    }
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/

    //MARK: - FUNCTIONS


    @available(iOS 15.0.0, *)
    private func loadBookmarkedPhotos() {
        //for photo in storedUserData.arrayWorkingDirectoryBookmark {
        //prefs.arrayOfURLStringsTEMP = restoreFileAccessArray(with: (storedUserData.arrayWorkingDirectoryBookmark))!

        prefs.arrayOfURLStringsTEMP.removeAll()

        ///I can store about 5,000 photos safely, that will equal about 512kb of data. Assuming this is stored locally?
        print("JD1000: arrayWorkingDirectoryBookmark SIZE --> ", storedUserData.arrayWorkingDirectoryBookmark)

        //MARK: - Loads in array of photos.
        for i in 0..<storedUserData.arrayWorkingDirectoryBookmark.count {
            url = restoreFileAccess(with: storedUserData.arrayWorkingDirectoryBookmark[i])!

            //FIXME: BOOKMARK URL IS WORKING. NOW, ADD IT TO AN ARRAY.
            if (url.startAccessingSecurityScopedResource()) {
//                prefs.arrayOfURLStringsTEMP.append(url)
//            //    prefs.arrayOfURLStrings.append(String(describing: url))
//                //print("JD68: LOADING BOOKMARK. \(prefs.arrayOfURLStrings)")
            } else {
                print("JD67: False")
           }
        }
        url.stopAccessingSecurityScopedResource()
        
        print("\nLOADING BOOKMARK DONE ------------------------------------")
    } //End func.

    @available(iOS 15.0.0, *)
    private func restoreFileAccess(with bookmarkData: Data) -> URL? {
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmarkData, relativeTo: nil, bookmarkDataIsStale: &isStale)

            if isStale {
                // bookmarks could become stale as the OS changes
                print("Bookmark is stale, need to save a new one... ")
                saveBookmarkData(for: url)
            }
            return url
        } catch {
            print("Error resolving bookmark:", error)
            return nil
        }
    }

    private func saveBookmarkData(for workDir: URL) {
        do {
            let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: testUrlResourceKey, relativeTo: nil)
            storedUserData.arrayWorkingDirectoryBookmark.append(bookmarkData)
        } catch {
            print("Failed to save bookmark data for \(workDir)", error)
        }
    }
} //End Struct.





//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//       // ContentView()
//            //.environmentObject(GlobalVariables())
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .environmentObject(GlobalVariables())
//    }
//}

