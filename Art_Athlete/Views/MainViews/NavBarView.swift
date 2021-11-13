//
//  NavBarView.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-02.
//

import SwiftUI
import UniformTypeIdentifiers
//import CheckDevice

struct NavBarView: View {
    @Environment(\.managedObjectContext) var context

//    @EnvironmentObject var prefs: GlobalVariables
//    @EnvironmentObject var timeObject: TimerObject

    //@Binding var startSession: Bool
    
    @State var nameInput: String = ""
    //@State var isAddingContact: Bool = false
    @State var isAddingPhotos: Bool = false
    @State var isImporting: Bool = false
    
    @State private var fullScreen = false

//    @State var isRandom: Bool = true
//    
    //@EnvironmentObject var vm: ViewModel
    
   // var photoData : FetchedResults<PhotoFolders>
    var folderData : FetchedResults<PhotoFolders>
    // --------END VARIABLES--------------
    
    // ------START VIEW---------------------
    var body: some View {
        NavigationView {
                FoldersView(folderData: folderData)
                    .navigationTitle("Photos")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            //iOSSettingsBarView()
                            NavigationLink("Home", destination: HomeScreenButtonsView()) //Image(systemName: "line.3.horizontal.circle")
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                //   iOSSettingsBarView()
                                
                            }) {
                                Image(systemName: "gearshape.fill") }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                self.isAddingPhotos = true }) {
                                    Image(systemName: "plus") }
                        }
                    }
            
            
            //            List {
            //                ForEach(photoData, id:\.self) //(vm.contactNames) {
            //                    Text($0)
            //                } // .onDelete(perform: deleteContacts)
            //            }
            //.onAppear { vm.initializeAndFetchLatestChanges() }
            
            
                
//
//                .toolbar {
//                    //                ToolbarItem(placement: .navigationBarLeading) {
//                    //                    Button(action: { vm.fetchLatestChanges() }) { Image(systemName: "arrow.clockwise" )}
//                    //                }
//
//
//
////                    ToolbarItem(placement: .navigationBarLeading) {
////                        Button("Full Screen") {
////                            self.fullScreen.toggle()
////                        }
////                        .navigationTitle("Full Screen")
////                        .navigationBarHidden(fullScreen)
////                    }
////                    ToolbarItem(placement: .navigationBarTrailing) {
////                        LoadFoldersButton(folderData: folderData)
////
////                    }
//
//
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(action: {
//                         //   iOSSettingsBarView()
//
//                        }) {
//                                Image(systemName: "gearshape.fill") }
//                    }
//
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                            Button(action: {
//                                self.isAddingPhotos = true }) {
//                                    Image(systemName: "plus") }
//                        }
//                }
            
            
            HomeScreenButtonsView()
             //startSession: $startSession
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(false)
        //.sheet(isPresented: $isAddingPhotos, content: { createAddPhotoView() }) //createAddContactView()
        //.navigationViewStyle(StackNavigationViewStyle())
        .fileImporter(
            //isPresented: $isImporting, allowedContentTypes: [UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
            isPresented: $isAddingPhotos, allowedContentTypes: [UTType.folder],
            allowsMultipleSelection: false, //set to true to select multiple folders. But then I need to put them in an array.
            onCompletion: { result in
                do {
                    guard let selectedFolder: URL = try result.get().first else { return }
                    
                    let newFolder = PhotoFolders(context: context)
                    newFolder.folderURL = selectedFolder //Save the folder URL.
                    
                    let folderName: String = selectedFolder.lastPathComponent
                    
                    newFolder.folderName = folderName//newFolder.folderURL(newFolder.folderURL as NSString).lastPathComponent
                    
                } catch { print("failed") }
            })
        
      
    } //------------------END VIEW---------------------------------------------
    
    
    
    //------------------START FUNCTIONS---------------------------------------------
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
    
//    //Don't confuse with start timer in Timer.swift
//    private func startTimer() {
//        timeObject.isTimerRunning = true
//        timeObject.startTime = Date()
//        timeObject.progressValue = 0.0
//        timeObject.timeDouble = 0.0
//        TimerView(timeObject: _timeObject, prefs: _prefs, startSession: $startSession).startTimer()
//        let newSession = UserData(context: context)
//        newSession.date = Date()
//    }
//    
//    private func createAddPhotoView() -> some View {
//        return NavigationView {
//            VStack {
//                TextField("Name", text: $nameInput, onCommit: addAction)
//                    .font(.body)
//                    .textContentType(.name)
//                    .padding(.horizontal, 16)
//                Spacer()
//            }
//            .navigationTitle("Add New Contact")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel", action: { isAddingPhotos = false })
//                }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Add", action: addAction)
//                }
//            }
//        }.onDisappear { nameInput = "" }
      
    /// View for adding a new Contact.
    //    private func createAddContactView() -> some View {
    //        let addAction = {
    //            vm.addContactToLocalAndRemote(name: nameInput) { _ in
    //                isAddingPhotos = false
    //                vm.fetchLatestChanges()
    //            }
    //        }
    //        return NavigationView {
    //            VStack {
    //                TextField("Name", text: $nameInput, onCommit: addAction)
    //                    .font(.body)
    //                    .textContentType(.name)
    //                    .padding(.horizontal, 16)
    //                Spacer()
    //            }
    //            .navigationTitle("Add New Contact")
    //            .toolbar {
    //                ToolbarItem(placement: .cancellationAction) {
    //                    Button("Cancel", action: { isAddingPhotos = false })
    //                }
    //                ToolbarItem(placement: .confirmationAction) {
    //                    Button("Add", action: addAction)
    //                }
    //            }
    //        }.onDisappear { nameInput = "" }
    //    }
    //
    //    private func deleteContacts(at indexSet: IndexSet) {
    //        guard let firstIndex = indexSet.first else {
    //            return
    //        }
    //
    //        let contactName = vm.contactNames[firstIndex]
    //        vm.deleteContactFromLocalAndRemote(name: contactName) { _ in }
    //    }


//struct NavBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavBarView()
//    }
//}
