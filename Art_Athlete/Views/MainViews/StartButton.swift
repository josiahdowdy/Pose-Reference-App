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
    @EnvironmentObject var timeObject: TimerObject
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
        timeObject.isTimerRunning = true
        timeObject.startTime = Date()
        timeObject.progressValue = 0.0
        timeObject.timeDouble = 0.0
//        let userDataStart = UserData(context: context)
//        userDataStart.date = Date()
        TimerView(timeObject: _timeObject, prefs: _prefs).startTimer() //, startSession: $startSession
    }

    func startSession(){
        if (toggleSwitch().isRandom) {
            prefs.arrayOfURLStrings.shuffle()
        }

        if (prefs.arrayOfURLStrings.count < prefs.homeManyPhotosToDraw[prefs.selectorCountTime]) {
            prefs.sPoseCount = prefs.arrayOfURLStrings.count
        } else {
            prefs.sPoseCount = prefs.homeManyPhotosToDraw[prefs.selectorCountTime]
        }

        if (prefs.arrayOfURLStrings.isEmpty) {
            prefs.error = "Error loading images..." //Error Oct16 HomeView().error
        } else {
            //prefs.startBoolean.toggle()
            prefs.error = ""
            prefs.sURL = prefs.arrayOfURLStrings[0]
            prefs.localPhotos = true
            prefs.disableSkip = false
            //timeObject.timeChosen = Double(prefs.time[prefs.selectorIndexTime])
            timeObject.timeChosen = Double((prefs.time[prefs.selectorIndexTime]))
            //Double(prefs.time[prefs.selectorIndexTime])!

            startTimer()
            prefs.startSession = true
        }
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

    //IPHONE and iPad load files.
    func loadFolderFilesiPad() {
        ///1. Print the files in the directory.
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first
        else { //.appendingPathComponent("\(name).jpg")
            print("error getting path.")
            return
        }

        let loadFiles = Folder.documents?.files
        let subFolders = Folder.documents?.subfolders

        print("JD451: loadfiles ••••••••• \(String(describing: loadFiles.debugDescription))")
        print("JD451: subfolders ••••••••• \(String(describing: subFolders))")

        for file in loadFiles!  { //
            prefs.arrayOfURLStrings.append(file.url.absoluteString)
        }

        print("JD451: path DIRECTORY is --> \(path)")
       // print("JD451: path DIRECTORY is --> \(path)")



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
    } //End Func.

    func getImageFromFileManager() {
      //  image = manager.getImage(name: imageName)
    }
} //End struct.
