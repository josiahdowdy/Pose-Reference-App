/*
 Josiah - Oct 29, 2020
 When user presses 'Start' then this view is shown.
 It shows the buttons for session (skip, pause, save photo, exit)
 
 */

import SwiftUI
//import Kingfisher

struct NavBar: View {
    @Environment(\.colorScheme) var currentDarkLightMode
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: GlobalVariables
    let persistenceController = PersistenceController.shared
    var testData : FetchedResults<UserData>

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
                .onReceive(timeObject.$timeDouble) { input in
                    timeLeft = timeObject.timeChosen - timeObject.timeDouble
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
                        timeObject.timeDouble = 0.0
                        timeObject.progressValue = 0.0
                        timeObject.isTimerRunning.toggle()
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
                        timeObject.timeDouble = 0.0
                        timeObject.progressValue = 0.0
                        timeObject.startTime = Date()
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
                    if timeObject.isTimerRunning {
                        // stop UI updates
                        pause.toggle()
                        TimerView(timeObject: _timeObject, prefs: _prefs).stopTimer() //, startSession: $startSession
                    } else {
                        pause.toggle()
                        // start UI updates
                        TimerView(timeObject: _timeObject, prefs: _prefs).startTimer() //, startSession: $startSession
                    }
                    timeObject.isTimerRunning.toggle()
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
                    //self.startSession = false
                    //ContentView()
                }) {
                    Image(systemName: "multiply.circle.fill") //Text("Grayscale")
                        .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                }.buttonStyle(BorderlessButtonStyle())
            }

            //  Spacer()
        } //End HStack.
        //.cornerRadius(15.0)
        .padding(10)
        //.opacity(5)
        .background(RoundedRectangle(cornerRadius: 50).fill(currentDarkLightMode == .dark ? Color.black : Color.white))
        .opacity(0.6)
       // .background(currentDarkLightMode == .dark ? Color.black : Color.white)

        //.cornerRadius(15.0)
        //.opacity(90)

       // .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
    } //End View.

    //MARK: - FUNCTIONS
    func endSession(){
        //  self.startSession = false
        pause = false
        self.timeObject.endSessionBool.toggle()
        prefs.disableSkip.toggle()
        TimerView(timeObject: _timeObject, prefs: _prefs).stopTimer()
        prefs.randomImages.photoArray.removeAll()
        prefs.currentIndex = 0

        prefs.localPhotos = false
        prefs.arrayOfURLStrings.removeAll()
        prefs.arrayOfFolderNames.removeAll()
        
        prefs.startSession = false
        persistenceController.save()
    }
}



/*
 .sheet(isPresented: $showingSheet) {
 HomeScreen(prefs: _prefs, name: "Artist!", startSession: $startSession) //, isPresented: $showingSheet Josiah Oct16
 }.buttonStyle(BorderlessButtonStyle())
 */
//.buttonStyle(bounceButtonStyle())
//.keyboardShortcut(.escape)
//Photo counter x /30
/*
 Button(action: {
 //action open all photos
 }) {
 Text("\(self.prefs.currentIndex + 1)/\(prefs.sPoseCount)").padding(.bottom, 5)
 }.buttonStyle(BorderlessButtonStyle())
 */


