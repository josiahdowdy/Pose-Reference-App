//
//  PhotosArray+CoreDataProperties.swift
//  Art_Athlete
//
//  Created by josiah on 2021-10-30.
//
//

import Foundation
import CoreData


extension PhotosArray {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotosArray> {
        return NSFetchRequest<PhotosArray>(entityName: "PhotosArray")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var photoURL: URL?
    @NSManaged public var photoURLString: String?
    @NSManaged public var photoFolders: PhotoFolders?
    @NSManaged public var fileName: String?
    @NSManaged public var photo: Data?
    
    
    public var wrappedPhotoURL: URL {
        photoURL ?? URL(string: "n")!
    }

    public var wrappedPhotoURLString: String {
        photoURLString ?? "nil"
    }
    
    public var wrappedName: String {
        fileName ?? "Unknown Name"
    }

}

extension PhotosArray : Identifiable {

}
