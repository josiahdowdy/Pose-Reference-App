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

    let scanAllFoldersB: () -> () //Passed in function.

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
        do{
            let selectedFiles = try result.get()//let selectedFiles = try res.get()

            for i in 0...(selectedFiles.count-1) {
                let originFolder = try Folder(path: selectedFiles[i].path)
                let targetFolder = try Folder(path: Folder.documents!.path)
                try originFolder.copy(to: targetFolder)

                //Now add it to homedata.folders.
                //scanNewFolders(selectedFiles: URL)
                homeData.folders.append(Product(type: .Poses, title: originFolder.name, subtitle: "xx", count: originFolder.files.count()))
            }
            try? self.context.save()

        } catch{
            print ("JD82: ", error.localizedDescription)
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
                homeData.folders.append(Product(type: .Poses, title: folder.name, subtitle: "xx", count: folder.files.count()))
                i += 1
                /// Different on mac --> folder.files vs Folder.documents!.files
            }
        }

        ///important --> when running "My Mac (designed for ipad)", this if statement is used.
        if !(UIDevice.current.userInterfaceIdiom == .mac) {
            print("JD451: NOT mac")
            var i = 0 //numberInLine: i,
            Folder.documents!.subfolders.recursive.forEach { folder in
                homeData.folders.append(Product(type: .Poses, title: folder.name, subtitle: "xx", count: folder.files.count()))
                i += 1
            }
        }

        print("JD460: \(homeData.folders)")

    } //End func.
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

extension Array where Element: Hashable {
    func duplicates() -> Array {
        let groups = Dictionary(grouping: self, by: {$0})
        let duplicateGroups = groups.filter {$1.count > 1}
        let duplicates = Array(duplicateGroups.keys)
        return duplicates
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

