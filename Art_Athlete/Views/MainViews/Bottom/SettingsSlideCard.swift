//
//  SlideOverCard.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-04.
//

import SwiftUI
import SlideOverCard
import Files

struct ArtAthleteSettings : View {
    @Environment(\.colorScheme) var currentDarkLightMode
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var homeData: HomeViewModel
    let persistenceController = PersistenceController.shared


    @Binding var notifyMeAbout : Bool
    @Binding var playNotificationSounds : Bool
    @Binding var profileImageSize : Bool
    @Binding var sendReadReceipts : Bool

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
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                            Text("Done").foregroundColor(currentDarkLightMode == .dark ? Color.white : Color.black)
                        }
                    }).padding(.trailing, 10)
                    
//                    Button("Done") {
//                        prefs.showSettings = false
//                    }.padding(.trailing, 10).foregroundColor(.blue)//.alignmentGuide(.trailing, computeValue: { _ in 90 } )
                }
            }


            // Spacer()


        Form {

            Section() {
               // Toggle("Show Timer", isOn: $playNotificationSounds)
               // Toggle("Show Session Options", isOn: $sendReadReceipts)
                toggleSwitch()

            }

            Section(header: Text("Reset")) {
//                Picker("Profile Image Size", selection: $profileImageSize) {
//                    Text("Large")//.tag(ProfileImageSize.large)
//                    Text("Medium")//.tag(ProfileImageSize.medium)
//                    Text("Small")//.tag(ProfileImageSize.small)
//                }
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
                    resetUserStats()
                } label: {
                    HStack {
                        Image(systemName: "0.circle.fill")
                        Text("Reset All User Stats")
                    }
                }

                VStack {
                    Button("\(Image(systemName: "mail")) Email support: artathlete@icloud.com") {
                        self.showingMail.toggle()
                    }
                }
                .sheet(isPresented: $showingMail) {
                    MailComposeViewController(toRecipients: ["artathlete@icloud.com"], mailBody: "Art Athlete App Support") {
                        // Did finish action
                    }
                }

            }

        }

        }
    }
    //End view

    //Functions
    public func scanAllFolders() {
        homeData.folders.removeAll()
        Folder.documents?.subfolders.recursive.forEach { folder in
            homeData.folders.append(Product(title: folder.name, count: folder.files.count()))
        }
    }

    func resetUserStats() {
        persistenceController.clearDatabase() //.delete()
    }

    func deleteFilesInDirectory() {
        print("JD500: Files in Documents -->", FileManager.default.urls(for: .documentDirectory) ?? "none") //Extension upgraded this to show directory folders.
        let array:[URL] = FileManager.default.urls(for: .documentDirectory)!  //?? "none"


        //for i in 0...(FileManager.default.urls(for: .documentDirectory))!.count {
        for i in 0...(array.count-1) {
            do {
                try FileManager.default.removeItem(atPath: array[i].path)
            } catch {
                print("JD500: Failed.")
            }
        }

//        do {
//            ForEach(FileManager.default.urls(for: .documentDirectory)) { folder in
//                try FileManager.default.removeItem(atPath: folder)
//            }
//     //       try FileManager.default.removeItem(atPath: FileManager.default.urls(for: .documentDirectory))
//        } catch {
//            print("JD451: THIS WORKS, but it does NOT delete the document directory. Just everything inside of it. ••••••\n", error)
//        }


        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first
                // .appendingPathComponent("\(name)")
        else {
            print("error getting path.")
            return//return nil
        }

        print("JD500: path  → ", path)

//        do {
//            try FileManager.default.removeItem(atPath: path.path)
//        } catch {
//            print("JD451: THIS WORKS, but it does NOT delete the document directory. Just everything inside of it. ••••••\n", error)
//        }



        print("JD500: Files in Documents -->", FileManager.default.urls(for: .documentDirectory) ?? "none") //Extension upgraded this to show directory folders.
        //  return path
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

