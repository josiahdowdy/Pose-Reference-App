/*
 Josiah - Oct 29, 2020
 Handles loading JSON data from Unsplash.
*/

import SwiftUI

struct Photo: Identifiable, Decodable {
    var id: String
    var alt_description: String?
    var urls: [String : String]
    //var author: String
}

class UnsplashData: ObservableObject {
    @Published var photoArray: [Photo] = []
    @Published var urlArray: [String] = []
    //@EnvironmentObject var prefs: Settings
 
    init() {
        //self.loadData(pose: tag, count: count)
    }
    
    func loadData(pose: String, count: Int) -> [Photo] {
        let key = "oIydIa6cVPfy8sN4ly4fwR6Srhh6zx4mqVsVBK-wbOc"
        let url = "https://api.unsplash.com/photos/random/?count=\(count)&client_id=\(key)&query=\(pose)" //&query=\(tag)

        let session = URLSession(configuration: .default)

            session.dataTask(with: URL(string: url)!) { (data, _, error) in
                guard let data = data else {
                    print("URLSession dataTask error", error ?? "nil")
                    return
                }
                do {
                    let json = try JSONDecoder().decode([Photo].self, from: data)
                    //print(json)
                    for photo in json {
                        self.photoArray.append(photo)
                        self.urlArray.append(photo.urls["regular"]!)
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




/* working old
 
URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) in
guard data != nil else {
return
}
do {
print("\n\n Running json data. \n---------\n")
let json = try JSONDecoder().decode([Photo].self, from: data!)
print(json)
for photo in json {
    DispatchQueue.main.async {
        self.photoArray.append(photo)
        counter += 1
        //print("\(counter) : \(self.photoArray.count) photos added")
    }
}
print("\n\n JSON finished. \n---------")
print("photoArray size: \(self.photoArray.count) \n")
} catch {
print("error: ", error.localizedDescription)
print("detailed error: ", error)
}
}) .resume()
*/


/*
 
 func loadData(pose: String, count: Int, completion: @escaping ([json]) -> Void) {  //tag: String, count: Int
     let key = "oIydIa6cVPfy8sN4ly4fwR6Srhh6zx4mqVsVBK-wbOc"
     let url = "https://api.unsplash.com/photos/random/?count=\(count)&client_id=\(key)&query=\(pose)" //&query=\(tag)
     //var counter = 0
     let session = URLSession(configuration: .default)

     DispatchQueue.global(qos: .background).async {
         session.dataTask(with: URL(string: url)!) { (data, _, error) in
             guard let data = data else {
                 print("URLSession dataTask error", error ?? "nil")
                 return
             }
             do {
                 let json = try JSONDecoder().decode([Photo].self, from: data)
                 print(json)
                 for photo in json {
                         self.photoArray.append(photo)
                         //print("added photo")
                         print("JSON: array size: \(self.photoArray.count)")
                 }
             } catch {
                 print("error: ", error.localizedDescription)
                 print("detailed error: ", error)
             }
         } .resume()
     
         DispatchQueue.main.async {
             completion(returnedData)
         }
     }
 }
 */
