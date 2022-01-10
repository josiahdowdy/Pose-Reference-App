/*
 Josiah - Oct 29, 2020
 When user presses 'Start' then this view is shown.
 It shows the buttons for session (skip, pause, save photo, exit)
 
 */

import SwiftUI
//import Kingfisher

struct NavBar: View {
    @Environment(\.managedObjectContext) var context

    @Environment(\.colorScheme) var currentDarkLightMode
    //@EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: GlobalVariables
    let persistenceController = PersistenceController.shared
    //var userData : FetchedResults<UserData>

    @AppStorage("showNavBar") var showNavBar = true
    
    @State private var showingSheet = false

    @State var skip = false
    @State var pause = false
    @State var blur = false
    @State var quit = false
    @State var rotation = 0.0
    @State var timeLeft = 0.0

    //@State var changeTimer = false
    //@Binding var startSession: Bool
    //@State var showNavBar = true
    
    var body: some View {
        //Spacer()
        //Spacer().frame(maxWidth: .infinity)

        if (prefs.numberTimer) {
            Text("\(timeLeft, specifier: "%.0f")")
            //Text("\(timeLeft)")
                .onReceive(prefs.$timeDouble) { input in
                    timeLeft = prefs.timeChosen - prefs.timeDouble
                }
        }

        if(showNavBar) {
            Text("\(self.prefs.currentIndex + 1)/\(prefs.sPoseCount)").padding(.bottom, 5)
                .font(.caption)
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 50).fill(currentDarkLightMode == .dark ? Color.black : Color.white))
            // .background(Color.black)
                .opacity(0.6)
                .foregroundColor(.white)
        }

        HStack(alignment: .bottom, spacing: 50) { //alignment: .bottom,
            //Show/Hide NavBar
            Button {
                showNavBar.toggle()
                print("\n\(showNavBar)\n")
            } label: {
                Image(systemName: showNavBar ? "menubar.rectangle" : "menubar.dock.rectangle.badge.record")
                    .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
            }

            //if(prefs.showNavBar) {
            if(showNavBar) {
                //SKIP
                Button(action: {
                    //changeTimer = false

                    print("\n jo: \(prefs.currentIndex + 1) = \(prefs.sPoseCount) ")

                    if ((prefs.currentIndex + 1) == (prefs.sPoseCount)) { ///End session if photos are at end.
                        prefs.timeDouble = 0.0
                        prefs.progressValue = 0.0
                        prefs.isTimerRunning = false
                        //self.startSession = false
                        endSession()
                    } else { ///Skip photo.
                        skip.toggle()
                        if (prefs.localPhotos) {
                            prefs.currentIndex += 1
                            prefs.sURL = (prefs.arrayOfURLStrings[prefs.currentIndex])
                            print("JD500: prefs.sURL \(prefs.sURL)")//self.prefs.currentIndex
                        } else { ///Only use if using Unsplash photos.
                            // PhotoView(prefs: _prefs, userLink: $prefs.portfolioURL).loadPhoto()
                        }
                        prefs.currentTime = 0
                        prefs.timeDouble = 0.0
                        prefs.progressValue = 0.0
                        prefs.startTime = Date()
                    }
                }) {
                    Image(systemName: "arrowshape.turn.up.right")
                        .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                }.disabled(prefs.disableSkip)
                    .keyboardShortcut(.rightArrow)
                    .buttonStyle(BorderlessButtonStyle())
                //.buttonStyle(bounceButtonStyle())

                //PAUSE TIMER
                Button(action: {
                    print("Pause")
                    if prefs.isTimerRunning {
                        // stop UI updates
                        pause.toggle()
                       // TimerView(timeObject: _timeObject, prefs: _prefs).stopTimer()
                        TimerView(prefs: _prefs).stopTimer() //, startSession: $startSession
                    } else {
                        pause.toggle()
                        // start UI updates
                        TimerView(prefs: _prefs).startTimer() //, startSession: $startSession
                    }
                    prefs.isTimerRunning.toggle()
                }) {
                    Image(systemName: pause ? "playpause.fill" : "playpause") //Text("Pause")
                        .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                }.keyboardShortcut(.space)
                    .buttonStyle(BorderlessButtonStyle())
                //.buttonStyle(bounceButtonStyle())

                if !(UIDevice.current.userInterfaceIdiom == .phone) {
                    //BLACK AND WHITE
                    Button(action: {
                        print("\nBlack and White processor filter.\n")
                        prefs.processorDefault.toggle()
                        prefs.processorBlack.toggle()
                    }) {
                        Image(systemName: "camera.filters") //Text("Grayscale")
                            .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                    }.buttonStyle(BorderlessButtonStyle())

                    //Upside Down
                    Button(action: {
                        print("\nUpside down.\n")
                        prefs.flippedVertically.toggle()
                    }) {
                        Image(systemName: prefs.flippedVertically ? "rotate.left.fill" : "rotate.left") //Text("Grayscale")
                            .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                    }.buttonStyle(BorderlessButtonStyle())

                    //Flip.
                    Button(action: {
                        print("\nFlip.\n")
                        prefs.flippedHorizontally.toggle()
                    }) {
                        Image(systemName: prefs.flippedHorizontally ? "arrow.left.and.right.righttriangle.left.righttriangle.right.fill" : "arrow.left.and.right.righttriangle.left.righttriangle.right") //Text("Grayscale")
                            .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                    }.buttonStyle(BorderlessButtonStyle())
                }
                //QUIT
                Button(action: {
                    print("quit")
                    endSession()
                }) {
                    Image(systemName: "multiply.circle.fill") //Text("Grayscale")
                        .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                }.buttonStyle(BorderlessButtonStyle())
            }

            //  Spacer()
        } //End HStack.
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 50).fill(currentDarkLightMode == .dark ? Color.black : Color.white))
        .opacity(0.6)

        
    } //End View.

    //MARK: - FUNCTIONS
    func endSession(){
        //TimerView(timeObject: _timeObject, prefs: _prefs)
        TimerView(prefs: _prefs).updateAtEndOfSession(timeChosen: prefs.timeChosen, context: context) // timeObject: _timeObject,
        pause = false
        self.prefs.endSessionBool.toggle()
        prefs.disableSkip.toggle()
        TimerView(prefs: _prefs).stopTimer()
        //TimerView(timeObject: _timeObject, prefs: _prefs).stopTimer()
        prefs.randomImages.photoArray.removeAll()
        prefs.currentIndex = 0
        prefs.poseCount = 0
        prefs.timeDrawn = 0

        prefs.localPhotos = false
        prefs.arrayOfURLStrings.removeAll()
        prefs.arrayOfFolderNames.removeAll()
        
        prefs.startSession = false
       // persistenceController.save()

        prefs.isTimerRunning = false
        persistenceController.save()
    }

//    func updateAtEndOfSession2(timeChosen: Double){
//        countPoses += 1
//        timeDrawn += Int16(timeChosen)//Int16(timeObject.timeChosen)
//
//        let userData = UserData(context: context)
//        userData.date = Date()
//        userData.id = UUID()
//        userData.countPoses = countPoses
//        userData.timeDrawn = timeDrawn
//
//        // userDataFetched[userDataFetched.count - 1].countPoses += 1
//
//        do{
//            try context.save()
//        }
//        catch{
//            alertMsg = error.localizedDescription
//            showAlert.toggle()
//        }
//    }
}


