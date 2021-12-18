//  Created by josiah on 2021-10-29.
import SwiftUI
import Files
import UniformTypeIdentifiers



struct LoadFoldersButton: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var homeData: HomeViewModel

    

    @State var isImporting: Bool = false
    @Binding var isloadingPhotos: Bool

    //let scanAllFoldersB: () -> () //Passed in function.

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
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            print("JD451: iPad")
            do{
                let selectedFiles = try result.get()//let selectedFiles = try res.get()

                for i in 0...(selectedFiles.count-1) {
                    let originFolder = try Folder(path: selectedFiles[i].path)
                    let targetFolder = try Folder(path: Folder.documents!.path)

                    try originFolder.copy(to: targetFolder)

                    homeData.folders.append(Product(title: originFolder.name, count: originFolder.files.count()))
                }
                // try? self.context.save()
            } catch{
                print ("JD82: ", error.localizedDescription)
            }
        }
        // scanAllFoldersB()
        // scanNewFolders(selectedFiles: URL)
    }

    //Func
    public func scanNewFolders(url: URL) {
        //homeData.folders.removeAll()
        if (UIDevice.current.userInterfaceIdiom == .mac) {
            print("JD451: mac")
            var i = 0 //numberInLine: i,
            Folder.documents!.subfolders.recursive.forEach { folder in
                homeData.folders.append(Product(title: folder.name, count: folder.files.count()))
                i += 1
                /// Different on mac --> folder.files vs Folder.documents!.files
            }
        }

        ///important --> when running "My Mac (designed for ipad)", this if statement is used.
        if !(UIDevice.current.userInterfaceIdiom == .mac) {
            print("JD451: NOT mac")
            var i = 0 //numberInLine: i,
            Folder.documents!.subfolders.recursive.forEach { folder in
                homeData.folders.append(Product(title: folder.name, count: folder.files.count()))
                i += 1
            }
        }
        print("JD451: homeData.folders \(homeData.folders)")
    } //End func.
} //END STRUCT

