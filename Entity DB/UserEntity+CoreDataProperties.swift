//
//  UserEntity+CoreDataProperties.swift
//  pose-reference
//
//  Created by josiah on 2021-10-22.
//
//

import Foundation
import CoreData

extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var posesTotal: Int16
    @NSManaged public var posesToday: Int16
    @NSManaged public var date: Date?
    @NSManaged public var posesDrawnInSession: Int16
    @NSManaged public var posePhotoLength: Int16
    @NSManaged public var status: String
    @NSManaged public var dateString: String
    
    /*
    var sessionStatus: Status {
        set {
            status = newValue.rawValue
        }
        get {
            Status(rawValue: status) ?? .drawing
        }
    }
     */
}

extension UserEntity : Identifiable {
}

/*
enum Status: String {
    case drawing = "Drawing"
    case studying = "Studying"
    case completed = "Completed"
}
 */
