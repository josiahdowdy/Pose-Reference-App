//  FolderButtonRowView.swift - Art_Athlete  - Created by josiah on 2021-11-30.

import SwiftUI
import Files

struct FolderButtonRowView: View {
    @Environment(\.colorScheme) var currentDarkLightMode
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
                Spacer()
                //Text(product.count.description).foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                  //  .foregroundColor(.white)
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
       // let url = Folder.documents!.path

        prefs.arrayOfFolderNames.append(folderName)
    }
}
