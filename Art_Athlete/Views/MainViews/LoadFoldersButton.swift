//  Created by josiah on 2021-10-29.
import SwiftUI
import Files
import UniformTypeIdentifiers



struct LoadFoldersButton: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var storedUserData: StoredUserData //= StoredUserData()   //@AppStorage
    @AppStorage("arrayOfFolderNames") var arrayOfFolderNames: [String] = []

    @AppStorage("storedFileURLs") var storedFileURLs: [[URL]] = [[]]
    @AppStorage("fileName") var fileName: [[String]] = [[]]

   // @ObservedObject var dataProvider = DataProvider.shared
    //@AppStorage(storedUserData.arrayOfFolderNames)

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
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [UTType.png, UTType.image, UTType.jpeg, UTType.pdf, UTType.tiff], allowsMultipleSelection: true, onCompletion: importImage)
        //UTType.folder,
    } //------------------------END VIEW---------------------------

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: - FUNCTIONS
    func importImage(_ result: Result<[URL], Error>) {
        isloadingPhotos = true
        do{
           //storedUserData.arrayWorkingDirectoryBookmark.removeAll() //MARK: - TURN OFF to keep all files.
            prefs.arrayOfURLStringsTEMP.removeAll()

            let selectedFiles = try result.get()//let selectedFiles = try res.get()
            //print("JD40: ", selectedFiles)

            prefs.totalFilesSelected = selectedFiles.count

            let folderName = Array(selectedFiles[0].pathComponents.suffix(2))
            arrayOfFolderNames.append(folderName[0])

            //TODO: Duplicates in Array.
            if (prefs.doesFolderAlreadyExist) {
                arrayOfFolderNames.removeDuplicates()
              //  storedFileURLs.remove(at: <#T##Int#>)
            }

            print("JD300: ", arrayOfFolderNames.count, " - ", arrayOfFolderNames)

      //      newFolder.addToPhotosArray(selectedFiles)
            var newRowIn2DArray = [URL]()

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
               // saveBookmarkTest(item: selectedFiles[i])
                //storedUserData.photoArray.append(selectedFiles[i].dataRepresentation)
            }

            storedFileURLs.append(newRowIn2DArray) //Adds a new Row.
            newRowIn2DArray.removeAll()

            print("JD301: \(storedFileURLs)")

            //Also save the folder itself. Not sure if needed?
           // saveFile(url: newPhoto.photoFolders?.folderURL)

            storedUserData.arrayWorkingDirectoryBookmark.removeDuplicates()
            print("JD140: bookmarkcount: \(storedUserData.arrayWorkingDirectoryBookmark.count)")

            try? self.context.save()

//            do {
//                try? self.context.save()  //try?
//            } catch {
//                print ("JD150: ", error.localizedDescription)
//            }


           // print("JD11: \(prefs.arrayOfURLStrings)")
            //print("JD41: storedUserData.photoArray \(storedUserData.photoArray.description)")
          //  print("JD42: newFolder.photo \(String(describing: newFolder.photo?.description))")

          //  selectedFiles.stopAccessingSecurityScopedResource()
        } catch{
            print ("JD82: ", error.localizedDescription)
        }
        isloadingPhotos = false
    }


    func saveFile (url: URL) {
        var actualPath: URL

        if (CFURLStartAccessingSecurityScopedResource(url as CFURL)) { // <- here
            print("JD111: Access granted. \(url)")
            //BOOKMARK IT!
            // prefs.arrayOfURLStringsTEMP.append(url)
            //FIXME: - THIS Works, one photo at a time. -->
            saveBookmarkData(for: url)


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

    private func saveBookmarkData(for workDir: URL) { //URL //for workDir: URL //[URL: Data]
        // resourceValues(forKeys:fromBookmarkData:)
    //    let myKey = URLResourceKey.init(rawValue: "test") //

        do {
            let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: nil, relativeTo: workDir) //(options: .minimalBookmark)
//            guard workDir.startAccessingSecurityScopedResource() else { return }
//                print("JD110: Access granted.")

                storedUserData.arrayWorkingDirectoryBookmark.append(bookmarkData)
            workDir.stopAccessingSecurityScopedResource()
            print("JD103: Saved bookmark data.\(storedUserData.arrayWorkingDirectoryBookmark)")
           // print("JD22: storedUserData.arrayWorkingDirectoryBookmark \(storedUserData.arrayWorkingDirectoryBookmark)")
        } catch {
            print("JD102: Failed to save bookmark data for \(workDir)", error)
        }
    }

 /*   func saveBookmarkTest(item: Data) { //ShortcutItem
        guard let url = item.absoluteURL else { return  } //item.fileUrl
        do {
            let bookmarkData = try url.bookmarkData(
                //options: .withSecurityScope,
                includingResourceValuesForKeys: nil,
                relativeTo: item.absoluteURL
            )


            item.bookmark = bookmarkData
        } catch {
            print("Failed to save bookmark data for \(url)", error)
        }
    } */

    func updateLoadingCount() {
        self.totalPhotosLoaded += 1

        /*
         if #available(iOS 15.0, *) {
         Task {
         self.totalPhotosLoaded += 1
         }
         } else {
         // Fallback on earlier versions
         DispatchQueue.main.async {
         self.totalPhotosLoaded += 1
         }
         } */
    }



    //FIXME: - Not used right now.
    func saveFileArray (url: [URL]) {
        //var actualPath: [URL]

       // if (CFURLStartAccessingSecurityScopedResource([url] as CFURL)) { // <- here
            //BOOKMARK IT!
            // prefs.arrayOfURLStringsTEMP.append(url)
           // saveBookmarkDataArray(for: actualPath)

         //   let fileData = try? Data.init(contentsOf: actualPath[0])
          //  let fileName = url.lastPathComponent

          //  actualPath = getDocumentsDirectory().appendingPathComponent(fileName)

//            do {
//              //  try fileData?.write(to: actualPath)
//                prefs.arrayOfURLStrings.append(String(describing: actualPath))
//
//                if(fileData == nil){
//                    print("Permission error!")
//                }
//                else {
//                    //print("Success.")
//                }
//            } catch {
//                print("Josiah1: \(error.localizedDescription)")
//            }
//            CFURLStopAccessingSecurityScopedResource(url as CFURL) // <- and here
//        }
//        else {
//            print("Permission error!")
//        }

        func getDocumentsDirectory() -> URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    } //End of FUNC.

    private func saveBookmarkDataArray(for workDir: [URL]) { //URL //for workDir: URL //[URL: Data]
        // resourceValues(forKeys:fromBookmarkData:)
        do {
          //  let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: workDir)
            //, relativeTo: nil

            // save in UserDefaults
            //storedUserData.workingDirectoryBookmark = bookmarkData

            //let testPoo = try workDir.bookm

         //   storedUserData.savedFileURLs.bookmarkData(includingResourceValuesForKeys: workDir)

          //  storedUserData.arrayWorkingDirectoryBookmark.append(bookmarkData)
            print("JD103: Saved bookmark data.")
            // print("JD22: storedUserData.arrayWorkingDirectoryBookmark \(storedUserData.arrayWorkingDirectoryBookmark)")
        }// catch { print("JD102: Failed to save bookmark data for \(workDir)", error) }
    }
}


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
