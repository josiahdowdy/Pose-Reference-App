//
//  FoldersView.swift
//  Art_Athlete
//
//  Created by josiah on 2021-10-30.
//

import SwiftUI

struct FoldersView: View {
    @Environment(\.managedObjectContext) var context
    @State var trimVal : CGFloat = 0
    @State var checked = false

    var folderData : FetchedResults<PhotoFolders>
    
    var body: some View {

        VStack(){
            HStack {
                Text("Folders").font(.title3).padding()
                LoadFoldersButton()
            }

            List {

                ForEach(folderData, id:\.self) { data in
                //ForEach(Array(zip(photoFolders.indices, photoFolders)), id:\.0 ) { data in  //id:\.self
                   // let isOn = data.wrappedIsSelected
                    //Add the checkbox.
//                    Button(action: {
//                    if !self.checked {
//                        withAnimation(Animation.easeIn(duration: 0.8)) {
//                            self.trimVal = 1
//                            self.checked.toggle()
//                        }
//                    } else {
//                        withAnimation {
//                            self.trimVal = 0
//                            self.checked.toggle()
//                        }
//                    }) {

                    //self.photoFoldersid:\.self[data].wrappedIsSelected
                    LazyHStack {
                       // CircularCheckBoxView(checked: self.photoFolders.wrappedIsSelected, trimVal: $trimVal)
                        CircularCheckBoxView(checked: $checked, trimVal: $trimVal)
                            .onTapGesture {
                                if !self.checked {
                                    withAnimation(Animation.easeIn(duration: 0.8)) {
                                        self.trimVal = 1
                                        self.checked.toggle()

                                    }
                                } else {
                                    withAnimation {
                                        self.trimVal = 0
                                        self.checked.toggle()
                                    }
                                }
                            }


                        Text(" \(data.wrappedFolderName ) ")//- \(data.tag ?? "tags") - ")
                           // .font(.caption)
                            .contextMenu {
                                Button("Delete"){
                                    context.delete(data)
                                    try? context.save()
                                }
                            }
                    }

                }
                //.listRowBackground(Color.gray)
            }
        }
//        .accentColor(Color.black)
//                .overlay(
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(Color.purple, lineWidth: 5)
//                .background(Color.pink)
//
//        )
    }
}

//struct FoldersView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoldersView()
//    }
//}
