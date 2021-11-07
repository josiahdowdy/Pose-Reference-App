//  Created by josiah on 2021-10-29.
import SwiftUI
//import Files
import UniformTypeIdentifiers

struct LoadFoldersButton: View {
    @EnvironmentObject var prefs: GlobalVariables
    @State var isImporting: Bool = false
    
    @Environment(\.managedObjectContext) var context
    
    
  //  var folderData : FetchedResults<PhotoFolders>

    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors: []
    ) var folderData : FetchedResults<PhotoFolders>

    
//    @FetchRequest(
//        entity: PhotoFolders.entity(), sortDescriptors: []
//    ) var photoData : FetchedResults<PhotoFolders>

    //---------------END VARIABLES--------------------------------------------------------
////\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
    //############################################################################
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
            //isPresented: $isImporting, allowedContentTypes: [UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
            isPresented: $isImporting, allowedContentTypes: [UTType.folder],
            allowsMultipleSelection: false, //set to true to select multiple folders. But then I need to put them in an array.
            onCompletion: { result in
                do {
                    //What to do with the File import. - I just want to save the folder name and location.
                    guard let selectedFolder: URL = try result.get().first else { return }
                    //arrayOfPhotos = selectedFolder.pathComponents
                    let newFolder = PhotoFolders(context: context)
                    newFolder.folderURL = selectedFolder //Save the folder URL.
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
                //print("\nString: arrayOfURLStrings: \n\(prefs.arrayOfURLStrings)\n")
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
