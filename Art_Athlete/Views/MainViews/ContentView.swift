//  ContentView.swift - Art Athlete - Created by josiah on 2021-10-17.
import SwiftUI
import CoreData
import UniformTypeIdentifiers
import SlideOverCard
//import Files

struct ContentView: View {
    @ObservedObject var prefs = GlobalVariables()
    //@StateObject var timeObject = TimerObject() //@ObservedObject
    //@StateObject var userObject = UserObject()
   // @StateObject var homeData = HomeViewModel()



    @Environment(\.colorScheme) var currentDarkLightMode
    @Environment(\.managedObjectContext) var context
    //@Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared

//    @EnvironmentObject var prefs: GlobalVariables
//    @EnvironmentObject var timeObject: TimerObject
//    @EnvironmentObject var homeData: HomeViewModel

    @State var isImporting: Bool = false
    @State var isSettingsPresented = false

    @State var pause = false

    @State var url : URL = URL(fileURLWithPath: "nil")
   // @State var testUrlResourceKey = Set<URLResourceKey>() //FIXME: Not sure how to use this yet...

    //Settings vars.
    @State var notifyMeAbout : Bool = true
    @State var playNotificationSounds : Bool = false
    @State var profileImageSize : Bool = true
    @State var sendReadReceipts : Bool = true

    @FetchRequest(entity: UserData.entity(), sortDescriptors: []) var userData: FetchedResults<UserData>
    
    @State var startSession = false

    @AppStorage("isFirstLaunch") public var isFirstLaunch = true

//    var assetImages: [UIImage] = [
//        UIImage(named: "dance.jpeg")!,
//        UIImage(named: "jump.jpeg")!,
//        UIImage(named: "standing.jpeg")!,
//        UIImage(named: "dance2.jpeg")!,
//        UIImage(named: "couple.jpeg")!
//    ]
//
//    var imageNames: [String] = [
//        "dance.jpeg",
//        "jump.jpeg",
//        "standing.jpeg",
//        "dance2.jpeg",
//        "couple.jpeg"
//    ]
   

    init() {
     //   isFirstLaunch = true //For debugging.
        print("JD00: First time launching. [Content View] →  \(isFirstLaunch)")
        if (isFirstLaunch) {
            createFolder()
            isFirstLaunch = false

           // prefs.objectWillChange
        }
    }
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/

    //MARK: - UI
    var body: some View {
//        if !(prefs.introIsFinished) {
//            IntroScreen()
//        }

        ZStack(alignment: Alignment.top) {
            if (prefs.introIsFinished) {
               if (!prefs.startSession) {
                    HomeScreenButtonsView() //homeData: homeData
                      //  .environmentObject(homeData)
                        .environmentObject(prefs)
                        //.environmentObject(timeObject)
                        .environment(\.managedObjectContext, persistenceController.container!.viewContext)
                        //.environmentObject(sharedData)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                       // .transition(AnyTransition.move(edge: .leading)).animation(.default)
                }
            }

            if prefs.startSession {
                DrawingView(userData: userData, startSession: $startSession)//(userData: userData, startSession: $startSession)
                    .environmentObject(prefs)
            }
        }
        .slideOverCard(isPresented: $prefs.showSettings, options: [.hideExitButton]) { //$isSettingsPresented
            ArtAthleteSettings()
                .environmentObject(prefs)
        }
        .slideOverCard(isPresented: $prefs.showStats, options: [.hideExitButton]) { //$prefs.showStats
            StatsView(userStats: userData) //showStats: $prefs.showStats,
                .environmentObject(prefs)
        }
    } //End View
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: FUNCTIONS
    func createFolder() {
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent("Poses")
        let docURL = URL(fileURLWithPath: documentsPath.path!)

        let poseImages: [UIImage] = [
            UIImage(named: "dance.jpeg")!,
            UIImage(named: "jump.jpeg")!,
            UIImage(named: "standing.jpeg")!,
            UIImage(named: "dance2.jpeg")!,
            UIImage(named: "couple.jpeg")!
        ]

        let poseNames: [String] = [
            "dance.jpeg",
            "jump.jpeg",
            "standing.jpeg",
            "dance2.jpeg",
            "couple.jpeg"
        ]

        do {
            try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)

            for i in 0...(poseImages.count-1) {
                prefs.countingTest += 1
                print("JD00: \(prefs.countingTest)")
                let dataPath = docURL.appendingPathComponent("Poses/\(poseNames[i])")
                let data = poseImages[i].jpegData(compressionQuality: 1.0)
                try data!.write(to: dataPath)
            }
        } catch let error as NSError {
            print(error)
        }
    }
} //End Struct.

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//       // ContentView()
//            //.environmentObject(GlobalVariables())
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .environmentObject(GlobalVariables())
//    }
//}


