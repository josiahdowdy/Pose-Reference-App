/* TimerView - Josiah - Oct 29, 2020  */
import SwiftUI
import CoreData

struct TimerView: View{
    //@EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: GlobalVariables
    let persistenceController = PersistenceController.shared
    @Environment(\.managedObjectContext) var context
   // NSManagedObjectContext

    @FetchRequest(
        entity: UserData.entity(), sortDescriptors: []
        //sortDescriptors: [NSSortDescriptor(keyPath: \UserData.countPoses, ascending: true)]
    )
    var userDataFetched : FetchedResults<UserData>

    //@State var userData = UserData()

    @State private var date: Date = Date()
    @State private var alertMsg = ""
    @State private var showAlert = false
    @State private var countPoses: Int16 = 0
    @State private var timeDrawn: Int16 = 0
    @State private var isActive = true

    //@State var userDataObject = UserData() //(context: context)

    //@State var userDataObject = UserData()//UserData(context: context)
    //-------------END VARIABLES------------------------------------------------------------
    
    
    //-------------START VIEW------------------------------------------------------------
    var body: some View {
        VStack {
            ProgressBar(value: $prefs.progressValue)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    print("\nMoving to the BACKGROUND!")
                    self.isActive = false
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    print("\nMoving back to the FOREGROUND!")
                   // TimerView(timeObject: _timeObject, prefs: _prefs).startTimer()
                    TimerView(prefs: _prefs).startTimer() //, startSession: $startSession
                    self.isActive = true
                }
                .frame(height: 10)
                .onReceive(self.prefs.timer) { _ in
                    guard self.isActive else { return } //Makes sure timer stops right away when app moves to background.

                    //If the time is less than
                    if self.prefs.currentTime < prefs.timeChosen {
                        addTime()
                        //userData[0].timeDrawn += 1
                    } else if (prefs.currentTime == prefs.timeChosen) {
                        firstImageUpdate()
                        //If you are not on the final image, then load the next image.
                        if (prefs.currentIndex + 1 < prefs.sPoseCount) {
                            nextImage()  //    userData.timeDrawn += Int16(timeObject.timeChosen)
                        //Final image finished, end session.
                        } else {
                            prefs.poseCount += 1
                            prefs.timeDrawn += Int16(prefs.timeChosen)
                            updateAtEndOfSession(timeChosen: prefs.timeChosen, context: context) //Only done at end of session. And called when quit.
                            endSession()
                        } //End else
                    } //End else if
                } //End onReceive.
        }.padding() //End VStack

    }//------------------END OF VIEW------------------------------------------------------
    
    //-------------------FUNCTIONS-----------------------------------------------
    private func addTime() {
        self.prefs.currentTime += 1
        self.prefs.progressValue += Float(1 / prefs.timeChosen)
    }

    private func firstImageUpdate() {
        prefs.currentTime = 0
        prefs.progressValue = 0.0
    }

    private func nextImage() {
        prefs.currentIndex += 1
        prefs.sURL = prefs.arrayOfURLStrings[self.prefs.currentIndex]
        prefs.poseCount += 1
        prefs.timeDrawn += Int16(prefs.timeChosen)
        //self.countPoses += 1
        //self.timeDrawn += Int16(timeObject.timeChosen)
    }

    func endSession() {
        prefs.startSession = false
        prefs.poseCount = 0
        prefs.timeDrawn = 0
        prefs.currentIndex = 0 
        prefs.isTimerRunning = false
        prefs.endSessionBool.toggle()
        prefs.disableSkip.toggle()
        prefs.arrayOfURLStrings.removeAll()
        prefs.arrayOfFolderNames.removeAll()
        persistenceController.save()
    }

    func startTimer() {
        self.prefs.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }

    func stopTimer() {
        self.prefs.timer.upstream.connect().cancel()
    }

    func updateAtEndOfSession(timeChosen: Double, context: NSManagedObjectContext){ //NSManagedObjectContext
        //self.countPoses += 1
        //self.timeDrawn += Int16(timeChosen)

        let userData = UserData(context: context)
        userData.date = Date()
        userData.id = UUID()
        userData.countPoses = prefs.poseCount
        userData.timeDrawn = prefs.timeDrawn

       // userDataFetched[userDataFetched.count - 1].countPoses += 1

        do{
            try context.save()
        }
        catch{
            alertMsg = error.localizedDescription
            showAlert.toggle()
            print("JD500 error")
        }
        print("JD500: Saved user data.")
    }

//    private func createUserData() {
//        //userData : UserData
//        let userData = UserData(context: context)
//
//        if (userData.countPoses == 0) {
//            userData.date = Date()
//        }
//        userData.countPoses += 1
//        //userData.userName = "John"
//
//        //let updateCount = userData.countPoses  // = UserData(context: context)
//        userData.countPoses = Int16(prefs.userSessionPoseCount)
//        userData.id = UUID()
//    }
}


/*

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
