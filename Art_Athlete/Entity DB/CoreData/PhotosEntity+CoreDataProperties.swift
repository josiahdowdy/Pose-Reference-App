//
//  PhotosEntity+CoreDataProperties.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-21.
//
//

import Foundation
import CoreData


extension PhotosEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotosEntity> {
        return NSFetchRequest<PhotosEntity>(entityName: "PhotosEntity")
    }

    @NSManaged public var fileName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var photoURL: URL?
    @NSManaged public var folderRel: FoldersEntity?


    public var wrappedFileName: String {
        fileName ?? "nil"
    }

}

extension PhotosEntity : Identifiable {

}
