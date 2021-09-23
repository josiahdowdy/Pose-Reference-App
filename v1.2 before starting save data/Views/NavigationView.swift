/*
 Josiah - Oct 29, 2020
 When user presses 'Start' then this view is shown.
 It shows the buttons for session (skip, pause, save photo, exit)
 
 */

import SwiftUI

struct NavigationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: Settings

    @State private var showingSheet = false
    
    //@Binding var localPhotos: Bool
    //@Binding var unsplashPhotos = false
    

    var body: some View {
        HStack(alignment: .bottom, spacing: 50) { //alignment: .bottom,
            Spacer()
                
                //SKIP
                Button(action: {
                    print("\n* Prefs: \(prefs.currentIndex) = \(prefs.sPoseCount)\n")
                    if ((prefs.currentIndex + 1) == (prefs.sPoseCount)) || ((prefs.currentIndex + 1) == (prefs.sPoseCount)) { ///End session if photos are at end.
                        timeObject.timeDouble = 0.0
                        timeObject.progressValue = 0.0
                        timeObject.isTimerRunning.toggle()
                        endSession()
                    } else {
                        self.prefs.currentIndex += 1
                        
                        if (prefs.localPhotos) {
                            prefs.sURL = (prefs.arrayOfURLStrings[self.prefs.currentIndex])
                        } else {
                            prefs.sURL = (prefs.randomImages.photoArray[self.prefs.currentIndex].urls["regular"]!) ///Only use if using Unsplash photos.
                        }
                        
                        timeObject.timeDouble = 0.0
                        timeObject.progressValue = 0.0
                        timeObject.startTime = Date()
                    }

                }) {
                    Image(systemName: "arrowshape.turn.up.right")//Text("Skip")
                }.disabled(prefs.disableSkip)
                .sheet(isPresented: $showingSheet) {  //$showingSheet
                    HomeDetails(prefs: _prefs, name: "Artist!", isPresented: $showingSheet)
                }.keyboardShortcut(.rightArrow)
                .buttonStyle(BorderlessButtonStyle())
            
                //PAUSE TIMER
                Button(action: {
                    print("Pause")
                    if timeObject.isTimerRunning {
                        //TimerView(isTimerRunning: false)
                        // stop UI updates
                        TimerView(timeObject: _timeObject, prefs: _prefs).stopTimer()
                        Timer().invalidate() //stop the timer,
                    } else {
                        // start UI updates
                        TimerView(timeObject: _timeObject, prefs: _prefs).startTimer()
                    }
                    timeObject.isTimerRunning.toggle()
                    
                    //prefs.timeCountdown = prefs.timeLength
                }) {
                    Image(systemName: "playpause") //Text("Pause")
                }.keyboardShortcut(.space)
                .buttonStyle(BorderlessButtonStyle())
            
            
                Button(action: {
                    print("Grayscale")
                }) {
                    Image(systemName: "suit.heart") //Text("Grayscale")
                }.buttonStyle(BorderlessButtonStyle())
            
            //QUIT
                Button(action: {
                    print("quit")
                    endSession()
                }) {
                    Image(systemName: "multiply.circle.fill") //Text("Grayscale")
                }.buttonStyle(BorderlessButtonStyle())
                .sheet(isPresented: $showingSheet) {
                    HomeDetails(prefs: _prefs, name: "Artist!", isPresented: $showingSheet)
                }
                 //.keyboardShortcut(.escape)
            
            Spacer()
            }
    }
    
    func endSession(){
        //self.showingSheet.toggle()
        prefs.showMainMenu.toggle()

        print("showingSheet bool: \(self.showingSheet)")
        self.timeObject.endSessionBool.toggle()
        prefs.disableSkip.toggle()
        TimerView(timeObject: _timeObject, prefs: _prefs).stopTimer()
        prefs.startBoolean.toggle()
        prefs.randomImages.photoArray.removeAll()
        self.prefs.currentIndex = 0
        
        prefs.localPhotos = false
        prefs.arrayOfURLStrings.removeAll()
    }
}
