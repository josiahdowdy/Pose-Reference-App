//SlideOverCard.swift -  Art_Athlete - Created by josiah on 2021-11-04.

import SwiftUI
import SlideOverCard
import Files

struct ArtAthleteSettings : View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var currentDarkLightMode
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var homeData: HomeViewModel
    let persistenceController = PersistenceController.shared
    

    @State private var userData = UserData()

    @FetchRequest(
        entity: UserData.entity(), sortDescriptors: []
    ) var userDataFetch : FetchedResults<UserData>



    //@Binding var notifyMeAbout : Bool
    //@Binding var playNotificationSounds : Bool
    //@Binding var profileImageSize : Bool
    //@Binding var sendReadReceipts : Bool

    @State private var showingMail = false

    var body: some View {
        VStack {
            ZStack {
                HStack{
                    Spacer()
                    Text("Settings")//.font(.title)
                        .font(.title3)
                    Spacer()
                }
                HStack {
                    Spacer()

                    Button(action: {
                        prefs.showSettings = false
                    }, label: {
                        HStack {
                            Text("Done")
                            Image(systemName: "x.circle.fill")
                        }
                    }).padding(.trailing, 10)
                }
            }
            // Spacer()
        } //End VStack 1.
        .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)

        Form() {
            Section(header: Text("Options")) {
                toggleSwitch()
            }


            Section(header: Text("Delete")) {
                Button {
                    deleteFilesInDirectory()
                    scanAllFolders()
                } label: {
                    HStack {
                        Image(systemName: "trash.circle")
                        Text("Delete All Photos")
                    }
                }

                Button {
                    //TODO: Create pop-up warning. "ARE YOU SURE?"
                    resetUserStats()
                } label: {
                    HStack {
                        Image(systemName: "0.circle.fill")
                        Text("Reset All User Stats")
                    }
                }
            }//.foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)

            Section(header: Text("ABOUT")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                }

                Button("\(Image(systemName: "mail")) Email support: artathlete@icloud.com") {
                    self.showingMail.toggle()
                }
                .sheet(isPresented: $showingMail) {
                    MailComposeViewController(toRecipients: ["artathlete@icloud.com"], mailBody: "Art Athlete App Support") {
                        // Did finish action
                    }
                }
            } //.foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
        } //End form
        .frame(maxWidth: .infinity)
        
        .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)

       // .background(RoundedRectangle(cornerRadius: 50).fill(currentDarkLightMode == .dark ? Color.yellow : Color.white))
        Text("Total: \(userDataFetch.count)")
        List {
            ForEach(userDataFetch) { user in
                HStack {
                    //let date = user.date?.formatted(date: <#T##Date.FormatStyle.DateStyle#>, time: <#T##Date.FormatStyle.TimeStyle#>)
                    Text(user.date?.formatted(.dateTime.day().month().hour().minute()) ?? "xx/xx/xxxx")
                    Text(" - \(user.countPoses)")
                    Text(" - \(user.timeDrawn)")
                }

            }
        }
    }//End view

    //Functions
    public func scanAllFolders() {
        homeData.folders.removeAll()
        Folder.documents?.subfolders.recursive.forEach { folder in
            homeData.folders.append(Product(title: folder.name, count: folder.files.count()))
        }
    }

    func resetUserStats() {
       // iCloudDelete(cloudDB: UserData)
       // persistenceController.deleteData()

        //UserData.removeAllObjectsInContext(self.persistenceController.context)

       // UserData.executeBatchDelete(in: context)

        persistenceController.deleteAll(entityName: "UserData")

       // self.refreshingID = UUID() // < force refresh

       // persistenceController.delete(userData)
        //persistenceController.deleteAllData() //.delete()
        //userData[0].removeAll()
        //userData.
        // List of multiple objects to delete
        //let objects: [NSManagedObject] = UserData() // A list of objects

        // Get a reference to a managed object context
        //let context = //persistentContainer.viewContext

        // Delete multiple objects
//        for object in objects {
//            context.delete(object)
//        }

        // Save the deletions to the persistent store
        do {
            try context.save()
        } catch {
            print("JD500: \(error)")
        }

       // persistenceController.save()
    }

    func deleteFilesInDirectory() {
        print("JD500: Files in Documents -->", FileManager.default.urls(for: .documentDirectory) ?? "none") //Extension upgraded this to show directory folders.
        let array:[URL] = FileManager.default.urls(for: .documentDirectory)!  //?? "none"

        for i in 0...(array.count-1) {
            do {
                try FileManager.default.removeItem(atPath: array[i].path)
            } catch {
                print("JD500: Failed.")
            }
        }

//        guard
//            let path = FileManager
//                .default
//                .urls(for: .documentDirectory, in: .userDomainMask)
//                .first
//        else {
//            print("error getting path.")
//            return//return nil
//        }
    }
}


//struct SettingsSlideCard : View {
//    @State private var position = CardPosition.top
//    @State private var background = BackgroundStyle.blur
//
//
//    var body: some View {
//        ZStack(alignment: Alignment.top) {
//            VStack {
//                Picker(selection: self.$position, label: Text("Position")) {
//                    Text("Bottom").tag(CardPosition.bottom)
//                    Text("Middle").tag(CardPosition.middle)
//                    Text("Top").tag(CardPosition.top)
//                }.pickerStyle(SegmentedPickerStyle())
//                Picker(selection: self.$background, label: Text("Background")) {
//                    Text("Blur").tag(BackgroundStyle.blur)
//                    Text("Clear").tag(BackgroundStyle.clear)
//                    Text("Solid").tag(BackgroundStyle.solid)
//                }.pickerStyle(SegmentedPickerStyle())
//            }.padding().padding(.top, 25)
//            SlideOverCard($position, backgroundStyle: $background) {
//                VStack {
//                    Text("Slide Over Card").font(.title)
//                    Spacer()
//                }
//            }
//        }
//        .edgesIgnoringSafeArea(.vertical)
//    }
//
//}



//            Form {
//                Section() {
//                    // Toggle("Show Timer", isOn: $playNotificationSounds)
//                    // Toggle("Show Session Options", isOn: $sendReadReceipts)
//                    toggleSwitch()
//                }
//
//                Section(header: Text("Reset")) {
//                    //                Picker("Profile Image Size", selection: $profileImageSize) {
//                    //                    Text("Large")//.tag(ProfileImageSize.large)
//                    //                    Text("Medium")//.tag(ProfileImageSize.medium)
//                    //                    Text("Small")//.tag(ProfileImageSize.small)
//                    //                }
//                }
//            }
