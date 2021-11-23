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
    var body: some View {
        TextField("title", text: $simple.name)
    }

    //MARK: FUNCTIONS

}

struct FolderRowsView: View {
    @ObservedObject var folderArrayModel: FoldersArrayModel

    var body: some View {
        let summary_binding = Binding<String>(
            get: { return self.folderArrayModel.folderArray.reduce("") { $0 + $1.name } },
            set: { _ = $0 }
        )

        return VStack() {
            //TextField("summary", text: summary_binding)
            List() {
                ForEach(folderArrayModel.folderArray) { simple in
                    SimpleRowView(simple: simple).onReceive(simple.objectWillChange) {_ in self.folderArrayModel.objectWillChange.send()}
                }
            }

            Button(action: {
                self.folderArrayModel.folderArray.append(FoldersModel(name: "new text"))
                scanAllFolders()
            }) {
                Text("Add text")

            }.padding()
        }.onAppear(perform: scanAllFolders)

    }

    //MARK: FUNCTIONS
    private func scanAllFolders() {
        print("JD451: scanAllFolders() started")

        print("JD451", folderArrayModel.folderArray.debugDescription)
        print("JD451", folderArrayModel.folderArray.count)

       // FoldersArrayModel(folderArray: [FoldersModel(name: "n")])

        print("JD451:", Folder.documents!)

        if (UIDevice.current.userInterfaceIdiom == .mac) {
            print("JD451: mac")

            Folder.documents!.subfolders.recursive.forEach { folder in
                print("JD451: Name : \(folder.name), parent: \(String(describing: folder.parent))")

                let newFolder = FoldersModel(name: folder.name)
                folderArrayModel.folderArray.append(newFolder)

            }
        }

        //MARK: important --> when running "My Mac (designed for ipad)", this if statement is used.
        if !(UIDevice.current.userInterfaceIdiom == .mac) {
            print("JD451: NOT MAC")

            Folder.documents!.subfolders.recursive.forEach { folder in
                print("JD451: Name : \(folder.name), parent: \(String(describing: folder.parent))")

                let newFolder = FoldersModel(name: folder.name)
                folderArrayModel.folderArray.append(newFolder)

            }
        }
    }
}


