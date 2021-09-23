/*
 Josiah - Oct 29, 2020
 When user presses 'Start' then this view is shown.
 It shows the buttons for session (skip, pause, save photo, exit)
 
 */

import SwiftUI
import Kingfisher

struct NavigationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: Settings

    @State private var showingSheet = false
    
    //@Binding var localPhotos: Bool
    //@Binding var unsplashPhotos = false
    
    @State var skip = false
    @State var pause = false
    @State var blur = false
    @State var download = false
    @State var quit = false
    @State var rotation = 0.0


    var body: some View {
        
        
        HStack(alignment: .bottom, spacing: 50) { //alignment: .bottom,
            Spacer()
                
                //SKIP
                Button(action: {
                    download = false
                    
                    print("\n jo: \(prefs.currentIndex + 1) = \(prefs.sPoseCount) ")
                    
                    if ((prefs.currentIndex + 1) == (prefs.sPoseCount)) { ///End session if photos are at end.
                        timeObject.timeDouble = 0.0
                        timeObject.progressValue = 0.0
                        timeObject.isTimerRunning.toggle()
                        
                        endSession()
                    } else { ///Skip photo.
                        skip.toggle()
                        if (prefs.localPhotos) {
                            prefs.currentIndex += 1 //self.
                            prefs.sURL = (prefs.arrayOfURLStrings[prefs.currentIndex]) //self.prefs.currentIndex
                        } else { ///Only use if using Unsplash photos.
                            PhotoView(prefs: _prefs, userLink: $prefs.portfolioURL).loadPhoto()
                        }
                        
                        timeObject.timeDouble = 0.0
                        timeObject.progressValue = 0.0
                        timeObject.startTime = Date()
                        
                    }
                }) {
                    Image(systemName: "arrowshape.turn.up.right")
                    //Image(systemName: skip ? "arrowshape.turn.up.right.fill" : "arrowshape.turn.up.right")//Text("Skip")
                }.disabled(prefs.disableSkip)
                .sheet(isPresented: $showingSheet) {  //$showingSheet
                    HomeDetails(prefs: _prefs, name: "Artist!", isPresented: $showingSheet)
                }.keyboardShortcut(.rightArrow)
                .buttonStyle(BorderlessButtonStyle())
                .buttonStyle(bounceButtonStyle())
     
                //PAUSE TIMER
                Button(action: {
                    print("Pause")
                    if timeObject.isTimerRunning {
                        // stop UI updates
                        pause.toggle()
                        TimerView(timeObject: _timeObject, prefs: _prefs).stopTimer()
                        Timer().invalidate() //stop the timer,
                    } else {
                        pause.toggle()
                        // start UI updates
                        TimerView(timeObject: _timeObject, prefs: _prefs).startTimer()
                    }
                    timeObject.isTimerRunning.toggle()
                }) {
                    Image(systemName: pause ? "playpause.fill" : "playpause") //Text("Pause")
                }.keyboardShortcut(.space)
                .buttonStyle(BorderlessButtonStyle())
                .buttonStyle(bounceButtonStyle())
            
            //BLACK AND WHITE
                Button(action: {
                    print("\nBlack and White processor filter.\n")
                    prefs.processorDefault.toggle()
                    prefs.processorBlack.toggle()
                }) {
                    Image(systemName: "camera.filters") //Text("Grayscale")
                }.buttonStyle(BorderlessButtonStyle())
            
            //DOWNLOAD
            Button(action: {
                print("\nDownload\n")
                download = true
            }) {
                Image(systemName: download ? "square.and.arrow.down.fill" : "square.and.arrow.down" ) //Text("Grayscale")
            }.buttonStyle(BorderlessButtonStyle())
            .buttonStyle(bounceButtonStyle())
            
            //QUIT
                Button(action: {
                    print("quit")
                    endSession()
                }) {
                    Image(systemName: "multiply.circle.fill") //Text("Grayscale")
                }.buttonStyle(BorderlessButtonStyle())
                .sheet(isPresented: $showingSheet) {
                    HomeDetails(prefs: _prefs, name: "Artist!", isPresented: $showingSheet)
                }.buttonStyle(BorderlessButtonStyle())
                .buttonStyle(bounceButtonStyle())
                 //.keyboardShortcut(.escape)
            //Photo counter x /30
            /*
            Button(action: {
                //action open all photos
            }) {
                Text("\(self.prefs.currentIndex + 1)/\(prefs.sPoseCount)").padding(.bottom, 5)
            }.buttonStyle(BorderlessButtonStyle())
            */
            Spacer()
            }
    }
    
    func endSession(){
        //self.showingSheet.toggle()
        prefs.showMainMenu.toggle()
        pause = false
        download = false

        print("showingSheet bool: \(self.showingSheet)")
        self.timeObject.endSessionBool.toggle()
        prefs.disableSkip.toggle()
        TimerView(timeObject: _timeObject, prefs: _prefs).stopTimer()
        prefs.startBoolean.toggle()
        prefs.randomImages.photoArray.removeAll()
        prefs.currentIndex = 0
        
        print("\n prefs.currentIndex: \(prefs.currentIndex)")
        
        prefs.localPhotos = false
        prefs.collectionID = ""
        prefs.darkPortrait = false
        prefs.collection = false
        
        prefs.arrayOfURLStrings.removeAll()
        
        
    }
}
