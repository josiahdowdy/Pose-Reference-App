//  Created by josiah on 2021-10-29.
import SwiftUI
import Files
import UniformTypeIdentifiers

struct LoadFoldersButton: View {
    @EnvironmentObject var prefs: GlobalVariables
    @ObservedObject var userSettings = StoredUserData()
    @State var isImporting: Bool = false
    
    @Environment(\.managedObjectContext) var context
    
    
    //  var folderData : FetchedResults<PhotoFolders>

    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors: []
    ) var folderData : FetchedResults<PhotoFolders>

    @FetchRequest(entity: PhotosArray.entity(), sortDescriptors: []
    ) var photosArray : FetchedResults<PhotosArray>
    //---------------END VARIABLES------------------------------------------------




    //-----------------START VIEW-------------------------------------------------
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: {
                isImporting = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isImporting = true
                }
            }, label: {
                Image(systemName: "folder.badge.plus")
            })
            //  if (prefs.localPhotosView) { }
        }
        //   .fileImporter(isPresented: <#T##Binding<Bool>#>, allowedContentTypes: <#T##[UTType]#>, onCompletion: <#T##(Result<URL, Error>) -> Void##(Result<URL, Error>) -> Void##(_ result: Result<URL, Error>) -> Void#>)
        .fileImporter(
            isPresented: $isImporting, allowedContentTypes: [UTType.folder], //, UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
            allowsMultipleSelection: false,
            onCompletion: { result in
                do {
                    guard let selectedFolder: URL = try result.get().first else { return }

                    userSettings.storedFolderURL = selectedFolder

                    userSettings.arrayOfFolderURLs.append(selectedFolder.path)
                  //  userSettings.workingDirectoryBookmark = selectedFolder

                    //Store photo urls in array.
                    var arrayFiles = [String]()
                    for i in try Folder(path: selectedFolder.path).files {
                        arrayFiles.append(i.path) //Save the photo urls into the array.
                    }



                    for file in try Folder(path: selectedFolder.path).files {
                        //userSettings.arrayPhotoURLs = [file]
                        userSettings.arrayOfFolderNames.append(file.name)
                        userSettings.arrayOfFolderURLs.append(file.path)
                    }

                    /*
                    let folderName: String = selectedFolder.lastPathComponent

                    let newFolder = PhotoFolders(context: context)
                    newFolder.id = UUID()
                    newFolder.folderURL = selectedFolder //Save the folder URL.
                    newFolder.folderName = folderName
                    newFolder.tag = "Human Poses"
*/





                  //  newFolder.photosArray?.addingObjects(from: arrayFiles)

                    /**************ªªª¡¡¡¡¡¡¡¡¡£ºª––≠≠≠≠≠≠≠≠≠≠≠––––––––––≠≠≠–––––––––––––––––––––––––––––––––––––––‘“∏ØˆØˆØˆØˆ
                    //HI JOSIAH
                    I have the folders working, only with the images that have shown..
                     What was my idea last night?
                    - [ ] Store the photo URL's in an array in the bookmark.
                    - [ ]
                    */

                    /*
                    print("JD11: \(selectedFolder.lastPathComponent)")

                   // let newFolder = PhotoFolders(context: context)
                    let newPhoto = PhotosArray(context: context)

                    for file in try Folder(path: selectedFolder.path).files {
                        print(file.name)

                        print("JD15:", file.path)
                        
                      //  let data = file.jpegData(compressionQuality: 1.0)

                        let imageData = try? file.read()

                        //newPhoto.photosArrayJosiah.append(contentsOf: imageData)

                        newPhoto.id = UUID()
                        newPhoto.photo = imageData
                        newPhoto.photoURL = URL(string: file.path)
                        newPhoto.photoURLString = file.path
                        newPhoto.fileName = file.name
                        //newPhoto2.photoFolders. = selectedFolder.lastPathComponent
                        newPhoto.photoFolders?.folderName = selectedFolder.lastPathComponent

                        newFolder.photosArray?.addingObjects(from: [newPhoto])

                       // prefs.arrayOfObjects

                        print("JD13: \(newPhoto)")

                    }

                    print("JD14: \(newFolder)")


                    try? self.context.save()

//                    if let imageData = selectedFolder.image?.pngData() {
//                        DataBaseHelper.shareInstance.saveImage(data: imageData)
//                    }





//                    if let photosArray = newPhoto.photosArray {
//                        newPhoto.photosArray = photosArray.addingObjects(from: file.name) as NSSet
//                    }


                    /*¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
                     STORE THE PHOTO URL TO THE DATABASE.
                     i am not saving the photo, but the link to it, so I have permission in the future.
                     ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡*/


//                    for file in try Folder(path: selectedFolder.path).files {
//                        if let photosArray = newPhoto.photosArray {
//                            newPhoto.photosArray = photosArray.addingObjects(from: self.files)
//                        }
//
//                    }

                    /*
                     if let categoriesToSAve = newQuestion.categories {                             newQuestion.categories = categoriesToSAve.addingObjects(from: self.selections) as NSSet
                     }
                     else {
                        newQuestion.categories = Set(self.selections) as NSSet
                     }
                     */


                    //••••••••••••••••••••••••••••••••••••••••••••••••••
                    //Now save the URLs of the files in the folder.
                 //   guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                    //   let arrayURLs : [String]//= selectedFolder.path

//                    selectedFolder.appendPathComponent("/")
//                    print("josiah selectedFolder", selectedFolder.appendingPathComponent("/")) //selectedFolder.path)
//                    print("Josiah documentsDirectory", documentsDirectory)

*/

                } catch { print("failed") }
            })
        // .toolbar { Menu("Action") {  } }


        /*
         VStack {

         List {
         ForEach(folderData, id: \.self) { folderData in
         Section(header: Text(folderData.wrappedFolderName)) {
         ForEach(folderData.photosArrayJosiah, id: \.self) { photoURL in
         Text(photoURL.wrappedName)
         }
         }
         }
         }

         Button("Add Custom Data") {
         let file1 = PhotosArray(context: self.context)
         file1.fileName = "donkey"
         file1.photoFolders = PhotoFolders(context: self.context)
         file1.photoFolders?.folderName = "Animals"
         file1.photoFolders?.tag = "animals"

         let file2 = PhotosArray(context: self.context)
         file2.fileName = "squirrel"
         file2.photoFolders = PhotoFolders(context: self.context)
         file2.photoFolders?.folderName = "Animals"
         file2.photoFolders?.tag = "animals"


         let file3 = PhotosArray(context: self.context)
         file3.fileName = "guys nude"
         file3.photoFolders = PhotoFolders(context: self.context)
         file3.photoFolders?.folderName = "Human Poses"
         file3.photoFolders?.tag = "animals"

         let file4 = PhotosArray(context: self.context)
         file4.fileName = "dinosaur"
         file4.photoFolders = PhotoFolders(context: self.context)
         file4.photoFolders?.folderName = "Animals"

         try? self.context.save()
         }
         } //End VStack for Folders.
         */
    } //------------------------END VIEW------------------------------------------------------------------
    
    
    //----------------------START FUNCTIONS----------------------------------------------------------------------------------------
    func saveFolder (url: URL) {
        
    }
    
    func saveFile (url: URL) {
        var actualPath: URL
        
        if (CFURLStartAccessingSecurityScopedResource(url as CFURL)) { // <- here
            
            let fileData = try? Data.init(contentsOf: url)
            let fileName = url.lastPathComponent
            
            actualPath = getDocumentsDirectory().appendingPathComponent(fileName)
            
            // print("\nactualPath = \(actualPath)\n") //Prints out the actual path.
            do {
                try fileData?.write(to: actualPath)
                prefs.arrayOfURLStrings.append(String(describing: actualPath))

                if(fileData == nil){
                    print("Permission error!")
                }
                else {
                    //print("Success.")
                }
            } catch {
                print(error.localizedDescription)
            }
            CFURLStopAccessingSecurityScopedResource(url as CFURL) // <- and here
            
        }
        else {
            print("Permission error!")
        }
        
        func getDocumentsDirectory() -> URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        
    }
    //----------------------END FUNCTIONS------------------------------------------
}



//
//        Button(action: {
//            print("button")
//            for file in try Folder(path: "/downloads").files {
//                print(file.name)
//            }
//           // let folder = try Folder(path: "/users/josiahdowdy/folder")
//            //let file = try folder.createFile(named: "file.json")
//           // try file.write("{\"hello\": \"world\"}")
//          //  try file.delete()
//          //  try folder.delete()
//        }) {
//            Image(systemName: "folder.badge.plus")
//        } //.keyboardShortcut(.downArrow)
//

//        for file in try Folder(path: "MyFolder").files {
//            print(file.name)
//        }


/*
 struct LoadFoldersView_Previews: PreviewProvider {
 static var previews: some View {
 LoadFoldersView()
 }
 }
 */



    /*
     .fileImporter(
     //isPresented: $isImporting, allowedContentTypes: [UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
     isPresented: $isImporting, allowedContentTypes: [UTType.folder], //, UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
     allowsMultipleSelection: false, //set to true to select multiple folders. But then I need to put them in an array.
     onCompletion: { result in
     do {
     //What to do with the File import. - I just want to save the folder name and location.
     guard var selectedFolder: URL = try result.get().first else { return }
     //guard let filesInFolder: [URL]? = try result.get() else { return }

     //••••••••••TEST••••••••••••••••••••••••••••••••••••••••
     //                    guard let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else { return }
     //                    if let pathURL = URL.init(string: path) {
     //                        let dataURL = pathURL.appendingPathComponent("JosiahsFolder")
     //                        print("JP2, \(dataURL)")
     //                        //dataURL creates a folder in this directory:
     //                        /// /Users/josiahdowdy/Library/Containers/josiahdowdy.artathlete/Data/Documents/JosiahsFolder
     //                        do {
     //                            try FileManager.default.createDirectory(atPath: dataURL.absoluteString, withIntermediateDirectories: true, attributes: nil)
     //
     //                            let originFolder = dataURL
     //                            let targetFolder = dataURL
     //                            try originFolder.files.move(to: targetFolder)
     //                        } catch let error as NSError {
     //                            print(error.localizedDescription);
     //
     //                        }
     //                    }
     //                    else {
     //                        print("Error in URL path");
     //                    }
     //•••TEST 2•••••••••••••••••••••••••••••••••••••••••••••••
     //•••Works to create a folder in the container of the app. •••
     /*
      let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
      let documentsDirectory = paths[0]
      let docURL = URL(string: documentsDirectory)!
      let dataPath = docURL.appendingPathComponent("HarryJosiah")
      if !FileManager.default.fileExists(atPath: dataPath.path) {
      do {
      try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
      } catch {
      print(error.localizedDescription)
      }
      } */


     for file in try Folder(path: selectedFolder.path).files {
     print(file.name)
     }

     /*
      let originFolder = try Folder(path: selectedFolder.path)

      //iCloud Folder for app.
      let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")

      let targetFolder = try Folder(path: driveURL!.path)

      do {
      try originFolder.copy(to: targetFolder)
      print("JD01: \(targetFolder)")

      } catch {
      print(error.localizedDescription)
      }
      */



     //
     //                    let targetFolder = try Folder(path: dataPath.path)
     //                  try originFolder.files.move(to: targetFolder)

     // ••• Copies files to another folder. •••
     //                    do {
     //                        try originFolder.copy(to: originFolder)
     //
     //                    } catch {
     //                        print(error.localizedDescription)
     //                    }

     let downloadsFolder = Folder.documents

     print("BUG03: \(String(describing: downloadsFolder))")
     //••••••••••••••••••••••••••••••••••••••••••••••••••
     //Now save the URLs of the files in the folder.
     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
     //   let arrayURLs : [String]//= selectedFolder.path

     selectedFolder.appendPathComponent("/")
     print("josiah selectedFolder", selectedFolder.appendingPathComponent("/")) //selectedFolder.path)
     print("Josiah documentsDirectory", documentsDirectory)

     let newFolder = PhotoFolders(context: context)
     newFolder.folderURL = selectedFolder //Save the folder URL.
     print("Josiah Fart Photos: \(newFolder.photosArrayJosiah)")
     newFolder.id = UUID()

     let folderName: String = selectedFolder.lastPathComponent

     newFolder.folderName = folderName//newFolder.folderURL(newFolder.folderURL as NSString).lastPathComponent

     //print("josiah: \(newFolder.folderName)")

     // *IMPORTANT* : Make sure I move this to be done on Start of session.
     // ...for when user updates the folder contents!
     //let contentsInFolder = PhotosArray(context: context)


     //   newFolder.PhotoFolders.

     // contentsInFolder.photoFolders?.folderURL =

     //
     // contentsInFolder.photosString = selectedFolder.pathComponents //Save the contents in folderURLs into array.


     //print("\n newFolder.folderURL: \(newFolder.folderURL) \n")

     /* let selectedFiles = try result.get()
      prefs.sPoseCount = selectedFiles.count

      for i in 0...(selectedFiles.count-1) { //selectedFiles.count
      //print("\n\(i)") //This prints out the photo data
      saveFile(url: selectedFiles[i])
      } */
     // self.error = ""
     } catch { print("failed") }
     })
     */
