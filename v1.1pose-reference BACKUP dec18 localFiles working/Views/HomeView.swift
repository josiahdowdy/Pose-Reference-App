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
 
 1. In PhotoView --> add Unsplash name text + author name.
 
 2. Cancel session is greyed out after starting a new session (or 2) (can't select it)
 3. The timer does not start with a new session after 1st one is ended
 
 2. When I hit play after pausing, the timer restarts, but a new picture shows.
    Edit so the same image finishes.
        -Only add to time of total if user finishes the photo time. (if they skip halfway then that photo time doesn't count)
        -If user finished drawing photo time (30 seconds), then true, now add total time towards total drawing time.

 2. Allow user to type collection name in tag search. 
 
 3. Offline mode: cached or local folder images
    load images into an array
 
 4. Draw a sketch bg image for Main Menu + design logo. "Artist Reference"
 
 Future updates:
 5. Upload your own photos
 
 Bugs:
 -timer bug? Sometimes the timer does not start, if I minimize the app, and then reopen it?
 - User can swipe down on the home view sheet and it just shows the session not started.
 
 Low priority:
 Prefetch data with Fisher (does not seem slow in loading photos...so maybe not?)
 */
import UniformTypeIdentifiers
import SwiftUI

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var prefs: Settings
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var userObject: UserObject
    
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
                    PhotoView(prefs: _prefs)
                }
                VStack {
                    Spacer().frame(maxWidth: .infinity)
                    Text("\(self.prefs.currentIndex + 1)/\(prefs.sPoseCount)").padding(.bottom, 5)
                       // .offset(y: 800)
                       // .padding(.bottom, 20)
                    //Spacer() //.frame(maxWidth: .infinity) //Attach bar to bottom
                        
                                        HStack {
                            TimerView(prefs: _prefs).padding(.bottom, 5)
                           // TimerView(timeObject: _timeObject).environmentObject(timeObject)
                        }//.offset(y: 600)
                       // .padding(.bottom, 200)
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
            //ContentView()
            return HomeDetails(isPresented: $showingSheet)
                .environmentObject(self.userObject)
                .environmentObject(self.prefs)
                .environmentObject(self.timeObject)
        }
    }
    
    
    /*  func loadPhoto(){
        prefs.currentIndex += 1
        if !(prefs.randomImages.photoArray.isEmpty) {
            prefs.sURL = (prefs.randomImages.photoArray[prefs.currentIndex].urls["regular"]!)
        }
    }   */
}

struct HomeView_Previews: PreviewProvider {
    @EnvironmentObject var prefs: Settings
    @EnvironmentObject var timeObject: TimerObject
    
    static var previews: some View {
        Text("home view")
        //HomeView(prefs: _prefs, timeObject: _timeObject)
    }
}

