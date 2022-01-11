//
//  StartButton.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-15.
//

import SwiftUI
import Files

struct StartButton: View {
    @Environment(\.colorScheme) var currentDarkLightMode
    //@ObservedObject var storedUserData = StoredUserData()
    @EnvironmentObject var prefs: GlobalVariables
    //@EnvironmentObject var timeObject: TimerObject
    @Environment(\.managedObjectContext) var context

    @State var url : URL = URL(fileURLWithPath: "nil")
 
    @State var testUrlResourceKey = Set<URLResourceKey>()
    @Binding var rowSelection: Set<String>
    
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: VIEW
    var body: some View {
        Button {
            loadFolderFiles()
            startSession()
        } label: {
            Text("\(Image(systemName: "play.rectangle.fill")) Start ")
                .frame(width: 100, height: 40)
                .foregroundColor(currentDarkLightMode == .dark ? Color.black : Color.white)
                .background(currentDarkLightMode == .dark ? Color.blue : Color.blue)
               // .foregroundColor(Color.black)
              //  .background(Color.blue)
                .clipShape(Rectangle())
                .cornerRadius(8)
                .padding(.bottom, 20)

        }.buttonStyle(PlainButtonStyle())


    } //END UI View.

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: - Functions
    //Don't confuse with start timer in Timer.swift
    private func startTimer() {
        prefs.isTimerRunning = true
        prefs.startTime = Date()
        prefs.progressValue = 0.0
        prefs.timeDouble = 0.0
//        let userDataStart = UserData(context: context)
//        userDataStart.date = Date()
        TimerView(prefs: _prefs).startTimer()
        //TimerView(timeObject: _timeObject, prefs: _prefs).startTimer()
        //, startSession: $startSession
    }

    func loadFolderFiles() {
        print(prefs.arrayOfFolderNames)
        do {
            for i in prefs.arrayOfFolderNames {
                let loadFolderURL = try Folder.documents!.subfolder(named: i)

                for file in try Folder(path: loadFolderURL.path).files {
                    prefs.arrayOfURLStrings.append(file.url.absoluteString)
                }
            }
        } catch {
            print("JD452: error loading files from download folder.", error)
        }
        print("JD460: prefs.arrayOfURLStrings → \(prefs.arrayOfURLStrings)")
    } //End Func.

    func startSession(){
        prefs.loadContentView = false
        if (toggleSwitch().isRandom) {
            prefs.arrayOfURLStrings.shuffle()
        }

        if (prefs.arrayOfURLStrings.count < prefs.homeManyPhotosToDraw[prefs.selectorCountTime]) {
            prefs.sPoseCount = prefs.arrayOfURLStrings.count
        } else {
            prefs.sPoseCount = prefs.homeManyPhotosToDraw[prefs.selectorCountTime]
        }

        if (prefs.arrayOfURLStrings.isEmpty) {
            prefs.error = "Please make sure you've imported and selected photos."
            prefs.errorNoPhotosSelected = true
        } else {
            //prefs.startBoolean.toggle()
            prefs.errorNoPhotosSelected = false
            prefs.error = ""
            prefs.sURL = prefs.arrayOfURLStrings[0]
            prefs.localPhotos = true
            prefs.disableSkip = false
            //timeObject.timeChosen = Double(prefs.time[prefs.selectorIndexTime])
            prefs.timeChosen = Double((prefs.time[prefs.selectorIndexTime]))
            //Double(prefs.time[prefs.selectorIndexTime])!

            startTimer()
            prefs.startSession = true
        }
    }

} //End struct.
