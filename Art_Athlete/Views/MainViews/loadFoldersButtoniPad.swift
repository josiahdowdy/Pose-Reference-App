//  Created by josiah on 2021-10-29.
import SwiftUI
import Files
import UniformTypeIdentifiers

struct LoadFoldersButtoniPad: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var homeData: HomeViewModel

    @State var imagesArray: Array<UIImage> = Array<UIImage>()

    @State var isImporting: Bool = false
    @Binding var isloadingPhotos: Bool
    //MARK: END VARIABLES

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._*/
    //MARK: VIEW
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: {
                //prefs.showLoadingAnimation = true
                isImporting = false
                if #available(iOS 15.0, *) {
                    Task {
                        isImporting = true
                    }
                } else {
                    // Fallback on earlier versions
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isImporting = true
                    }
                }
            }, label: {
                Image(systemName: "folder.badge.plus")
            })
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [UTType.png, UTType.image, UTType.jpeg, UTType.pdf,  UTType.tiff],
            allowsMultipleSelection: true,
            onCompletion: importImage)
    } //------------------------END VIEW---------------------------

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: - FUNCTIONS
    func importImage(_ result: Result<[URL], Error>) {
            print("JD451: iPad")
            do{
                let selectedFiles = try result.get()//let selectedFiles = try res.get()

                let folderNameArray = selectedFiles[0].pathComponents.suffix(2) //Get the folder and photo name.
                let filePathArray = Array(folderNameArray) //Convert it so you can just grab the folder name.
                let folderName = filePathArray[0]
                let firstFileSelected = filePathArray[1]

               //let originFolder = selectedFiles[0].downloadURL.deletingLastPathComponent()
                let dataPath = getPathForImage(name: folderName)
                createNewFolder(dataPath: dataPath!.path)

                if selectedFiles[0].startAccessingSecurityScopedResource() {
                    print("JD451: Acess granted to startAccessingSecurityScopedResource. \(selectedFiles[0].path)")

                    imagesArray.append(UIImage(contentsOfFile: selectedFiles[0].path)!) //UIImage(id: UUID().uuidString, url: selectedFiles[0])

                    guard
                        let data = imagesArray[0].jpegData(compressionQuality: 1.0),
                        let path = getPathForImage(name: folderName),
                        let folderPath = getFolderPath(folderName: folderName, fileName: firstFileSelected)
                    else {
                            print("JD451: error getting data.")
                            return
                        }

                    do {
                        try data.write(to: folderPath) //path
                        print("JD451: Success saving!")
                    } catch let error {
                        print("JD451: Error saving. \(error)")
                    }
                }
                selectedFiles[0].stopAccessingSecurityScopedResource()
                print("JD451: imagesArray --> \(imagesArray.debugDescription)")
                //print("JD451: path --> \(path)")


               // let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                //print("JD451: directory \(directory)")

                for i in 0...(selectedFiles.count-1) {
                    let photoName = selectedFiles[i].lastPathComponent
                   // let targetFolderiPad = try Folder(path: Folder.documents!.path)
                    homeData.folders.append(Product(type: .Poses, title: photoName, subtitle: folderName, count: selectedFiles.count))
                }
            } catch{
                print ("JD82: ", error.localizedDescription)
            }
        print("JD451: homeData.folders \(homeData.folders)")
    }

    func getImage(name: String) -> UIImage? {
        //Minute 26:00
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
                print("JD451: error getting path")
                return nil
            }

        return UIImage(contentsOfFile: path)
    }

    func getPathForImage(name: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(name)") else {   //.jpg
            print("error getting path.")
            return nil
        }

        return path
    }

    func getFolderPath(folderName: String, fileName: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(folderName)/\(fileName)")
            else {
                    print("error getting path.")
                    return nil
                }

        return path
    }

    func createNewFolder(dataPath: String) {
        if !FileManager.default.fileExists(atPath: dataPath) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
} //END STRUCT
