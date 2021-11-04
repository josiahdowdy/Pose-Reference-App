//
//  FoldersView.swift
//  Art_Athlete
//
//  Created by josiah on 2021-10-30.
//

import SwiftUI

struct FoldersView: View {
    @Environment(\.managedObjectContext) var context
    
    var photoData : FetchedResults<PhotoFolders>
    
    var body: some View {
        List {
            ForEach(photoData, id:\.self) { data in
                Text("- \(data.wrappedFolderName ) ")//- \(data.tag ?? "tags") - ")
                    .contextMenu {
                        Button("Delete"){
                            context.delete(data)
                            try? context.save()
                        }
                    }
            }
        }
    }
}

//struct FoldersView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoldersView()
//    }
//}
