/*
 Josiah - Oct 29, 2020
 When user presses 'Start' then this view is shown.
 It shows the buttons for session (skip, pause, save photo, exit)
 
 */

import SwiftUI
import Kingfisher

struct NavigationView: View {
    //@Environment(\.presentationMode) var presentationMode //Oct17
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: Settings

    @State private var showingSheet = false

    
    //@Binding var localPhotos: Bool
    //@Binding var unsplashPhotos = false
    
    @State var skip = false
    @State var pause = false
    @State var blur = false
    //@State var changeTimer = false
    @State var quit = false
    @State var rotation = 0.0
    @State var timeLeft = 0.0
    
    //@State private var startSession = false
    @Binding var startSession: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 50) { //alignment: .bottom,
            Spacer()
                
                //SKIP
                Button(action: {
                    //changeTimer = false
                    
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
                    HomeDetails(prefs: _prefs, name: "Artist!", startSession: $startSession) //, isPresented: $showingSheet Josiah OCT16
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
            
            //Change Timer Style
            /*
            Button(action: {
                print("\nTimer Style\n")
                //changeTimer.toggle()
                prefs.changeTimer.toggle()
            }) {
                Image(systemName: prefs.changeTimer ? "clock.fill" : "clock" ) //Text("Grayscale")
            }.buttonStyle(BorderlessButtonStyle())
            .buttonStyle(bounceButtonStyle())
            */
            
            //QUIT
                Button(action: {
                    print("quit")
                    endSession()
                    self.startSession = false
                    //ContentView()
                }) {
                    Image(systemName: "multiply.circle.fill") //Text("Grayscale")
                }.buttonStyle(BorderlessButtonStyle())
                .sheet(isPresented: $showingSheet) {
                    HomeDetails(prefs: _prefs, name: "Artist!", startSession: $startSession) //, isPresented: $showingSheet Josiah Oct16
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
            
            if (!prefs.changeTimer) {
                //do nothing
            } else if (prefs.changeTimer) {
                Text("\(timeLeft, specifier: "%.0f")")
                //Text("\(timeLeft)")
                    .onReceive(timeObject.$timeDouble) { input in
                        timeLeft = timeObject.timeLength - timeObject.timeDouble
                    }
            }
        
            Spacer()
            
        }
    }
    
    func endSession(){
        //self.showingSheet.toggle()
        prefs.showMainMenu.toggle()
        pause = false
        //changeTimer = false

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
