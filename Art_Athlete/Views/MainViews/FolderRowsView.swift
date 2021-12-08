//
//  FolderRowsView.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-23.
//

import SwiftUI
import Files

struct SimpleRowView: View {
    @ObservedObject var simple: FoldersModel
    @State private var isToggle : Bool = false

    var body: some View {
        HStack {
            //Toggle(isOn: $isToggle){
            Toggle(isOn: $simple.isToggle){
                Text(simple.name)
                   // .font(.title)
               
                    .foregroundColor(Color.white)
            }
        }.padding()
            .background(simple.isToggle ? Color.gray : Color.black)
            


   // TextField("title", text: $simple.name)
    }
//Text(text: $simple.name)
    //MARK: FUNCTIONS

}


struct FolderRowsView: View {
  //  @ObservedObject var folderArrayModel: FoldersArrayModel
    @EnvironmentObject var homeData: HomeViewModel
    @State private var editMode: EditMode = .active
    @Binding var rowSelection: Set<String>

    var body: some View {
//        let summary_binding = Binding<String>(
//            get: { return self.folderArrayModel.folderArray.reduce("") { $0 + $1.name } },
//            set: { _ = $0 }
//        )

        return VStack() {
            //TextField("summary", text: summary_binding)
//            List(selection: $rowSelection) {
//                ForEach(folderArrayModel.folderArray) { simple in
//                    SimpleRowView(simple: simple).onReceive(simple.objectWillChange) {_ in self.folderArrayModel.objectWillChange.send()}
////                    SimpleRowView(simple: simple) { folder in
////                        folderArrayModel}
//                }
//            }

            ForEach(homeData.filteredProducts) { product in
                Text("\(product.title) - \(product.type.rawValue)")
            }

           // .onDelete(perform: )
            //.listStyle(InsetListStyle())
              //  .toolbar {
              //      EditButton()
              //  }

            Button(action: {
                scanAllFolders()
            }) {
                Text("Add text")
            }.padding()
        }//.onAppear(perform: scanAllFolders)
       // .environment(\.editMode, .constant(EditMode.active))
        
    } //End body view.


    //MARK: FUNCTIONS
    private func scanAllFolders() {
        //folderArrayModel.folderArray.removeAll()
        if (UIDevice.current.userInterfaceIdiom == .mac) {
            print("JD451: mac")
            Folder.documents!.subfolders.recursive.forEach { folder in
//                let newFolder = FoldersModel(name: folder.name)
//                folderArrayModel.folderArray.append(newFolder)
            }
        }

        //MARK: important --> when running "My Mac (designed for ipad)", this if statement is used.
        if !(UIDevice.current.userInterfaceIdiom == .mac) {
            print("JD451: NOT MAC")
            Folder.documents!.subfolders.recursive.forEach { folder in
//                let newFolder = FoldersModel(name: folder.name)
//                folderArrayModel.folderArray.append(newFolder)
            }
        }
    } //End func.
}


