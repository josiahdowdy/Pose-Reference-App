//
//  PhotoFolders+CoreDataProperties.swift
//  Art_Athlete
//
//  Created by josiah on 2021-10-30.
//
//

import Foundation
import CoreData


extension PhotoFolders : Identifiable { //, SelectableRow

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoFolders> {
        return NSFetchRequest<PhotoFolders>(entityName: "PhotoFolders")
    }

    @NSManaged public var folderName: String?
    @NSManaged public var tag: String?
    @NSManaged public var id: UUID?
    @NSManaged public var folderURL: URL?

    //@NSManaged public var folderURLArray: [URL]?


    @NSManaged public var isSelected: Bool
    @NSManaged public var photos: NSSet? //An NSSet can contain ANYTHING.

    //@NSManaged public var workingDirectoryBookmark: NSSet?
    @NSManaged public var photo: Data?
   // @NSManaged public var photoDataArray: Data?


    public var wrappedPhoto: Data {
        photo ?? Data()
    }


    public var wrappedFolderName: String {
        folderName ?? "Unknown Folder"
    }
    
    public var wrappedTag: String {
        tag ?? "Unknown Tag"
    }
//
//    public var wrappedWorkingDirectoryBookmark : Data {
//        workingDirectoryBookmark 
//        didSet {
//            UserDefaults.standard.set(workingDirectoryBookmark, forKey: "workingDirectoryBookmark")
//        }
//    }



    public var wrappedFolderURL: URL {
        folderURL ?? URL(string: "n")!
    }

//    public var wrappedIsSelected: Bool {
//        isSelected // = true
//
//       // get { return isSelected }
//       // set { isSelected = true }
//       // Binding<isSelected>
//      //  return isSelected
//    }


   // var getSetIsSelected: Bool { get set }

//    public var filesArray: [PhotosArray] {
//        let set = photosArray as? Set<PhotosArray> ?? []
//
//        return set.sorted {
//            $0.wrappedName < $1.wrappedName
//        }
//    }

    
    public var photosArraySorted: [PhotosArray] {
        let set = photos as? Set<PhotosArray> ?? []  //photosArray
        //
     //   return set.filter(<#T##isIncluded: (PhotosArray) throws -> Bool##(PhotosArray) throws -> Bool#>)
        //return set.filter(isIncluded: )

        return set.sorted {  $0.wrappedName < $1.wrappedName }
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
//
//extension PhotoFolders : Identifiable {
//
//}


