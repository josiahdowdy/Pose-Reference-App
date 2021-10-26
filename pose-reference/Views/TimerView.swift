/*
 Josiah - Oct 29, 2020
 Handles timer UI and stop and start.
 Called by NavBar.
 */

import SwiftUI
//import CoreData
//import Foundation

struct TimerView: View{
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: GlobalVariables
    //@EnvironmentObject var userTest: UserEntity
    
    //@State var currentMemory: Memory?
    
    //@EnvironmentObject var userObject: UserObject
    
    //SAVE DATA...
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: UserData.entity(), sortDescriptors: []
        //sortDescriptors: [NSSortDescriptor(keyPath: \UserData.countPoses, ascending: true)]
    )
    var testData : FetchedResults<UserData>
    
    @Binding var startSession: Bool
    /*
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: UserEntity.entity(), sortDescriptors: []) //, predicate: NSPredicate(format: "status != %@", Status.completed.rawValue)
    var userEntity: FetchedResults<UserEntity> */
    
    //@State var memory: Memory?
    //@State var userInfo: UserEntity?
    @State var date: Date = Date()
    //@State var userSessionPoseCount : Int16 = 0
    @State var alertMsg = ""
    @State var showAlert = false
    @State var posesCount = 0
    

    ///User Data saving
    //@Environment(\.managedObjectContext) private var viewContext
    //@FetchRequest(entity: UserData.entity(), sortDescriptors: []) //, predicate: NSPredicate(format: "status != %@", Status.completed.rawValue)
    //var userData: FetchedResults<UserEntity> //  UserData !!!!!!!!!!!!!!!!!!!!!!!!!!!!!look here
    
//    @State private var startSession = true
    @State private var showNavBar = true
    //@State private var startSession = true
    
    //@Binding var startSession: Bool
    //-------------END VARIABLES------------------------------------------------------------
    
    
    //-------------START VIEW------------------------------------------------------------
    var body: some View {
        VStack {
            ProgressBar(value: $timeObject.progressValue)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    print("Moving to the background!")
                    TimerView(timeObject: _timeObject, prefs: _prefs, startSession: $startSession).stopTimer()
                    Timer().invalidate() //stop the timer,
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    print("Moving back to the foreground!")
                    TimerView(timeObject: _timeObject, prefs: _prefs, startSession: $startSession).startTimer()
                }
                .frame(height: 10)
            
                
                .onReceive(self.timeObject.timer) { _ in
                    //If the boolean is set to true.
                    if self.timeObject.isTimerRunning {
                        timeObject.timeDouble = ((Date().timeIntervalSince(self.timeObject.startTime)))
                        timeObject.totalSessionDrawTimeDone += timeObject.timeDouble
                        self.timeObject.progressValue += Float(1 / timeObject.timeLength)
                        
                        //If time is up for photo go back to 0
                        if (timeObject.timeDouble >= timeObject.timeLength) {
                            timeObject.progressValue = 0.0
                            timeObject.timeDouble = 0.0
                            timeObject.startTime = Date()
                            
                            //If there is another photo in queue then go ahead
                            if (prefs.currentIndex + 1 < prefs.sPoseCount) {
                                timeObject.progressValue = 0.0
                                timeObject.timeDouble = 0.0
                                
                                prefs.currentIndex += 1
                                prefs.sURL = prefs.arrayOfURLStrings[self.prefs.currentIndex]

                                posesCount += 1
                                testData[0].countPoses += 1

                                updateSession()
                                
                            } else { //else if done with last photo, end session.
                                endSession()
                            }
                        }
                    } else { //if the timer boolean is false, stop the timer.
                        self.stopTimer() //Stop timer. Check to make sure works.
                        //If timer is not working, then move up to else above.
                    }
                }
                .onAppear() {
                    // no need for UI updates at startup
                    //self.stopTimer()
                }
        }.padding()
    }//------------------END OF VIEW------------------------------------------------------
    
    
    
    
    
    //-------------------FUNCTIONS-----------------------------------------------
    //Update data in future.
    func updateSession(){
        do{
            try context.save()
            //close.toggle()
        }
        catch{
            alertMsg = error.localizedDescription
            showAlert.toggle()
        }
        
        
        //testData : UserData
       // let test = UserData(context: context)
        
//        if (testData.countPoses == 0) {
//            testData.date = Date()
//        }
//        let test = testData()
        //test.username = "poop"
        //test.countPoses = 33
        
        //testData.countPoses += 1
//        testData.username = "FUCK YEAH"
        
       // let updateCount = userData.count  // = UserData(context: context)
        //newUserData.count = Int16(prefs.userSessionPoseCount)
       // newUserData.id = UUID()
        
    }
    
    func newSession(){
        let test = UserData(context: context)
        test.countPoses = 4
        
        //let newUserData = UserData(context: context)
        //newUserData.userPoseCount = Int16(prefs.userSessionPoseCount)
        //newUserData.id = UUID()
        
        //print(newUserData.id as Any)
    }
    
    
    
    func endSession() {
        self.startSession = false
 
        prefs.arrayOfURLStrings.removeAll()
        //timeObject.timeDouble = 0.0
        //timeObject.progressValue = 0.0
        timeObject.isTimerRunning = false
        timeObject.endSessionBool.toggle()
        prefs.disableSkip.toggle()
        
        NavBar(timeObject: _timeObject, prefs: _prefs, testData: testData, startSession: $startSession).endSession()
    }
    
    func stopTimer() {
        self.timeObject.timer.upstream.connect().cancel()
        print("\nSTOP TIMER\n")
    }
    
    func startTimer() {
        self.timeObject.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        print("\nSTART TIMER\n")
        
        //timeObject.timer.tolerance = 0.2
    }
    //Save the data to the ArtAthlete database.
    /*
    func updateData() {
        //let user = userData(context: self.moc)
        //user.count += 1
        
        
        if userInfo != nil{
            print("\nEXISTING USER\n")
            userInfo?.posesToday = Int16(posesCount)
            userInfo?.posePhotoLength = Int16(exactly: prefs.time[prefs.selectorIndexTime])!
            //userInfo? = content
            //userInfo?.image = imageData
            //userInfo?.dateString = prefs.userSessionPoseCount
            
        }
        else{
            print("\nNEW USER\n")
            let userInfo = UserEntity(context: context)
            userInfo.posesToday = Int16(posesCount)
            //userInfo.timestamp = date
            //userInfo.userPoseCount = prefs.userSessionPoseCount
             //memory.content = content
             //memory.image = imageData
             
        }
        
        do{
            try context.save()
            //close.toggle()
        }
        catch{
            alertMsg = error.localizedDescription
            showAlert.toggle()
        }
    } */
    
    func saveDataUpdate(){
        //newSession.posesToday = prefs.userSessionPoseCount
        //let sess = UserEntity.self
        //let session = UserEntity.posesToday
        //sess.posesToday = Int16(prefs.userSessionPoseCount)
        //Save the data.
        
        //let sess = UserEntity.fetchRequest()
        //let currSession = UserEntity(context: viewContext)
        //currSession.posesToday = Int16(prefs.userSessionPoseCount)
        
        /*
        do {
            try viewContext.save()
            print("\n Updated session saved.\n")
        } catch {
            print(error.localizedDescription)
        }
        
        print("\ncurrSession.id: \(currSession.id).\n")
        print("\ncurrSession.dateString: \(currSession.dateString).\n")
        print("\ncurrSession.posesToday: \(currSession.posesToday).\n")
        */
        //@State var startSessionA = false
        
        //HomeScreen(startSession: $startSessionA).saveData()
        
       
    }
    
    
    ///First time create info
    
    
    
}


/*
 Button(action: {
 guard self.tableNumber != "" else {return}
 let newOrder = Order(context: viewContext)
 newOrder.pizzaType = self.pizzaTypes[self.selectedPizzaIndex]
 newOrder.orderStatus = .pending
 newOrder.tableNumber = self.tableNumber
 newOrder.numberOfSlices = Int16(self.numberOfSlices)
 newOrder.id = UUID()
 do {
 try viewContext.save()
 print("Order saved.")
 presentationMode.wrappedValue.dismiss()
 } catch {
 print(error.localizedDescription)
 }
 }) {
 Text("Add Order")
 }
 */







/*
 //Save data
 lazy var persistentContainer: NSPersistentContainer = {
 /*
  The persistent container for the application. This implementation
  creates and returns a container, having loaded the store for the
  application to it. This property is optional since there are legitimate
  error conditions that could cause the creation of the store to fail.
  */
 let container = NSPersistentContainer(name: "Data")
 container.loadPersistentStores(completionHandler: { (storeDescription, error) in
 if let error = error as NSError? {
 // Replace this implementation with code to handle the error appropriately.
 // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
 
 /*
  Typical reasons for an error here include:
  * The parent directory does not exist, cannot be created, or disallows writing.
  * The persistent store is not accessible, due to permissions or data protection when the device is locked.
  * The device is out of space.
  * The store could not be migrated to the current model version.
  Check the error message to determine what the actual problem was.
  */
 fatalError("Unresolved error \(error), \(error.userInfo)")
 }
 })
 return container
 }()
 
 // MARK: - Core Data Saving support
 
 func saveContext () {
 let context = persistentContainer.viewContext
 if context.hasChanges {
 do {
 try context.save()
 } catch {
 // Replace this implementation with code to handle the error appropriately.
 // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
 let nserror = error as NSError
 fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
 }
 }
 }  */

/*
 func updateUserInfo(userData: UserData) {
 //let newStatus = userData.orderStatus == .pending ? Status.preparing : .completed
 let newUserCount = userData.userPoseCount
 viewContext.performAndWait {
 //userData.orderStatus = newStatus
 userData.userPoseCount = newUserCount
 try? viewContext.save()
 }
 } */
