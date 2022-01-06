//FolderAssetsRowView.swift - Art_Athlete - Created by josiah on 2022-01-06.
import SwiftUI
import Files

struct FolderAssetsRowView: View {
    @Environment(\.colorScheme) var currentDarkLightMode
    @EnvironmentObject var prefs: GlobalVariables

    var folder: Folders

    @State var checked: Bool = false
    @Binding var selectedBtn: Int  // 3
    @State var trimVal : CGFloat = 0

    //View.
    var body: some View {
        Button(action: {
            // Code
        }){
            HStack{
                CircularCheckBoxView(checked: $checked, trimVal: $trimVal)
                Text(folder.name)
                Spacer()
//                if (UIDevice.current.userInterfaceIdiom == .mac) {
//                    Text(product.count.description).foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
//                    //  .foregroundColor(.white)
//                }
            }

        }
        .onTapGesture {
            if !self.checked {
                withAnimation(Animation.easeIn(duration: 0.8)) {
                    self.trimVal = 1
                    self.checked.toggle()

                 //   prefs.arrayOfFolderNames.append(product.title)
                }
            } else {
                withAnimation {
                    self.trimVal = 0
                    self.checked.toggle()

//                    if let index = prefs.arrayOfFolderNames.firstIndex(of: product.title) {
//                        prefs.arrayOfFolderNames.remove(at: index)
//                    }
                }
            }
        }
    }

    private func addFolderToDrawList(folder: Product) {
        print("JD460: \(folder.title)")
        let folderName = folder.title
        prefs.arrayOfFolderNames.append(folderName)
    }
}
