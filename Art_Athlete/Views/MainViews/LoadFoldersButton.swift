//  Created by josiah on 2021-10-29.
import SwiftUI
import Files
import UniformTypeIdentifiers



struct LoadFoldersButton: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var prefs: GlobalVariables
    @ObservedObject var folderArrayModel: FoldersArrayModel

 //   @AppStorage("arrayOfFolderNames") var arrayOfFolderNames: [String] = []
 //   @AppStorage("storedFileURLs") var storedFileURLs: [[URL]] = [[]]
//    @AppStorage("fileName") var fileName: [[String]] = [[]]

    @State var isImporting: Bool = false
    @Binding var totalPhotosLoaded: Int
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
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [UTType.folder], allowsMultipleSelection: true, onCompletion: importImage)
        //UTType.folder, //UTType.png, UTType.image, UTType.jpeg, UTType.pdf, UTType.tiff
    } //------------------------END VIEW---------------------------

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: - FUNCTIONS
    func importImage(_ result: Result<[URL], Error>) {
        //isloadingPhotos = true
        do{
            let selectedFiles = try result.get()//let selectedFiles = try res.get()

            for i in 0...(selectedFiles.count-1) {
                print("JD451: LOADFOLDERSBUTTON --> ", Folder.documents!)
                print("JD451: LOADFOLDERSBUTTON --> ", Folder.home)
                print("JD451: LOADFOLDERSBUTTON --> ", Folder.current)
                print("JD451: LOADFOLDERSBUTTON --> ", Folder.root)
               // let folder = try Folder(path: Folder.home)


                let originFolder = try Folder(path: selectedFiles[i].path)
                let targetFolder = try Folder(path: Folder.documents!.path)
                try originFolder.copy(to: targetFolder)
            }
            try? self.context.save()

        } catch{
            print ("JD82: ", error.localizedDescription)
        }
     //   isloadingPhotos = false
        //HomeScreenButtonsView().scanAllFolders()
        scanAllFolders()
    }

    public func scanAllFolders() {
        folderArrayModel.folderArray.removeAll()
        if (UIDevice.current.userInterfaceIdiom == .mac) {
            print("JD451: mac")
            Folder.documents!.subfolders.recursive.forEach { folder in
                let newFolder = FoldersModel(name: folder.name)
                folderArrayModel.folderArray.append(newFolder)
                //MARK: Different on mac --> folder.files vs Folder.documents!.files
            }
        }

        //MARK: important --> when running "My Mac (designed for ipad)", this if statement is used.
        if !(UIDevice.current.userInterfaceIdiom == .mac) {
            Folder.documents!.subfolders.recursive.forEach { folder in
                let newFolder = FoldersModel(name: folder.name)
                folderArrayModel.folderArray.append(newFolder)
            }
        }
    } //End func.

    func saveFile (url: URL) {
        var actualPath: URL

        if (CFURLStartAccessingSecurityScopedResource(url as CFURL)) { // <- here
            print("JD111: Access granted. \(url)")
            //BOOKMARK IT!
            // prefs.arrayOfURLStringsTEMP.append(url)
            //FIXME: - THIS Works, one photo at a time. -->
            //saveBookmarkData(for: url)


            let fileData = try? Data.init(contentsOf: url)
            let fileName = url.lastPathComponent

            actualPath = getDocumentsDirectory().appendingPathComponent(fileName)

            do {
                try fileData?.write(to: actualPath)
                //prefs.arrayOfURLStrings.append(String(describing: actualPath))


                if(fileData == nil){
                    print("Permission error!")
                }
                else {
                    //print("Success.")
                }
            } catch {
                print("Josiah1: \(error.localizedDescription)")
            }
            CFURLStopAccessingSecurityScopedResource(url as CFURL) // <- and here
        }
        else {
            print("Permission error!")
        }

        print("JD105: \(prefs.arrayOfURLStrings)")

        func getDocumentsDirectory() -> URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    } //End of FUNC.

/*    private func saveBookmarkData(for workDir: URL) { //URL //for workDir: URL //[URL: Data]
        // resourceValues(forKeys:fromBookmarkData:)
    //    let myKey = URLResourceKey.init(rawValue: "test") //

        do {
            let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: nil, relativeTo: workDir) //(options: .minimalBookmark)
//            guard workDir.startAccessingSecurityScopedResource() else { return }
//                print("JD110: Access granted.")

            storedUserData.arrayWorkingDirectoryBookmark.append(bookmarkData)
            workDir.stopAccessingSecurityScopedResource()
          //  print("JD103: Saved bookmark data.\(storedUserData.arrayWorkingDirectoryBookmark)")
           // print("JD22: storedUserData.arrayWorkingDirectoryBookmark \(storedUserData.arrayWorkingDirectoryBookmark)")
        } catch {
            print("JD102: Failed to save bookmark data for \(workDir)", error)
        }
    } */

} //END STRUCT

//MARK: - extensions.
extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()

        for value in self {
            if !result.contains(value) {
                result.append(value)

            }
        }
        self = result
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}



/*
 BACKUP: ----->
 func importImage(_ result: Result<[URL], Error>) {
 isloadingPhotos = true
 do{
 //storedUserData.arrayWorkingDirectoryBookmark.removeAll() //MARK: - TURN OFF to keep all files.
 //    prefs.arrayOfURLStringsTEMP.removeAll()

 let selectedFiles = try result.get()//let selectedFiles = try res.get()
 //print("JD40: ", selectedFiles)

 //    prefs.totalFilesSelected = selectedFiles.count

 //            let folderName = Array(selectedFiles[0].pathComponents.suffix(2))
 //            //arrayOfFolderNames.append(folderName[0])
 //            prefs.arrayOfFolderNames.append(folderName[0])
 //            prefs.arrayOfFolderNames.removeDuplicates()
 //
 //            //TODO: Duplicates in Array.
 //            if (prefs.doesFolderAlreadyExist) {
 //                arrayOfFolderNames.removeDuplicates()
 //              //  storedFileURLs.remove(at: <#T##Int#>)
 //            }

 var newRowIn2DArray = [URL]()


 // let folderName = selectedFiles[0].lastPathComponent
 //   let newURL = Folder.home.path.appending(selectedFiles[0].lastPathComponent)
 //   let newFolder = try Folder(path: newURL)
 // let file = try newFolder.createFile(named: "file.json")

 if (UIDevice.current.userInterfaceIdiom == .mac) {
 let originFolder = try Folder(path: selectedFiles[0].path)
 let targetFolder = try Folder(path: Folder.documents!.path)
 try originFolder.copy(to: targetFolder)
 }

 if !(UIDevice.current.userInterfaceIdiom == .mac) {
 let originFolder = try Folder(path: selectedFiles[0].path)
 let targetFolder = try Folder(path: Folder.documents!.path)
 try originFolder.copy(to: targetFolder)

 //                for file in Folder.documents!.files {
 //                    prefs.arrayOfURLStrings.append(file.url.absoluteString)
 //                }
 }

 //            for file in try Folder(path: selectedFiles[0].path).files {
 //                print("JD460: ", file.name)
 //                try file.copy(to: Folder.documents!)
 //            }

 for i in 0...(selectedFiles.count-1) {
 newRowIn2DArray.append(selectedFiles[i])

 //                let newPhoto = PhotosEntity(context: context)//PhotosArray(context: context)
 //                newPhoto.id = UUID()
 //                newPhoto.fileName = selectedFiles[i].lastPathComponent
 //                newPhoto.photoURL = selectedFiles[i]
 //                newPhoto.folderRel = FoldersEntity(context: self.context)
 //
 //                let getFolderName = Array(selectedFiles[0].pathComponents.suffix(2))
 //                newPhoto.folderRel?.folderName = getFolderName[0]
 //                newPhoto.folderRel?.folderURL = selectedFiles[i].deletingLastPathComponent()

 prefs.arrayOfURLStringsTEMP.append(selectedFiles[i])
 updateLoadingCount()
 saveFile(url: selectedFiles[i])
 }

 storedFileURLs.append(newRowIn2DArray) //Adds a new Row.
 newRowIn2DArray.removeAll()

 print("JD301: \(storedFileURLs)")

 //      storedUserData.arrayWorkingDirectoryBookmark.removeDuplicates()
 //    print("JD140: bookmarkcount: \(storedUserData.arrayWorkingDirectoryBookmark.count)")

 try? self.context.save()

 } catch{
 print ("JD82: ", error.localizedDescription)
 }
 isloadingPhotos = false
 }
 */
