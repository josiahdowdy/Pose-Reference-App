/* PersistenceController -  Josiah - Save local data. */
import CoreData
//import Foundation
//import UIKit

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentCloudKitContainer?

    //Core Data does not need to be initialized like cloudkit data does.
   // let coreDataContainer = NSPersistentContainer(name: "CoreData")
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "ArtAthlete")

        container?.loadPersistentStores(completionHandler: { (storeDescription, error) in
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
                fatalError("JD200: Note: Unresolved error \(error), \(error.userInfo)")
            }
        })

        /*
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } */
        container?.viewContext.automaticallyMergesChangesFromParent = true
        container?.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: - Cloudkit Data.
    func save(completion: @escaping (Error?) -> () = {_ in}) {
        let context = container?.viewContext
        //if context?.hasChanges {
        if ((context?.hasChanges) != nil) {
            do {
                try context?.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
        let context = container?.viewContext
        context?.delete(object)
        save(completion: completion)
    }

    //delete EVERTYING.
    public func clearDatabase() {
        guard let url = container?.persistentStoreDescriptions.first?.url else { return }
        let persistentStoreCoordinator = container?.persistentStoreCoordinator
        do {
            try persistentStoreCoordinator?.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
            try persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let error {
            print("Attempted to clear persistent store: " + error.localizedDescription)
        }
    }

    func deleteAll(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        //guard let context = self.container?.viewContext
        guard let context = self.container?.viewContext
        else { print("error in deleteAll")
            return }

        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            let objectIDArray = result?.result as? [NSManagedObjectID]
            let changes: [AnyHashable : Any] = [NSDeletedObjectsKey : objectIDArray as Any]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        } catch {
            print(error.localizedDescription)
        }
    }


    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container?.viewContext
        do {
            try viewContext?.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            //fatalError("Unresolved error \(nsError), \(nsError.")
        }
        return result
    }()
}


    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/

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








    /*
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
     }) */
    

/*
extension NSManagedObject {

    private static var entityName: String {
        return String(describing: self)
    }

    static func fetchRequest<Self>(
        with predicate: NSPredicate? = nil,
        configureBlock: ((NSFetchRequest<Self>) -> Void)? = nil
    ) -> NSFetchRequest<Self> where Self: NSFetchRequestResult {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.predicate = predicate
        configureBlock?(request)
        return request
    }


    static func batchDelete(with fetchRequest: NSFetchRequest<NSFetchRequestResult>,
                            in context: NSManagedObjectContext) {
        let batchDeteleRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeteleRequest.resultType = .resultTypeObjectIDs
        do {
            if let fetchResult = try context.execute(batchDeteleRequest) as? NSBatchDeleteResult,
               let deletedManagedObjectIds = fetchResult.result as? [NSManagedObjectID], !deletedManagedObjectIds.isEmpty {
                let changes = [NSDeletedObjectsKey: deletedManagedObjectIds]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
        } catch {
            print("Error while executing batchDeleteRequest: \(error.localizedDescription)")
        }
    }
}
*/
//extension NSManagedObjectContext {
//
//    /// Executes the given `NSBatchDeleteRequest` and directly merges the changes to bring the given managed object context up to date.
//    ///
//    /// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
//    /// - Throws: An error if anything went wrong executing the batch deletion.
//    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
//        batchDeleteRequest.resultType = .resultTypeObjectIDs
//        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
//        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
//        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
//    }
//}

//MARK: Core Data.
/*
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




