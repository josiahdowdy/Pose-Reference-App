//
//  FoldersStruct.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-22.
//

import SwiftUI

class FoldersModel: ObservableObject, Identifiable {  //, Identifiable
    let id = UUID();
    @Published var name: String = ""
    @Published var isToggle: Bool = false

    init(name: String) { self.name = name }
    init(isToggle: Bool) { self.isToggle = isToggle }

   // var name: String
    //var folderName: String
}

class FoldersArrayModel : ObservableObject, Identifiable { //
    let id = UUID(); @Published var folderArray: [FoldersModel]
    init(folderArray: [FoldersModel]) { self.folderArray = folderArray }
}

//let folderArrayData: FoldersArrayModel = FoldersArrayModel(folderArray: [FoldersModel(name: "text0"), FoldersModel(name: "text1")])
//let folderArrayData: FoldersArrayModel = FoldersArrayModel(folderArray: [FoldersModel(name: "text0"), FoldersModel(name: "text1")])


//struct FoldersStruct_Previews: PreviewProvider {
//    static var previews: some View {
//        FoldersStruct()
//    }
//}
