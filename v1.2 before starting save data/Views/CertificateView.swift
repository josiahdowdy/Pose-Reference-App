/*
 Josiah - Oct 29, 2020
 When user presses 'i' in Stats then this sheet is opened.
 It shows the user certificates & allows them to save it.
 
 User can upload best sketch to place as background of a certificate?
*/

import SwiftUI
import KingfisherSwiftUI

struct CertificateView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: Settings
    @EnvironmentObject var userObject: UserObject
 
    @State private var showingSheet = false

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Certificates").font(.largeTitle)
                Text("\(userObject.userName)").font(.headline).padding(.top, 10)
                HStack {
                    Text("\(Image(systemName: "tortoise"))   Beginner: \(userObject.totalTimeDrawn)/25").padding(.top, 10)
                    Spacer()
                    Button("Download") {
                        //code
                    }.disabled(userObject.beginnerCert)
                }
                HStack {
                    Text("\(Image(systemName: "ant"))   Habit builder: \(userObject.totalTimeDrawn)/75").padding(.top, 10)
                    Spacer()
                    Button("Download") {
                        //code
                    }.disabled(userObject.beginnerCert)
                }
                HStack {
                    Text("\(Image(systemName: "bolt.fill"))   Intermediate: \(userObject.totalTimeDrawn)/125").padding(.top, 10)
                    Spacer()
                    Button("Download") {
                        //code
                    }.disabled(userObject.beginnerCert)
                }
                HStack {
                    Text("\(Image(systemName: "flame"))   Advanced: \(userObject.totalTimeDrawn)/300").padding(.top, 10)
                    Spacer()
                    Button("Download") {
                        //code
                    }.disabled(userObject.beginnerCert)
                }
            }
            Group {
                HStack {
                    Text("\(Image(systemName: "paintpalette.fill"))   Master: \(userObject.totalTimeDrawn)/500").font(.callout).padding(.top, 10)
                    Spacer()
                    Button("Download") {
                        //code
                    }.disabled(userObject.beginnerCert)
                }
                HStack {
                    Text("\(Image(systemName: "wand.and.stars"))   You're a wizard Harry: \(userObject.totalTimeDrawn)/1000").font(.callout).padding(.top, 10)
                    Spacer()
                    Button("Download") {
                        //code
                    }.disabled(userObject.beginnerCert)
                }
                
            }
            
            Group {
                Text("\(Image(systemName: "info.circle.fill")) Only 1 hr max a day is applied toward certificate time to help build a daily drawing habit.")
                    .font(.footnote).padding(.top, 10)
                
                Button("Back") {
                    self.presentationMode.wrappedValue.dismiss()
                }.buttonStyle(BorderlessButtonStyle()).padding(20)
            }
        }.padding(.horizontal, 20)
    }
}
