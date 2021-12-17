//
//  SlideOverCard.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-04.
//

import SwiftUI
import SlideOverCard

struct ArtAthleteSettings : View {

    @EnvironmentObject var prefs: GlobalVariables

    @Binding var notifyMeAbout : Bool
    @Binding var playNotificationSounds : Bool
    @Binding var profileImageSize : Bool
    @Binding var sendReadReceipts : Bool



    var body: some View {
        VStack {
            HStack {
                Text("Settings")//.font(.title)
                    .bold()
                    .foregroundColor(Color("ColorAccentWhite"))
                    .background(Color("ColorGrayTwo"))
                    .cornerRadius(2)
                    .font(.subheadline)
                //    .alignmentGuide(.center, computeValue: { _ in 90 } )
                Button("Done") {
                    prefs.showSettings = false
                }.alignmentGuide(.trailing, computeValue: { _ in 90 } )

//                Button(action: {
//                    self.locationManager.requestAlwaysAuthorization()
//                    // self.locationManager.requestWhenInUseAuthorization()
//                }) {
//                    Text("Request authorization")
//                }
            }

            toggleSwitch()

            Spacer()
        }
        
        Form {
            Section(header: Text("Notifications")) {
                Picker("Notify Me About", selection: $notifyMeAbout) {
                    Text("Direct Messages")//.tag(NotifyMeAboutType.directMessages)
                    Text("Mentions")//.tag(NotifyMeAboutType.mentions)
                    Text("Anything")//.tag(NotifyMeAboutType.anything)
                }
                Toggle("Play notification sounds", isOn: $playNotificationSounds)
                Toggle("Send read receipts", isOn: $sendReadReceipts)
            }
            Section(header: Text("User Profiles")) {
                Picker("Profile Image Size", selection: $profileImageSize) {
                    Text("Large")//.tag(ProfileImageSize.large)
                    Text("Medium")//.tag(ProfileImageSize.medium)
                    Text("Small")//.tag(ProfileImageSize.small)
                }
                Button {
                    deleteFilesInDirectory()
                } label: {
                    HStack {
                        Image(systemName: "trash.circle")
                        Text("Delete All Photos")
                    }

                }
                Text("Files").font(.title3)
            }
        }
    }
    //End view

    //Functions
    func deleteFilesInDirectory() {
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

        do {
            try FileManager.default.removeItem(atPath: path.path)
        } catch {
            print("JD451: THIS WORKS, but it does NOT delete the document directory. Just everything inside of it. ••••••\n", error)
        }

        print("JD451: Files in Documents -->", FileManager.default.urls(for: .documentDirectory) ?? "none") //Extension upgraded this to show directory folders.
        //  return path
    }
}


struct SettingsSlideCard : View {
    @State private var position = CardPosition.top
    @State private var background = BackgroundStyle.blur


    var body: some View {
        ZStack(alignment: Alignment.top) {
            VStack {
                Picker(selection: self.$position, label: Text("Position")) {
                    Text("Bottom").tag(CardPosition.bottom)
                    Text("Middle").tag(CardPosition.middle)
                    Text("Top").tag(CardPosition.top)
                }.pickerStyle(SegmentedPickerStyle())
                Picker(selection: self.$background, label: Text("Background")) {
                    Text("Blur").tag(BackgroundStyle.blur)
                    Text("Clear").tag(BackgroundStyle.clear)
                    Text("Solid").tag(BackgroundStyle.solid)
                }.pickerStyle(SegmentedPickerStyle())
            }.padding().padding(.top, 25)
            SlideOverCard($position, backgroundStyle: $background) {
                VStack {
                    Text("Slide Over Card").font(.title)
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }

}

