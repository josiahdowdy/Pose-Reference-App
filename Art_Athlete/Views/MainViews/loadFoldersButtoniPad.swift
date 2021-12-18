//  Created by josiah on 2021-10-29.
import SwiftUI
import Files
import UniformTypeIdentifiers

struct LoadFoldersButtoniPad: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var prefs: GlobalVariables
    //@EnvironmentObject var homeData: HomeViewModel
    @EnvironmentObject var homeData: HomeViewModel

    @State var imagesArray: Array<UIImage> = Array<UIImage>()

    @Binding var needRefresh: Bool
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
        //  deleteFiles()
        do{
            let selectedFiles = try result.get()//let selectedFiles = try res.get()

            let folderNameArray = selectedFiles[0].pathComponents.suffix(2) //Get the folder and photo name.
            let filePathArray = Array(folderNameArray) //Convert it so you can just grab the folder name.
            let folderName = filePathArray[0]
         //   let folderA = getFolderPath(folderName: folderName)

            let dataPath = getPathForImage(name: folderName)
           // createNewFolder(dataPath: dataPath!.path)

            if !FileManager.default.fileExists(atPath: dataPath!.path) {
                createNewFolder(dataPath: dataPath!.path)
                homeData.folders.append(Product(title: folderName, count: selectedFiles.count))
                homeData.nameOfFolder = folderName
                homeData.numberOfPhotos = selectedFiles.count

                //homeData.foldersB.append(FoldersB(nameOfFolder: folderName, numberOfPhotos: selectedFiles.count))
            } else {
            //    homeData.folders.contains(where: <#T##(Product) throws -> Bool#>)
              //  homeData.folders.first(where: Product)
            }

            //homeData.folders.first(where: Product(type: .Poses, title: folderName, subtitle: "blank", count: 1) == true)

            
            for i in 0...(selectedFiles.count-1) {
                if selectedFiles[i].startAccessingSecurityScopedResource() {
                    print("JD451: Acess granted to startAccessingSecurityScopedResource. \(selectedFiles[i].path)")

                    let folderNameArray = selectedFiles[i].pathComponents.suffix(2) //Get the folder and photo name.
                    let filePathArray = Array(folderNameArray) //Convert it so you can just grab the folder name.
                    let folderName = filePathArray[0]
                    let fileName = filePathArray[1]
                    let folderPath = getFolderAndFilePath(folderName: folderName, fileName: fileName)

                    imagesArray.append(UIImage(contentsOfFile: selectedFiles[i].path)!) //UIImage(id: UUID().uuidString, url: selectedFiles[0])

                    guard
                        //MARK: Need to fix for png and other data types.
                        let data = imagesArray[i].jpegData(compressionQuality: 1.0)//,
                            //  let path = getPathForImage(name: folderName),
                    else {
                        print("JD451: error getting data.")
                        return
                    }

                    ///First check if file already exists in folder.
                    if !FileManager.default.fileExists(atPath: folderPath!.path) {
                        do {
                            try data.write(to: folderPath!) //path
                            print("JD451: Success saving!")
                        } catch let error {
                            print("JD451: Error saving. \(error)")
                        }
                    }
                   // let photoName = selectedFiles[i].lastPathComponent
                    // let targetFolderiPad = try Folder(path: Folder.documents!.path)

                }
                selectedFiles[i].stopAccessingSecurityScopedResource()
            }

            //Now look at the files and remove any duplicates.
            //let newFolder = try Folder(path: folderA!.path)
        } catch{
            print ("JD82: ", error.localizedDescription)
        }
        self.needRefresh = true

        scanAllFolders()
    } //end ImportImage func.

    public func scanAllFolders() {

        Folder.documents!.subfolders.recursive.forEach { folder in
            homeData.folders.append(Product(title: folder.name, count: folder.files.count()))
        }
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

    func getFolderPath(folderName: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(folderName)")
        else {
            print("error getting path.")
            return nil
        }

        return path
    }

    func getFolderAndFilePath(folderName: String, fileName: String) -> URL? {
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

    func deleteFiles() {
        // start with a file path, for example:
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        // fileUrl.path

        //            .deletingPathExtension()
        //            .appendingPathComponent(
        //                "someDir/customFile.txt",
        //                isDirectory: false
        //            )

        // check if file exists
        // fileUrl.path converts file path object to String by stripping out `file://`
        if FileManager.default.fileExists(atPath: fileUrl!.path) {
            // delete file
            do {
                try FileManager.default.removeItem(atPath: fileUrl!.path)
            } catch {
                print("Could not delete file, probably read-only filesystem")
            }
            print("JD451: files have been deleted.")
        }
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
