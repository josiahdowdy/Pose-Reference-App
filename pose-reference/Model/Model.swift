/*
 Josiah - Oct 29, 2020
 Handles loading JSON data from Unsplash.
*/

import SwiftUI

struct Photo: Identifiable, Decodable {
    var id: String
    var alt_description: String?
    var urls: [String : String]
    //var user: [String : String]
        //var user: String?
    //var user: [String : String]
    //var total_likes, total_photos, total_collections: Int
    //var username, name, color: String?//[String : String]
    //var portfolio_url: String?
    
    var user: SponsoredBy?
}

// MARK: - SponsoredBy
struct SponsoredBy: Decodable {
  let id: String?
  //let updatedAt: Date?
  let username: String
  let name: String
  //let firstName: String?
  //let lastName: String?
  //let twitterUsername: String?
  var portfolio_url: String?//String?  //portfolioURL

  //let instagramUsername: String?
  //let totalCollections: Int?
  //let totalLikes: Int?
  //let totalPhotos: Int?
  //let acceptedTos: Bool?
  
  enum CodingKeys: String, CodingKey {
    case id
    case username, name
    //case updatedAt, firstName, lastName, twitterUsername
    case portfolio_url
    //case instagramUsername, totalCollections, totalLikes, totalPhotos, acceptedTos
  }
}


class UnsplashData: ObservableObject {
    @Published var photoArray: [Photo] = []
    //@Published var userArray: [User] = []
    //@Published var urlArray: [String] = []
    //@EnvironmentObject var prefs: Settings
 
    init() {
        //self.loadData(pose: tag, count: count)
    }
    
    func loadData(pose: String, count: Int, collection:
                  String) -> [Photo] {
        let key = "uAUynundHC-Xw2yOTLX5NgpNqJFNbj7LOFn3bav9sbc"
        let url = "https://api.unsplash.com/photos/random/?collections=\(String(describing: collection))&query=\(String(describing: pose))&count=\(count)&client_id=\(key)" //&query=\(tag)
       //https://api.unsplash.com/photos/random/?count=10&client_id=oIydIa6cVPfy8sN4ly4fwR6Srhh6zx4mqVsVBK-wbOc&query=hair
        
        let session = URLSession(configuration: .default)

            session.dataTask(with: URL(string: url)!) { (data, _, error) in
                guard let data = data else {
                    print("URLSession dataTask error", error ?? "nil")
                    return
                }
                do {
                    let json = try JSONDecoder().decode([Photo].self, from: data)
                    //let jsonUser = try JSONDecoder().decode([User].self, from: data)
                    //print(json)
                    for photo in json {
                        self.photoArray.append(photo)
                       // print("\n*** \(photo) *** \n")
                    }
                    
                    print("\n* JSON finished loading. * \n")
                } catch {
                    print("\n* error: \(error.localizedDescription)\n")
                    print("\n* detailed error: \(error)\n")
                }
            } .resume()
        
        return photoArray
    }
    
    func loadCollectionData(collectionID: Int, count: Int) -> [Photo] {
       // let key = "uAUynundHC-Xw2yOTLX5NgpNqJFNbj7LOFn3bav9sbc"
        let urlCollection = "https://api.unsplash.com/photos/random/?collections=162326&count=5&client_id=uAUynundHC-Xw2yOTLX5NgpNqJFNbj7LOFn3bav9sbc"
        
        
        
        let session = URLSession(configuration: .default)

            session.dataTask(with: URL(string: urlCollection)!) { (data, _, error) in
                guard let data = data else {
                    print("URLSession dataTask error", error ?? "nil")
                    return
                }
                do {
                    let json = try JSONDecoder().decode([Photo].self, from: data)
                    //let jsonUser = try JSONDecoder().decode([User].self, from: data)
                    //print(json)
                    for photo in json {
                        self.photoArray.append(photo)
                       // print("\n*** \(photo) *** \n")
                    }
                    print("\n* JSON finished loading. * \n")
                } catch {
                   
                    print("\n* error: \(error.localizedDescription)\n")
                    print("\n* detailed error: \(error)\n")
                }
            } .resume()
        
        return photoArray
    }
}



