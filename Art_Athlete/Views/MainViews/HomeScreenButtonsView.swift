//  HomeScreenButtonsView.swift - Art_Athlete
//  Created by josiah on 2021-11-02.

import SwiftUI
//import UniformTypeIdentifiers
import Files
import SlideOverCard
//import Laden


struct HomeScreenButtonsView: View {
    @Environment(\.colorScheme) var currentDarkLightMode
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    //@EnvironmentObject var sharedData: SharedViewModel
    @Environment(\.managedObjectContext) var context
    //@StateObject var homeData: HomeViewModel = HomeViewModel()
    @EnvironmentObject var homeData: HomeViewModel
    //@ObservedObject var homeData: HomeViewModel
    
    @State var isAddingPhotos: Bool = false
    @State var showPhotos: Bool = false
    @State private var isLoading = true
    //@State private var isloadingPhotos = false
    @State public var totalPhotosLoaded = 0
    @State var rowSelection = Set<String>()

    //@EnvironmentObject var rowSelection: Set<String>()

    @State var error = ""
    @State var url : URL = URL(fileURLWithPath: "nil")
    @State var cdSelection = Set<FoldersEntity>()

    @State private var shouldLoadingView = true

    @State var showAlert = false

    func notificationReminder() -> Alert {
        Alert(
            title: Text("Notifications Required"),
            message: Text("Please authorize notifications by going to Settings > Notifications > Remindr"),
            dismissButton: .default(Text("Okay")))
    }

    //MARK: - VIEW FOR ANIMATION
//    var laden: some View {
//        Laden.CircleLoadingView(
//            color: .white, size: CGSize(width: 30, height: 30), strokeLineWidth: 3
//        )
//    }

    /*\___/\ ((
     \`@_@'/  ))
     {_:Y:.}_//
     ----------{_}^-'{_}----------*/

    //MARK: - VIEW
    var body: some View {
        NavigationView {
            VStack {
                //FileImporterView() //This loads in photos MARK: [BLUE BOX]
            //    if #available(macCatalyst 15, *) {
                    MultipleSelectRow(rowSelection: $rowSelection)
                        .environmentObject(homeData)
             //   } else { // Fallback on earlier versions }

                if UIDevice.current.userInterfaceIdiom == (.phone) {

                    Text(prefs.error)
                    countPickerView()
                    timePickerView()
                    StartButton(rowSelection: $rowSelection)
                }
            } //.onAppear(perform: scanAllFolders)
            .alert(isPresented: self.$showAlert,
                   content: { self.notificationReminder() })

            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    HStack {
                        EditButton()
                            .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                        settingsButton()
                            .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                    }
                }
            } //End toolbar

            if UIDevice.current.userInterfaceIdiom != (.phone) {
                VStack {  // MARK: - Shows the main screen (right side).
                    Text("Art Athlete").font(.title)
                    Text("Photo Timer").font(.caption)
                    VStack {
                    //    if !(isloadingPhotos) {
                            Text(prefs.error)
                            // Spacer().frame(maxWidth: .infinity)
                            MainImageView()
                            countPickerView()
                            timePickerView()
                            StartButton(rowSelection: $rowSelection)
                       // } else { Text("Loading Photos...please wait...")  }
                    } //End VStack.
                }
                .alert(isPresented: self.$showAlert,
                       content: { self.notificationReminder() })

              //  .if(isloadingPhotos) { $0.foregroundColor(.blue) } //.overlay(Laden.BarLoadingView()) } //.foregroundColor(.red) }
            } // End if.
        } //NavigationView
        .onAppear(perform: scanAllFolders)
    } //End UI.

       /*__/,|   (`\
     _.|o o  |_   ) )
     -(((---(((-----*/

    //MARK: - FUNCTIONS
    public func scanAllFolders() {
        homeData.folders.removeAll()
        Folder.documents!.subfolders.recursive.forEach { folder in
            homeData.folders.append(Product(title: folder.name, count: folder.files.count()))
        }
    }
} //End struct.

//MARK: - Extension
extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}
