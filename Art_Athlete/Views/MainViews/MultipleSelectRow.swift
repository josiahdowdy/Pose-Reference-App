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
            LoadFoldersButton(isloadingPhotos: $isloadingPhotos, scanAllFoldersB: scanAllFolders)
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
    }

    private func folderIsSelected(product: Product) {
        //self.selectedBtn = product
        self.isSelected.toggle()
    }

    func appendFolders(at offsets: IndexSet) {
        homeData.folders = homeData.folders.enumerated().filter { (i, item) -> Bool in
            let added = offsets.contains(i)
            if added {
                addFolderToDrawList(folder: item)
            }
            return !added
        }.map { $0.1 }
    }

    private func addFolderToDrawList(folder: Product) {
        let folderName = folder.title
        prefs.arrayOfFolderNames.append(folderName)
        print("JD460: \(prefs.arrayOfFolderNames)")
    }

    private func removeFolderFromDrawList(folder: Product) {
        if let index = prefs.arrayOfFolderNames.firstIndex(of: folder.title) {
            prefs.arrayOfFolderNames.remove(at: index)
        }
        print("JD460: \(prefs.arrayOfFolderNames)")
    }

    //FIXME: After deleting folders, a bug happens with the prefs.arrayOfFolderNames.
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

    public func scanNewFolders() {

    }

    public func scanAllFolders() {
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

        ///1. Get all of the titles of the foldes.
        ///2. Then save them in an array.
        ///3. Detect which numbers in new array are duplicates.
        ///4. Now delete those numbers in the original array.
        ///Probably more efficient way to do this, but this ought to work.
        //var x = 0

//        var arrA = [String]()//= [String]
//        for i in homeData.folders {
//            arrA.append(i.title)
//            //homeData.folders.removeDuplicatesFolders(titleFolder: homeData.folders[Product(title)])
//        }
//
//        print("JD460: arrA --> \n\n \(arrA)")
//
//        ///Now, detect which numbers are duplicates in arrA.
//        let crossReference = Dictionary(grouping: homeData.folders, by: \.title)
//        print("JD460: crossReference --> \n\n \(crossReference)")
//        let duplicates = crossReference
//            .filter { $1.count > 1 }                 // filter down to only those with multiple contacts
//            .sorted { $0.1.count > $1.1.count }
//        print("JD460: Duplicates --> \n\n \(duplicates)")
//        print("JD460: AFTER DUPLICATES \(homeData.folders)")
    } //End func.

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
