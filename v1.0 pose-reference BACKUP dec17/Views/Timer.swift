/*
 Josiah - Oct 29, 2020
 Handles timer UI and stop and start.
 Called by NavigationView.
 */

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: Settings
    @EnvironmentObject var userObject: UserObject


    var body: some View {
        VStack {
            ProgressBar(value: $timeObject.progressValue)
                .frame(height: 10)
                .onReceive(self.timeObject.timer) { _ in
                    
                    //If the boolean is set to true.
                    if self.timeObject.isTimerRunning {
                        timeObject.timeDouble = ((Date().timeIntervalSince(self.timeObject.startTime)))
                        timeObject.totalSessionDrawTimeDone += timeObject.timeDouble 
                        self.timeObject.progressValue += Float(1 / timeObject.timeLength)
                        
                        //If time is up for photo go back to 0
                        if (timeObject.timeDouble >= timeObject.timeLength) {
                            timeObject.progressValue = 0.0
                            timeObject.timeDouble = 0.0
                            timeObject.startTime = Date()
                            
                            //If there is another photo in queue then go ahead
                            if (prefs.currentIndex + 1 < prefs.sPoseCount) {
                                timeObject.progressValue = 0.0
                                timeObject.timeDouble = 0.0
                                
                                PhotoView(prefs: _prefs).loadPhoto()
                            } else { //else if done with last photo, end session.
                                //End session.
                                timeObject.timeDouble = 0.0
                                timeObject.progressValue = 0.0
                                timeObject.isTimerRunning.toggle()
                                timeObject.endSessionBool.toggle()
                                timeObject.progressValue = 0.0
                                NavigationView(timeObject: _timeObject, prefs: _prefs).endSession()
                                      
                            }
                        }
                    } else { //if the timer boolean is false, stop the timer.
                        self.stopTimer() //Stop timer. Check to make sure works.
                        //If timer is not working, then move up to else above.
                    }
                }
                /*
                .onTapGesture {
                    if timeObject.isTimerRunning {
                        // stop UI updates
                        self.stopTimer()
                    } else {
                        //timeObject.timerString = "0.00"
                        timeObject.startTime = Date()
                        // start UI updates
                        self.startTimer()
                    }
                    timeObject.isTimerRunning.toggle()
                }   */
                .onAppear() {
                    // no need for UI updates at startup
                    self.stopTimer()
                }
        }.padding()
    }
        
    func stopTimer() {
        self.timeObject.timer.upstream.connect().cancel()
    }
    
    func startTimer() {
        //self.timeObject.timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        self.timeObject.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        //timeObject.timer.tolerance = 0.2
    }
    
}
