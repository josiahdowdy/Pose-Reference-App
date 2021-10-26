// Josiah Oct 29, 2020
import UniformTypeIdentifiers
import SwiftUI
import CoreData

struct DrawingView: View {
    //@Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var userObject: UserObject
    
    //User Data saving
//    @Environment(\.managedObjectContext) private var viewContext //UserData
//    @FetchRequest(entity: UserData.entity(), sortDescriptors: [], predicate: NSPredicate(format: "status != %@", Status.completed.rawValue)) //
//    var userData: FetchedResults<UserData>
    //End UserData saving
    
    var testData : FetchedResults<UserData>
    
    @State var isImporting: Bool = false
    
    @State private var showingSheet = false
    
    //@State private var startSession = false
    
    @Binding var startSession: Bool

    //Access the apps document directory.
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for:.documentDirectory, in : .userDomainMask)
        return paths[0]
    }
    
    //Begin view.
    var body: some View {
        Group {
            ZStack {
                if prefs.startBoolean {
                    PhotoView() //prefs: _prefs //, userLink: $prefs.portfolioURL
                }
                VStack {
                    Spacer().frame(maxWidth: .infinity)
                    
                    Text("\(self.prefs.currentIndex + 1)/\(prefs.sPoseCount)").padding(.bottom, 5)
                        .font(.caption)
                        .background(Color.black)
                        .foregroundColor(.white)
                    HStack {
                        
                        if !(prefs.hideTimer) {
                            if (prefs.numberTimer) {
                                //print(timeObject.progressValue)
                            } else {
                                TimerView(prefs: _prefs).padding(.bottom, 5)
                            }
                        }
                        
                    } //End HStack
                } //End VStack.
            } //End ZStack
        } //End Group
        
        Group {
            HStack(){
                NavBar(prefs: _prefs, testData: testData, startSession: $startSession).padding(.bottom, 5)
            }
            .padding(.bottom, 30)
        }
        //Set which view opens when timer runs out on last image.
        /*
         .sheet(isPresented: $prefs.showMainMenu) { //$showingSheet
         //HomeScreen(prefs: _prefs, userObject: _userObject, name: "Artist")
         return HomeScreen() //Josiah Oct16 isPresented: $showingSheet
         .environmentObject(self.userObject)
         .environmentObject(self.prefs)
         .environmentObject(self.timeObject)
         */
    }
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

