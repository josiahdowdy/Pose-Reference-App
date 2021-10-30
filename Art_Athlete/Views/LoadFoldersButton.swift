//  Created by josiah on 2021-10-29.
import SwiftUI
//import Files
import UniformTypeIdentifiers

struct LoadFoldersButton: View {
    @EnvironmentObject var prefs: GlobalVariables
    @State var isImporting: Bool = false
    
    @Environment(\.managedObjectContext) var context
    
//    @FetchRequest(
//        entity: PhotoFolders.entity(), sortDescriptors: []
//    ) var photoData : FetchedResults<PhotoFolders>

    var body: some View {
        
        VStack(alignment: .trailing) {
            if (prefs.localPhotosView) {
                Button(action: {
                    isImporting = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isImporting = true
                    }
                }, label: {
                    Image(systemName: "folder.badge.plus")
                    Text("Add Folder")
                        .font(.system(size: 100))
                    //                        .padding(6)
                    //                        .background(Color.blue)
                    //                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
            }
        }
        
        
        VStack(alignment: .center) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 30))
            
            
        }
        .fileImporter(
            //isPresented: $isImporting, allowedContentTypes: [UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
            isPresented: $isImporting, allowedContentTypes: [UTType.folder],
            allowsMultipleSelection: false, //set to true to select multiple folders. But then I need to put them in an array.
            onCompletion: { result in
                do {
                    //What to do with the File import. - I just want to save the folder name and location.
                    guard let selectedFolder: URL = try result.get().first else { return }
                    let newFolder = PhotoFolders(context: context)
                    newFolder.folderURL = selectedFolder
                    print("\n newFolder.folderURL: \(newFolder.folderURL) \n")
                    
                    /* let selectedFiles = try result.get()
                    prefs.sPoseCount = selectedFiles.count
                    
                    for i in 0...(selectedFiles.count-1) { //selectedFiles.count
                        //print("\n\(i)") //This prints out the photo data
                        saveFile(url: selectedFiles[i])
                    } */
                   // self.error = ""
                } catch { print("failed") }
            })
        .toolbar {
            Menu("Action") {
            }
        }
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
