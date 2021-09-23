//  Created by jo on 2020-10-14.

import Foundation
import SwiftUI

struct Photo: Identifiable, Decodable {
    var id: String
    var alt_description: String?
    var urls: [String : String]
    
    var urlToImage: String?
    var author: String?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case author, title, urlToImage, id, urls
    }
    
}

class UnsplashData: ObservableObject {
    @Published var photoArray: [Photo] = []
    
    var tag = Settings().sPose //"face"
    var count = Settings().sPoseCount

    init() {
        loadData(tag: tag, count: count) //
    }
 
    func loadData(tag: String, count: Int) { //tag: String
        let key = "oIydIa6cVPfy8sN4ly4fwR6Srhh6zx4mqVsVBK-wbOc"
        let url = "https://api.unsplash.com/photos/random/?count=\(count)&client_id=\(key)&query=\(tag)" //

        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, error) in
            guard let data = data else {
                print("URLSession dataTask error", error ?? "nil")
                return
            }
            do {
                let json = try JSONDecoder().decode([Photo].self, from: data)
                print(json)
                for photo in json {
                    DispatchQueue.main.async {
                        self.photoArray.append(photo)
                    }
                }
            } catch {
                print("error: ", error.localizedDescription)
                print("detailed error: ", error)
            }
        } .resume()
    }
    
    
}
