//
//  HomeScreenButtonsView.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-02.
//

import SwiftUI

struct HomeScreenButtonsView: View {
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    @Environment(\.managedObjectContext) var context
    
   // @Binding var startSession: Bool
    
    
    @State var isRandom: Bool = true
    //-----END VARIABLES------
    var body: some View {
        VStack {
            FileImporterView()
            Spacer().frame(maxWidth: .infinity)
            
            toggleSwitch()
            timePickerView()
            
            Button("Start") { //Button("\(Image(systemName: "play.rectangle.fill")) Start") {
             //   NavBarView().loadLocalPhotos()
                loadLocalPhotos()
                
            }
            .keyboardShortcut(.defaultAction)
            .padding(20)
            .padding(.bottom, 20) //.buttonStyle(ButtonOnOffStyle())
        }
        
        
    } //--------END VIEW-------------

      //---------START FUNCTIONS-------
    //Don't confuse with start timer in Timer.swift
    private func startTimer() {
        timeObject.isTimerRunning = true
        timeObject.startTime = Date()
        timeObject.progressValue = 0.0
        timeObject.timeDouble = 0.0
        TimerView(timeObject: _timeObject, prefs: _prefs).startTimer() //, startSession: $startSession
        let newSession = UserData(context: context)
        newSession.date = Date()
    }
    
    func loadLocalPhotos(){
        if (isRandom) {
            prefs.arrayOfURLStrings.shuffle()
        }
        
        if (prefs.arrayOfURLStrings.isEmpty) {
            prefs.error = "Error loading images..." //Error Oct16 HomeView().error
        } else {
            //prefs.startBoolean.toggle()
            prefs.error = ""
            prefs.sURL = prefs.arrayOfURLStrings[0]
            prefs.localPhotos = true
            prefs.disableSkip = false
            timeObject.timeChosen = Double(prefs.time[prefs.selectorIndexTime]) //Double(prefs.time[prefs.selectorIndexTime])!
            
            startTimer()
            prefs.startSession = true
            //ContentView().$startSession = true
            
            
            
            //self.presentationMode.wrappedValue.dismiss() //Josiah Oct15 //Hide sheet.
            //   self.startSession = true //Tells the view to switch and start.
            //ContentView().startSession = true
            //prefs.sessionFirstStarted = false
            //saveData()
            //TimerView().newUserInfo()
            //passInfo()
        }
    }  //End of load local photos
    
      //---------END FUNCTIONS---------

}
//
//struct HomeScreenButtonsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeScreenButtonsView()
//    }
//}
