/*
 Josiah - Oct 29, 2020
 When user presses 'Stats' then this sheet is opened.
 It shows the user drawing records.
*/



import SwiftUI
//import Kingfisher

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var userObject: UserObject
    
    @State private var sort: Int = 0

    @State private var showingSheet = false
    @State private var showingMainMenu = false
    @State var nameText = ""

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Settings").font(.largeTitle)
                TextField("Enter artist name...",
                          text: $prefs.userName,//$nameText,
                          onEditingChanged: { _ in print("changed") },
                          onCommit: { print("commit") })
                Text("\(Image(systemName: "asterisk.circle")) Name or nickname is only required if you want to save session data.\n")
                    .font(.footnote).padding(.top, 10)
                
                Text("Set Unsplash Photo quality: thumb, small, regular, full, raw")
                //Menu("Unsplash Photo Quality") {}
                Menu("Unsplash Photo Quality") {
                    /*
                    Button("Thumbnail") { prefs.imageQuality = "thumb"}
                    Button("Small") { prefs.imageQuality = "small" }
                    Button("Regular") { prefs.imageQuality = "regular" }
                    Button("Full") { prefs.imageQuality = "full" }
                    Button("Raw") { prefs.imageQuality = "raw" }
                     */
                }

                Button("DELETE DATA"){
                    
                }.padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(8)
                
            }.padding(.horizontal, 20)
               
            Group {
                    Button("Main Menu") {
                        self.presentationMode.wrappedValue.dismiss()
                    }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }.padding(.horizontal, 20)
        }
    }
}

