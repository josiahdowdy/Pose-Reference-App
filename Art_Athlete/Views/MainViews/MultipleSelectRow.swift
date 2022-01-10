//  MultipleSelectRow.swift  - Art_Athlete - Created by josiah on 2021-11-06.

import SwiftUI
import Files
import CoreLocation

public class ImageProvider {
    // convenient for specific image
    public static func picture() -> UIImage {
        return UIImage(named: "picture", in: Bundle(for: self), with: nil) ?? UIImage()
    }

    // for any image located in bundle where this class has built
    public static func image(named: String) -> UIImage? {
        return UIImage(named: named, in: Bundle(for: self), with: nil)
    }
}

@available(macCatalyst 15, *)
struct MultipleSelectRow: View {
    //@Environment(\.refresh) var refreshAction: RefreshAction?

    @Environment(\.colorScheme) var currentDarkLightMode
   // @Environment(\.managedObjectContext) var context
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var sharedData: SharedViewModel
   // @AppStorage("selectedFolders") var selectedFolders: [String] = [] //Store the last selected photos here.

    @EnvironmentObject var homeData: HomeViewModel

    @State var trimVal : CGFloat = 0
   // @State var imageProvider = ImageProvider()

    @State var needRefresh: Bool = false
    @State private var alertShowing = false
    @State private var editMode: EditMode = .inactive

    @Binding var rowSelection: Set<String>
    @State var url : URL = URL(fileURLWithPath: "nil")
    @State var selectAll = false
    @State var isSelected : Bool = false
    //@Binding var isloadingPhotos: Bool

    @State var selectedBtn: Int = 1
    @State var checked: Bool = false

    @State var imageSize: CGSize = .zero // << or initial from NSImage
    @State private var animationAmount = 1.0


    //@State var selected = 0    // 1
//    init() {
//        print("JD00 → *****************    3. MultipleSelectRow ")
//    }

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    // MARK: - UI
    var body: some View {

        VStack {
            ShowAllFolders()
        }
       // .onAppear(perform: scanAllFolders)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                HStack {
//                  //  self.cdDeleteButton
//                    StatsButton(showStats: showStats)
//                        .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
//                }
//            }
//        }
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
            Text("Photos").font(.title3).foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)

            ZStack {

            LoadFoldersButtoniPad(needRefresh: $needRefresh)
                .environmentObject(homeData)
                .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                //.background(rectReader())
                .padding(20)
//                .clipShape(Circle())
//                .overlay(
//                    Circle()
//                        .stroke(.green)
//                        .scaleEffect(animationAmount)
//                        .opacity(2 - animationAmount)
//                        .animation(
//                            .easeInOut(duration: 1)
//                                .repeatForever(autoreverses: false),
//                            value: animationAmount
//                        )
//                )
//                .onAppear {
//                    animationAmount = 2
//                }
            }

            Spacer()

            if (UIDevice.current.userInterfaceIdiom == .mac) {
                Text("Files").font(.title3)
            }

        }
        .padding()

  //      PhotoAssets()

        List {
            ForEach(homeData.folders, id: \.self) { product in
                FolderButtonRowView(product: product, selectedBtn: self.$selectedBtn) //2
                  //  .environmentObject(homeData)
            }
            .onDelete(perform: removeFolders)
        }
    } //End func.


    //Start funcs.
    private func rectReader() -> some View {
        return GeometryReader { (geometry) -> AnyView in
            let imageSize = geometry.size
            DispatchQueue.main.async {
                print(">> \(imageSize)") // use image actual size in your calculations
                self.imageSize = imageSize
            }
            return AnyView(
                    Circle().stroke(Color.green, lineWidth: 4)
                        .padding(20)
                //    .padding(20)
               // Rectangle().fill(Color.green)
            )
        }
    }

    private func deleteAllFolders() {
        homeData.folders.removeAll()
    }

    private func removeFolderFromDrawList(folder: Product) {
        if let index = prefs.arrayOfFolderNames.firstIndex(of: folder.title) {
            prefs.arrayOfFolderNames.remove(at: index)
        }
        print("JD460: \(prefs.arrayOfFolderNames)")
    }

    private func removeFolders(at offsets: IndexSet) {
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


/*
     public func scanAllFolders() {
         if (UIDevice.current.userInterfaceIdiom == .mac) {
             print("JD451: mac")
             Folder.documents!.subfolders.recursive.forEach { folder in
                 homeData.folders.append(Product(type: .Poses, title: folder.name, subtitle: "xx", count: folder.files.count()))
                 /// Different on mac --> folder.files vs Folder.documents!.files
             }
         }

         ///important --> when running "My Mac (designed for ipad)", this if statement is used.
         if !(UIDevice.current.userInterfaceIdiom == .mac) {
             print("JD451: NOT mac")
             Folder.documents!.subfolders.recursive.forEach { folder in
                 homeData.folders.append(Product(type: .Poses, title: folder.name, subtitle: "xx", count: folder.files.count()))
             }
         }
     } //End func.

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


 Button {
 print("JD451: Files in Documents -->", FileManager.default.urls(for: .documentDirectory) ?? "none")
 guard
 let path = FileManager
 .default
 .urls(for: .documentDirectory, in: .userDomainMask)

 .first?
 .appendingPathComponent("Birds")
 else {
 print("error getting path.")
 return//return nil
 }

 let path2 = FileManager
 .default
 .urls(for: .documentDirectory, in: .userDomainMask)
 .description

 print("JD451: path2 ---> \(path2)")



 do {
 let newFolder = try Folder(path: path.path)
 print("JD451: files of birds: ", newFolder.files)


 //                    let directory = try Folder(path: path2.path)
 //                    print("JD451: directory: ", directory.files)

 } catch {
 print(error)
 }


 print("JD451: path is -->", path)

 } label: {
 Image(systemName: "pencil")
 }

 */
