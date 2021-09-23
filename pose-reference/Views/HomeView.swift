/*
 Josiah
 Oct 29, 2020
 
 HomeView is main.
 
 Project flow:
 HomeView has
        PhotoView (photo)
      + NavigationView (buttons at bottom)
      + TimerView: which has (ProgressBarView)
      
 HomeDetails pops up as a sheet,
    which has loadUnsplashPhotos()
        + options to select settings for session (time, photoCount, poseType)
 
------------------------------------------------------------------------------------------------------
 To do:
 // BUG BUG: If you pause the timer, and then wait a few minutes, and then hit play, it will skip the photo (the timer must keep on running in background?)
 1. Collection search.
 2. When no internet display error message.
 3. Set localPhotos AND unsplashPhotos to false after session ends so
 user cannot start new session without selecting photos
 
 2. Update Stats: total poses drawn
        Save to a note sheet in app
        -Only add to time of total if user finishes the photo time. (if they skip halfway then that photo time doesn't count)
        -If user finished drawing photo time (30 seconds), then true, now add total time towards total drawing time.

 3. Allow user to type collection name in tag search.
 
 5. Draw a sketch bg image for Main Menu + design logo. "Artist Reference"

 Bugs:
 -timer bug? Sometimes the timer does not start, if I minimize the app, and then reopen it?
 - User can swipe down on the home view sheet and it just shows the session not started.
 
 Low priority:
 Offline mode: cached images from Unsplash
 Prefetch data with Fisher (does not seem slow in loading photos...so maybe not?)
 */
import UniformTypeIdentifiers
import SwiftUI
import CoreData


struct HomeView: View {
    //@Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var prefs: Settings
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var userObject: UserObject
    
    ///User Data saving
    @Environment(\.managedObjectContext) private var viewContext //UserData

    @FetchRequest(entity: UserData.entity(), sortDescriptors: []) //, predicate: NSPredicate(format: "status != %@", Status.completed.rawValue)

    var userData: FetchedResults<UserData>
    ///End UserData saving
    
    @State var isImporting: Bool = false

    @State private var showingSheet = false
    
    //Access the apps document directory.
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for:.documentDirectory, in : .userDomainMask)
        return paths[0]
    }

    var body: some View {
        Group {
            ZStack {
                if prefs.startBoolean {
                    PhotoView(prefs: _prefs, userLink: $prefs.portfolioURL)
                }
                VStack {
                    Spacer().frame(maxWidth: .infinity)
                    
                    Text("\(self.prefs.currentIndex + 1)/\(prefs.sPoseCount)").padding(.bottom, 5)
                        .font(.caption)
                        .background(Color.black)
                        .foregroundColor(.white)
                    HStack {
                            TimerView(prefs: _prefs).padding(.bottom, 5)
                        }
                }
            }
        }
        
        Group {
            HStack(){
                NavigationView(prefs: _prefs).padding(.bottom, 5)
            }
            .padding(.bottom, 30)
        }
        //Set which view opens when timer runs out on last image.
        .sheet(isPresented: $prefs.showMainMenu) { //$showingSheet
            //HomeDetails(prefs: _prefs, userObject: _userObject, name: "Artist")
            return HomeDetails(isPresented: $showingSheet)
                .environmentObject(self.userObject)
                .environmentObject(self.prefs)
                .environmentObject(self.timeObject)
        }
    }
    
    ///Create the user data before launching app (if no user data)
    func createNewUser(){
        let newUser = UserData(context: viewContext)
        newUser.id = UUID()
        newUser.userPoseCount = 743
    }
}

/* struct HomeView_Previews: PreviewProvider {
    @EnvironmentObject var prefs: Settings
    @EnvironmentObject var timeObject: TimerObject
    
    static var previews: some View {
        Text("home view")
        //HomeView(prefs: _prefs, timeObject: _timeObject)
    }
} */

