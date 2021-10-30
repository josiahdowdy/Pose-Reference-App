//
//  PhotoFolders+CoreDataProperties.swift
//  Art_Athlete
//
//  Created by josiah on 2021-10-30.
//
//

import Foundation
import CoreData


extension PhotoFolders {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoFolders> {
        return NSFetchRequest<PhotoFolders>(entityName: "PhotoFolders")
    }

    @NSManaged public var folderURL: URL?
    @NSManaged public var tag: String?
    @NSManaged public var folderName: String?

}

extension PhotoFolders : Identifiable {

}
