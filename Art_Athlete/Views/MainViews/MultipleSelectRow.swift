//  MultipleSelectRow.swift  - Art_Athlete
//  Created by josiah on 2021-11-06.

import SwiftUI
import Files

struct MultipleSelectRow: View {
    // MARK: - VARIABLES
    @Environment(\.colorScheme) var currentDarkLightMode
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var sharedData: SharedViewModel
    @AppStorage("selectedFolders") var selectedFolders: [String] = [] //Store the last selected photos here.

    @EnvironmentObject var homeData: HomeViewModel

    @State var trimVal : CGFloat = 0

    @State private var alertShowing = false
    @State private var editMode: EditMode = .inactive

    @Binding var rowSelection: Set<String>
    @State var url : URL = URL(fileURLWithPath: "nil")
    @State var selectAll = false
    @State var isSelected : Bool = false
    @Binding var isloadingPhotos: Bool

    @State var selectedBtn: Int = 1

    //@State var selected = 0    // 1

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    // MARK: - UI
    var body: some View {

        VStack {
            ShowAllFolders()
        }
       // .onAppear(perform: scanAllFolders)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                  //  self.cdDeleteButton
                    StatsButton()
                        .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                }
            }
        }
    } //End view.
    /*•••••••••••••END VIEW••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••*/

       /*__/,|   (`\
     _.|o o  |_   ) )
     -(((---(((-----*/

    /*•••••••••START FUNCTIONS•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••*/
    //MARK: - VIEWBUILDER. •••••••••••••••••••••
    @ViewBuilder
    func ShowAllFolders()->some View{
        HStack {
            Text("Photos").font(.title3)
                .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
            LoadFoldersButton(isloadingPhotos: $isloadingPhotos)
                .environmentObject(homeData)
            Spacer()
            Text("Files").font(.title3)
        }.padding()

        List {
            ForEach(homeData.folders, id: \.self) { product in
                FolderButtonRowView(product: product, selectedBtn: self.$selectedBtn) //2
            }
            .onDelete(perform: removeFolders)
        }
    } //End func.

    private func deleteAllFolders() {
        homeData.folders.removeAll()
    }

//    public func scanAllFolders() {
//        if (UIDevice.current.userInterfaceIdiom == .mac) {
//            print("JD451: mac")
//            Folder.documents!.subfolders.recursive.forEach { folder in
//                homeData.folders.append(Product(type: .Poses, title: folder.name, subtitle: "xx", count: folder.files.count()))
//                /// Different on mac --> folder.files vs Folder.documents!.files
//            }
//        }
//
//        ///important --> when running "My Mac (designed for ipad)", this if statement is used.
//        if !(UIDevice.current.userInterfaceIdiom == .mac) {
//            print("JD451: NOT mac")
//            Folder.documents!.subfolders.recursive.forEach { folder in
//                homeData.folders.append(Product(type: .Poses, title: folder.name, subtitle: "xx", count: folder.files.count()))
//            }
//        }
//    } //End func.

//    func appendFolders(at offsets: IndexSet) {
//        homeData.folders = homeData.folders.enumerated().filter { (i, item) -> Bool in
//            let added = offsets.contains(i)
//            if added {
//                addFolderToDrawList(folder: item)
//            }
//            return !added
//        }.map { $0.1 }
//    }

//    private func addFolderToDrawList(folder: Product) {
//        let folderName = folder.title
//        prefs.arrayOfFolderNames.append(folderName)
//        print("JD460: \(prefs.arrayOfFolderNames)")
//    }

    private func removeFolderFromDrawList(folder: Product) {
        if let index = prefs.arrayOfFolderNames.firstIndex(of: folder.title) {
            prefs.arrayOfFolderNames.remove(at: index)
        }
        print("JD460: \(prefs.arrayOfFolderNames)")
    }
//
//    //FIXME: After deleting folders, a bug happens with the prefs.arrayOfFolderNames.
    func removeFolders(at offsets: IndexSet) {
        homeData.folders = homeData.folders.enumerated().filter { (i, item) -> Bool in
            let removed = offsets.contains(i)
            if removed {
                deleteFolderFromComputer(folder: item)
                removeFolderFromDrawList(folder: item) //Remove from prefs array.
            }
            return !removed
        }.map { $0.1 }
    }

    private func deleteFolderFromComputer(folder: Product) {
        print("JD460: \(folder.title)")
        let folderName = folder.title
        let url = Folder.documents!.path

        if (Folder.documents!.containsSubfolder(named: folderName)) {
            do {
                let folder = try Folder(path: url.appending(folderName))
                try folder.delete()
            } catch {
                print("JD460: error.")
            }
        }
    }



    private func deleteAllPhotosInSandbox() {
        Folder.documents!.subfolders.recursive.forEach { folder in
            print("JD451: Name : \(folder.name), parent: \(String(describing: folder.parent))")
            do {
                try folder.delete()
            } catch {
                print("error in delete sandbox")
            }
        }
    }

    private var cdDeleteButton: some View {
        return Button(action: deleteAllPhotosInSandbox) { //cdDeleteFolders
            Image(systemName: "trash")
        }.disabled(rowSelection.count <= 0)
    }
} //End Struct.



/*
 private func deleteAllRows() {
    storedFileURLs.removeAll()
    PersistenceController.shared.clearDatabase()
    try? self.context.save()
    rowSelection = Set<String>()
 }





 //.environment(\.editMode, .constant(EditMode.active)) // *IMPORTANT* Allows checkbox to appear.
 */
