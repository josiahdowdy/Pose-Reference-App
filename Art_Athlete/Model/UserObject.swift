
import CoreData

class UserObject: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var order: Int
    @NSManaged var posesDrawn: Int
   //@NSManaged var date: Date = Date()
    @NSManaged var date: Date
    
    @NSManaged var totalTimeDrawn: Int
    @NSManaged var totalPosesDrawn: Int
    @NSManaged var totalPosesDrawnToday: Int

    @NSManaged var arrayOfFolderNames : [String] 
    
    //Certificates
    //Make an array with the certs.
    @NSManaged var currectCert: String
    @NSManaged var beginnerCert: Bool
    @NSManaged var intermediateCert: Bool
    @NSManaged var advancedCert: Bool
    @NSManaged var masterCert: Bool
    
    @NSManaged var userName: String?
    @NSManaged var lastUsedSearch: String?
    @NSManaged var favoriteQuote: String?

    public var wrappedUserName: String {
        userName ?? "empty name"
    }
    

}

extension UserObject {
    static func getListItemFetchRequest() -> NSFetchRequest<UserObject>{
        let request = UserObject.fetchRequest() as! NSFetchRequest<UserObject>
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        return request
    }
}









/*
import Foundation

class UserObject: ObservableObject {
    @Published var userName = "Hagrid"
    @Published var lastUsedSearch = ""
    @Published var favoriteQuote = ""
    
    //Total Time Drawn in all history.
    @Published var totalTimeDrawn: Int = 0
    @Published var totalPosesDrawn = 0
    @Published var totalPosesDrawnToday = 0

    //Certificates
    //Make an array with the certs. 
    @Published var currectCert = "beginner"
    @Published var beginnerCert = true
    @Published var intermediateCert = false
    @Published var advancedCert = false
    @Published var masterCert = false
    
}
*/
