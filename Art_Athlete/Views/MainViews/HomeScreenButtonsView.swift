//  HomeScreenButtonsView.swift - Art_Athlete
//  Created by josiah on 2021-11-02.

import SwiftUI
import UniformTypeIdentifiers
import Files
import SlideOverCard
import Laden


struct HomeScreenButtonsView: View {
    @Environment(\.colorScheme) var currentDarkLightMode
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var sharedData: SharedViewModel
    @Environment(\.managedObjectContext) var context
    @StateObject var homeData: HomeViewModel = HomeViewModel()
    @State var isAddingPhotos: Bool = false
    @State var showPhotos: Bool = false
    @State private var isLoading = true
    @State private var isloadingPhotos = false
    @State public var totalPhotosLoaded = 0
    @State var rowSelection = Set<String>()

    //@EnvironmentObject var rowSelection: Set<String>()

    @State var error = ""
    @State var url : URL = URL(fileURLWithPath: "nil")
    @State var cdSelection = Set<FoldersEntity>()

    @State private var shouldLoadingView = true

    //MARK: - VIEW FOR ANIMATION
    var laden: some View {
        Laden.CircleLoadingView(
            color: .white, size: CGSize(width: 30, height: 30), strokeLineWidth: 3
        )
    }

    /*\___/\ ((
     \`@_@'/  ))
     {_:Y:.}_//
     ----------{_}^-'{_}----------*/

    //MARK: - VIEW
    var body: some View {
        NavigationView {
            VStack {
                //FileImporterView() //This loads in photos MARK: [BLUE BOX]

                MultipleSelectRow(rowSelection: $rowSelection, isloadingPhotos: $isloadingPhotos)
                    .environmentObject(homeData)

                if UIDevice.current.userInterfaceIdiom == (.phone) {
                    countPickerView()
                    timePickerView()
                    StartButton(rowSelection: $rowSelection) }
            } //.onAppear(perform: scanAllFolders)

            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    HStack {
                        EditButton()
                            .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                        settingsButton()
                    }
                }
            }

            VStack {  // MARK: - Shows the main screen (right side).
                VStack {
                    if !(isloadingPhotos) {
                        Text(prefs.error)

                        Spacer().frame(maxWidth: .infinity)

                        MainImageView()
                        countPickerView()
                        timePickerView()
                        StartButton(rowSelection: $rowSelection)
                    } else {
                        Text("Loading Photos...please wait...")
                    }
                } //End VStack.
            }
            .if(isloadingPhotos) { $0.foregroundColor(.blue) } //.overlay(Laden.BarLoadingView()) } //.foregroundColor(.red) }
        } //NavigationView
       // .onAppear(perform: scanAllFolders)
    } //End UI.

       /*__/,|   (`\
     _.|o o  |_   ) )
     -(((---(((-----*/

    //MARK: - FUNCTIONS
//    public func scanAllFolders() {
//        if (UIDevice.current.userInterfaceIdiom == .mac) {
//            print("JD451: mac")
//            Folder.documents!.subfolders.recursive.forEach { folder in
//                //MARK: Different on mac --> folder.files vs Folder.documents!.files
//            }
//        }
//
//        //MARK: important --> when running "My Mac (designed for ipad)", this if statement is used.
//        if !(UIDevice.current.userInterfaceIdiom == .mac) {
//            Folder.documents!.subfolders.recursive.forEach { folder in
//            }
//        }
//    } //End func.
} //End struct.

//MARK: - Extension
extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}
