//
//  FoldersEntity+CoreDataProperties.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-21.
//
//

import Foundation
import CoreData


extension FoldersEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoldersEntity> {
        return NSFetchRequest<FoldersEntity>(entityName: "FoldersEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var folderName: String?
    @NSManaged public var folderURL: URL?
    @NSManaged public var photosRel: NSSet?

    public var wrappedFolderName: String {
        folderName ?? "Unknown Folder"
    }

    public var wrappedFolderURL: URL {
        folderURL ?? URL(string: "n")!
    }

    public var photosArray: [FoldersEntity] {
        let set = photosRel as? Set<FoldersEntity> ?? []
        return set.sorted {  $0.wrappedFolderName < $1.wrappedFolderName }
    }

    

}

// MARK: Generated accessors for photosRel
extension FoldersEntity {

    @objc(addPhotosRelObject:)
    @NSManaged public func addToPhotosRel(_ value: PhotosEntity)

    @objc(removePhotosRelObject:)
    @NSManaged public func removeFromPhotosRel(_ value: PhotosEntity)

    @objc(addPhotosRel:)
    @NSManaged public func addToPhotosRel(_ values: NSSet)

    @objc(removePhotosRel:)
    @NSManaged public func removeFromPhotosRel(_ values: NSSet)

}

extension FoldersEntity : Identifiable {

}
