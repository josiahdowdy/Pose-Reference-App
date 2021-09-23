/*
 Josiah - Oct 29, 2020
 Time object used to keep track of time counting.
 
 */

import Foundation

class TimerObject: ObservableObject {
    @Published var isTimerRunning = false
    @Published var startTime =  Date()
    //@Published var timerString = "0.00"
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var timeDouble = 1.0
    @Published var timeLength = 2.0
    @Published var totalSessionDrawTimeDone = 0.0
    @Published var progressValue: Float = 0.0
    @Published var endSessionBool: Bool = false
}
