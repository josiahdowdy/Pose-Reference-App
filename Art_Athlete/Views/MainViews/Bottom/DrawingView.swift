// Josiah Oct 29, 2020
import UniformTypeIdentifiers
import SwiftUI
import CoreData

struct DrawingView: View {
    @Environment(\.colorScheme) var currentDarkLightMode
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var userObject: UserObject

    var testData : FetchedResults<UserData>
    @State var userData = UserData()
    
    @State var isImporting: Bool = false
    
    @State private var showingSheet = false

    @Binding var startSession: Bool

    //Access the apps document directory.
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for:.documentDirectory, in : .userDomainMask)
//        return paths[0]
//    }
    
    //Begin view.
    var body: some View {
        Group {
            ZStack {
            //    if prefs.startBoolean {
                    PhotoView() //prefs: _prefs //, userLink: $prefs.portfolioURL
              //  }
                VStack {
                    Spacer().frame(maxWidth: .infinity)

                    NavBar(prefs: _prefs) //.padding(.bottom, 5)

                    HStack {
                        if !(prefs.hideTimer) {
                            if (prefs.numberTimer) {
                                //print(timeObject.progressValue)
                            } else {
                                TimerView(prefs: _prefs).padding(.bottom, 5) //, startSession: $startSession
                            }
                        }
                    } //End HStack
                    
                } //End VStack.
            } //End ZStack
        } //End Group
    } //End View.

    //Start Functions
}

///Create the user data before launching app (if no user data)

/*
 func createNewUser(){
 let newUser = UserData(context: viewContext)
 newUser.id = UUID()
 newUser.userPoseCount = 743
 }
 */

/*
struct PhotoButtonsView_Previews: PreviewProvider {
    @State static var start = true
    
    static var previews: some View {
        Text("home view")
        //HomeView(prefs: _prefs, timeObject: _timeObject)
        DrawingView(startSession: $start, userData: userData)
            .environmentObject(GlobalVariables())
            .environmentObject(TimerObject())
            .environmentObject(UserObject())
    }

}
 */

