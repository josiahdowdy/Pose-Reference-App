//
//  UserData+CoreDataProperties.swift
//  pose-reference
//
//  Created by josiah on 2021-10-22.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }
    
    
    @NSManaged public var date: Date?
    //@NSManaged public var sessionTimerLength: Int16?
    @NSManaged public var userName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var countPoses: Int16
    
   // @NSManaged public var status: String
    
//
//    var orderStatus: artStatus {
//        set {
//            status = newValue.rawValue
//        }
//        get {
//            artStatus(rawValue: status) ?? .pending
//        }
//    }
    
    
}

extension UserData : Identifiable {
    
}


//enum artStatus: String {
//    case pending = "Pending"
//    case preparing = "Preparing"
//    case completed = "Completed"
//}
//
