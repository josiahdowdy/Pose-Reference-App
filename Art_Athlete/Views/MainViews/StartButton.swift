//
//  StartButton.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-15.
//

import SwiftUI
import Files

struct StartButton: View {
    @ObservedObject var storedUserData = StoredUserData()
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    @Environment(\.managedObjectContext) var context
   // @ObservedObject var folderArrayModel: FoldersArrayModel
    @AppStorage("storedFileURLs") var storedFileURLs: [[URL]] = [[]]
    @AppStorage("arrayOfFolderNames") var arrayOfFolderNames: [String] = []

    @State var url : URL = URL(fileURLWithPath: "nil")
    @State var isRandom: Bool = true

    @State var testUrlResourceKey = Set<URLResourceKey>()
    @Binding var rowSelection: Set<String>
    
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: VIEW
    var body: some View {
            Button("Start \(Image(systemName: "play.rectangle.fill"))") {
                loadFolderFiles()
                startSession()
            }
            .keyboardShortcut(.defaultAction)
            .padding(20)
            .padding(.bottom, 20) //.buttonStyle(ButtonOnOffStyle())
    } //END UI View.

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: - Functions
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

    func startSession(){
        print("JD01 : loadLocalPhotos() : \(prefs.arrayOfURLStrings)")
        print("JD20: \(prefs.arrayOfURLStrings.count)")

        if (prefs.arrayOfURLStrings.count < prefs.homeManyPhotosToDraw[prefs.selectorCountTime]) {
            prefs.sPoseCount = prefs.arrayOfURLStrings.count
        } else {
            prefs.sPoseCount = prefs.homeManyPhotosToDraw[prefs.selectorCountTime]
        }

        if (isRandom) {
            prefs.arrayOfURLStrings.shuffle()
        }

        if (prefs.arrayOfURLStrings.isEmpty) {
            prefs.error = "Error loading images..." //Error Oct16 HomeView().error
        } else {
            //prefs.startBoolean.toggle()
            prefs.error = ""
            prefs.sURL = prefs.arrayOfURLStrings[0]
            print("JD500: prefs.sURL --> ", prefs.sURL)
            prefs.localPhotos = true
            prefs.disableSkip = false
            timeObject.timeChosen = Double(prefs.time[prefs.selectorIndexTime]) //Double(prefs.time[prefs.selectorIndexTime])!

            startTimer()
            prefs.startSession = true
        }
    }

    func loadFolderFiles() {
        print(prefs.arrayOfFolderNames)
        do {
            //    for i in folderArrayModel.folderArray {
            for i in prefs.arrayOfFolderNames {
            //    print("JD452: ", i.isToggle)

             //   if (i.isToggle) {
                    let loadFolderURL = try Folder.documents!.subfolder(named: i)

                    for file in try Folder(path: loadFolderURL.path).files {
                        prefs.arrayOfURLStrings.append(file.url.absoluteString)
                    }
               // }
            }
        } catch {
            print("JD452: error loading files from download folder.", error)
        }
    } //End Func.

   /* func loadFolderFiles() {
        do {
        //    for i in folderArrayModel.folderArray {
                for i in folderArrayModel {
                print("JD452: ", i.isToggle)

                if (i.isToggle) {
                    let loadFolderURL = try Folder.documents!.subfolder(named: i.name)

                    for file in try Folder(path: loadFolderURL.path).files {
                        prefs.arrayOfURLStrings.append(file.url.absoluteString)
                    }
                }
            }
        } catch {
            print("JD452: error loading files from download folder.", error)
        }
    } *///End Func.
} //End struct.
