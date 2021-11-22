////
////  PersistenceControllerCoreData.swift
////  Art_Athlete
////
////  Created by josiah on 2021-11-21.
////
//
//    /* Josiah - Save local data. */
//
//    import CoreData
//    import Foundation
//
//    struct PersistenceControllerCoreData {
//        static let shared = PersistenceController()
//
//        let coreDataContainer = NSPersistentContainer(name: "CoreData")
//
//        init(inMemory: Bool = false) {
//            coreDataContainer.loadPersistentStores { (storeDescription, error)  in
//                if let error = error as NSError? {
//                    fatalError("JD200: Note: Unresolved error \(error), \(error.userInfo)")
//                }
//            }
//            //container.viewContext.automaticallyMergesChangesFromParent = true
//            //container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        }
//
//        /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
//        /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
//        //MARK: - Core Data.
//        func saveCoreData(completion: @escaping (Error?) -> () = {_ in}) {
//            let context = coreDataContainer.viewContext
//            if context.hasChanges {
//                do {
//                    try context.save()
//                } catch {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    let nserror = error as NSError
//                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//                }
//            }
//        }
//
//        func deleteCoreData(_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
//            let context = coreDataContainer.viewContext
//            context.delete(object)
//            saveCoreData(completion: completion)
//        }
//
//
//        //delete EVERTYING.
//        public func clearDatabase() {
//            guard let url = coreDataContainer.persistentStoreDescriptions.first?.url else { return }
//            let persistentStoreCoordinator = coreDataContainer.persistentStoreCoordinator
//            do {
//                try persistentStoreCoordinator.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
//                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
//            } catch let error {
//                print("Attempted to clear persistent store: " + error.localizedDescription)
//            }
//        }
//
//
//        /*
//         func updateUserInfo(userData: UserData) {
//         //let newStatus = userData.orderStatus == .pending ? Status.preparing : .completed
//         let newUserCount = userData.userPoseCount
//         viewContext.performAndWait {
//         //userData.orderStatus = newStatus
//         userData.userPoseCount = newUserCount
//         try? viewContext.save()
//         }
//         } */
//
//        static var preview: PersistenceControllerCoreData = {
//            let result = PersistenceControllerCoreData(inMemory: true)
//            let viewContext = result.coreDataContainer.viewContext
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                //fatalError("Unresolved error \(nsError), \(nsError.")
//            }
//            return result
//        }()
//    }
