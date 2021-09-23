/*
Josiah
 Dec 23, 2020
 */

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var userPoseCount: Int16
    @NSManaged public var userName: String?
    @NSManaged public var id: UUID?
    //@NSManaged public var status: String
    
    /*
     var orderStatus: Status {
         set {
             status = newValue.rawValue
         }
         get {
             Status(rawValue: status) ?? .pending
         }
     }
     */

}

extension UserData : Identifiable {

}

/*
 enum Status: String {
     case pending = "Pending"
     case preparing = "Preparing"
     case completed = "Completed"
 }

 */
