//  FolderButtonRowView.swift - Art_Athlete  - Created by josiah on 2021-11-30.

import SwiftUI
import Files

struct FolderButtonRowView: View {
    @Environment(\.colorScheme) var currentDarkLightMode
   // @EnvironmentObject var homeData: HomeViewModel

    @EnvironmentObject var prefs: GlobalVariables

    var product: Product
  //  var folder: 

    @State var checked: Bool = false
    @Binding var selectedBtn: Int  // 3
    @State var trimVal : CGFloat = 0

//    init() {
//        print("JD00 → *****************    4. FolderButtonRowView ")
//    }
    //View.
    var body: some View {
        Button(action: {
            // self.checked.toggle()
            //   self.selectedBtn = self.product.numberInLine//self.product.id
        }){
            HStack{
                CircularCheckBoxView(checked: $checked, trimVal: $trimVal)
                Text(product.title)
                Spacer()
                if (UIDevice.current.userInterfaceIdiom == .mac) {
                Text(product.count.description).foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                  //  .foregroundColor(.white)
                }
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
        .toolbar {
            HStack {
               // self.cdDeleteButton
            }

        }
    }

    private func addFolderToDrawList(folder: Product) {
        print("JD460: \(folder.title)")
        let folderName = folder.title
        // let url = Folder.documents!.path

        prefs.arrayOfFolderNames.append(folderName)
    }
}


    //Functions
//    func appendFolders(at offsets: IndexSet) {
//        homeData.folders = homeData.folders.enumerated().filter { (i, item) -> Bool in
//            let added = offsets.contains(i)
//            if added {
//                addFolderToDrawList(folder: item)
//            }
//            return !added
//        }.map { $0.1 }
//    }


//    func removeFolders(at offsets: IndexSet) {
//        homeData.folders = homeData.folders.enumerated().filter { (i, item) -> Bool in
//            let removed = offsets.contains(i)
//            if removed {
//              //  deleteFolderFromComputer(folder: item)
//              //  removeFolderFromDrawList(folder: item) //Remove from prefs array.
//            }
//            return !removed
//        }.map { $0.1 }
//    }

//    private var cdDeleteButton: some View {
//        return Button(action: deleteFolderFromComputer(folder: product)) { //cdDeleteFolders
//            Image(systemName: "trash")
//        }.disabled(rowSelection.count <= 0)
//    }

//    private func deleteFolderFromComputer(folder: Product) {
//        print("JD460: \(folder.title)")
//        let folderName = folder.title
//        let url = Folder.documents!.path
//
//        if (Folder.documents!.containsSubfolder(named: folderName)) {
//            do {
//                let folder = try Folder(path: url.appending(folderName))
//                try folder.delete()
//            } catch {
//                print("JD460: error.")
//            }
//        }
//    }

