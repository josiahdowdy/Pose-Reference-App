//  MultipleSelectRow.swift  - Art_Athlete
//  Created by josiah on 2021-11-06.

import SwiftUI
import Files
import UniformTypeIdentifiers

struct FolderButtonRowView: View {
   // @ObservedObject var foldersArrayModel: FoldersArrayModel
    @EnvironmentObject var homeData: HomeViewModel
    @EnvironmentObject var prefs: GlobalVariables

    var product: Product
    @State var checked: Bool = false
    @Binding var selectedBtn: Int  // 3
    @State var trimVal : CGFloat = 0

    //View.
    var body: some View{
        Button(action: {
           // self.checked.toggle()
         //   self.selectedBtn = self.product.numberInLine//self.product.id
        }){
            HStack{
                CircularCheckBoxView(checked: $checked, trimVal: $trimVal)
                Text(product.title)
                    .foregroundColor(.white)
            }
        }
        .onTapGesture {
            if !self.checked {
                withAnimation(Animation.easeIn(duration: 0.8)) {
                    self.trimVal = 1
                    self.checked.toggle()

                    prefs.arrayOfFolderNames.append(product.title)

                   // foldersModel.isToggle = true
               //     foldersArrayModel.isToggle = true
                    print("JD460: ", prefs.arrayOfFolderNames)
                }
            } else {
                withAnimation {
                    self.trimVal = 0
                    self.checked.toggle()

                    if let index = prefs.arrayOfFolderNames.firstIndex(of: product.title) {
                        prefs.arrayOfFolderNames.remove(at: index)
                    }
                    print("JD460: ", prefs.arrayOfFolderNames) // ["cats", "dogs", "moose"]


                   // prefs.arrayOfFolderNames.removeLast()

               //     foldersArrayModel.isToggle = false
                }
            }
        }
       // .frame(width: 130, height: 50)
        //.background(self.checked ? Color.clear : Color.gray)
        //.cornerRadius(25)
        //.shadow(radius: 10)
      //  .padding(10)
    }

    //Functions
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
        print("JD460: \(folder.title)")
        let folderName = folder.title
        let url = Folder.documents!.path

        prefs.arrayOfFolderNames.append(folderName)
    }
}

struct MultipleSelectRow : View {
    // MARK: - VARIABLES
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var sharedData: SharedViewModel
    @AppStorage("selectedFolders") var selectedFolders: [String] = [] //Store the last selected photos here.
   // @ObservedObject var folderArrayModel: FoldersArrayModel

    @EnvironmentObject var homeData: HomeViewModel

    @State var trimVal : CGFloat = 0

    @State private var alertShowing = false
    @State private var editMode: EditMode = .inactive

    @Binding var rowSelection: Set<String>
    @State var url : URL = URL(fileURLWithPath: "nil")
    @State var selectAll = false
    @State var isSelected : Bool = false
    @Binding var isloadingPhotos: Bool

    //@State var selected = UUID()    // 1
    @State var selectedBtn: Int = 1

    @State var selected = 0    // 1
    //var project: Project


    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    // MARK: - UI
    var body: some View {

        VStack {
           // FolderRowsView(folderArrayModel: folderArrayModel, rowSelection: $rowSelection)
              //  .environmentObject(homeData)
            ShowAllFolders()
        }
        .onAppear(perform: scanAllFolders)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                  //  self.cdDeleteButton
                    StatsButton()
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
            LoadFoldersButton(isloadingPhotos: $isloadingPhotos, scanAllFoldersB: scanAllFolders)
                .environmentObject(homeData)
            Spacer()
            Text("Files").font(.title3)
        }.padding()

        List {
            ForEach(homeData.folders, id: \.self) { product in
                FolderButtonRowView(product: product, selectedBtn: self.$selectedBtn) //2
//
//                Button {
//                   // folderIsSelected(product: product.id)
//                    self.isSelected.toggle()
//                    self.selectedBtn = product.numberInLine
//                } label: {
//                    HStack {
//                        CircularCheckBoxView(checked: $isSelected, trimVal: $trimVal)
//
//                        Text("\(product.title)")
//                        Spacer()
//                        Text("\(product.count)")
//                    }
//                } //End button.
//                .background(self.selectedBtn == product.numberInLine ? Color.red : Color.blue)
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
        print("JD460: \(folder.title)")
        let folderName = folder.title
        let url = Folder.documents!.path

        prefs.arrayOfFolderNames.append(folderName)
    }

    func removeFolders(at offsets: IndexSet) {
        homeData.folders = homeData.folders.enumerated().filter { (i, item) -> Bool in
            let removed = offsets.contains(i)
            if removed {
                deleteFolderFromComputer(folder: item)
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

    public func scanAllFolders() {
        homeData.folders.removeAll()
     //   folderArrayModel.removeAll()
       // folderArrayModel.folderArray.removeAll() //Important!
        if (UIDevice.current.userInterfaceIdiom == .mac) {
            print("JD451: mac")
            var i = 0
            Folder.documents!.subfolders.recursive.forEach { folder in
                homeData.folders.append(Product(numberInLine: i, type: .Poses, title: folder.name, subtitle: "xx", count: folder.files.count()))
                i += 1
              //  let newFolder = FoldersModel(name: folder.name)//
              //  folderArrayModel.folderArray.append(newFolder)

                /// Different on mac --> folder.files vs Folder.documents!.files
            }
        }

        ///important --> when running "My Mac (designed for ipad)", this if statement is used.
        if !(UIDevice.current.userInterfaceIdiom == .mac) {
            print("JD451: NOT mac")
            var i = 0
            Folder.documents!.subfolders.recursive.forEach { folder in
                homeData.folders.append(Product(numberInLine: i, type: .Poses, title: folder.name, subtitle: "xx", count: folder.files.count()))

              //  let newFolder = FoldersModel(name: folder.name)
             //   folderArrayModel.folderArray.append(newFolder)
                i += 1
            }
        }
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
