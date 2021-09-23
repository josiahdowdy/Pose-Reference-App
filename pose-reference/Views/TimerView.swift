/*
 Josiah - Oct 29, 2020
 Handles timer UI and stop and start.
 Called by NavigationView.
 */

import SwiftUI
import CoreData

struct TimerView: View {
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: Settings
    @EnvironmentObject var userObject: UserObject

    ///User Data saving
    @Environment(\.managedObjectContext) private var viewContext //UserData

    @FetchRequest(entity: UserData.entity(), sortDescriptors: []) //, predicate: NSPredicate(format: "status != %@", Status.completed.rawValue)

    var userData: FetchedResults<UserData>
    
    
    @State var userPoseCount = 0
    ///End UserData saving

    var body: some View {
        VStack {
            ProgressBar(value: $timeObject.progressValue)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    print("Moving to the background!")
                    TimerView(timeObject: _timeObject, prefs: _prefs).stopTimer()
                    Timer().invalidate() //stop the timer,
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    print("Moving back to the foreground!")
                    TimerView(timeObject: _timeObject, prefs: _prefs).startTimer()
                }
                .frame(height: 10)
                .onReceive(self.timeObject.timer) { _ in
                    
                    //If the boolean is set to true.
                    if self.timeObject.isTimerRunning {
                        
                        //print("\n*** timer is running")
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
                                
                                //Save user data pose count.
                                //userData.count += 1
                                updateUserInfo()
                                PhotoView(prefs: _prefs, userLink: $prefs.portfolioURL).loadPhoto()
                                
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
                    self.stopTimer()
                }
        }.padding()
    }
    
    func endSession() {
        prefs.arrayOfURLStrings.removeAll()
        timeObject.timeDouble = 0.0
        timeObject.progressValue = 0.0
        timeObject.isTimerRunning = false
        timeObject.endSessionBool.toggle()
        timeObject.progressValue = 0.0
        prefs.disableSkip.toggle()
        NavigationView(timeObject: _timeObject, prefs: _prefs).endSession()
    }
        
    func stopTimer() {
        self.timeObject.timer.upstream.connect().cancel()
    }
    
    func startTimer() {
        self.timeObject.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        //timeObject.timer.tolerance = 0.2
    }

    ///First time create info
    func newUserInfo(){
        let newUserData = UserData(context: viewContext)
        newUserData.userPoseCount = Int16(self.userPoseCount)
        newUserData.id = UUID()
        
    }
    
    //Update data in future.
    func updateUserInfo(){
      //  let newUserData = UserData(context: viewContext)
        //newUserData.userPoseCount = self.userPoseCount
        //newUserData.id = UUID()
        
    }
    
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
