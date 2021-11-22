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


    @State var selectedItems = Set<UUID>()

    // Core Data variables
   // @State var cdSelection = Set<PhotoFolders>()
    @State var cdEditMode = EditMode.inactive

    var body: some View {

        VStack(){
            HStack {
                Text("F-View").font(.title3).padding()
                

            }

//            //Add the Foreach here.
//            List(selection: $cdSelection) {
//                //ForEach(cdNumbers, id: \.id) { number in
//                ForEach(cdNumbers, id: \.self) { data in
//                    Text(data.wrappedFolderName)
//                }
//             //   .onDelete(perform: cdOnSwipeDelete)
//            }
//            .navigationBarTitle("P2: \(cdSelection.count)")
//          //  .navigationBarItems(leading: cdDeleteButton, trailing: EditButton())
//            .environment(\.editMode, self.$cdEditMode)

        }
    }

//    init() {
//        // Global Navigation bar customizations
//        UINavigationBar.appearance().largeTitleTextAttributes = [
//            .font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)]
//    }
}



//struct FoldersView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoldersView()
//    }
//}



struct CheckmarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Button(action: { withAnimation { configuration.$isOn.wrappedValue.toggle() }}){
                HStack{
                    configuration.label.foregroundColor(.primary)
                    Spacer()
                    if configuration.isOn {
                        Image(systemName: "checkmark").foregroundColor(.primary)
                    }
                }
            }
        }
    }
}
