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

    @NSManaged public var folderName: String?
    @NSManaged public var tag: String?
    @NSManaged public var folderURL: URL?
    @NSManaged public var photosArray: NSSet? //An NSSet can contain ANYTHING.
    
    public var wrappedFolderName: String {
        folderName ?? "Unknown Folder"
    }
    
    public var wrappedTag: String {
        tag ?? "Unknown Tag"
    }
    
    public var wrappedFolderURL: URL {
        folderURL! //?? URL(string: "test")!
    }
    
    public var photosArrayJosiah: [PhotosArray] {
        let set = photosArray as? Set<PhotosArray> ?? []
        
        //
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for photosArray
extension PhotoFolders {

    @objc(addPhotosArrayObject:)
    @NSManaged public func addToPhotosArray(_ value: PhotosArray)

    @objc(removePhotosArrayObject:)
    @NSManaged public func removeFromPhotosArray(_ value: PhotosArray)

    @objc(addPhotosArray:)
    @NSManaged public func addToPhotosArray(_ values: NSSet)

    @objc(removePhotosArray:)
    @NSManaged public func removeFromPhotosArray(_ values: NSSet)

}

extension PhotoFolders : Identifiable {

}
