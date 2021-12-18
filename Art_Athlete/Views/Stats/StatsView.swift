/*
 Josiah - Oct 29, 2020
 When user presses 'Stats' then this sheet is opened.
 It shows the user drawing records.
*/

import SwiftUI
//import Kingfisher

struct ToggleStates {
    var oneIsOn: Bool = false
    var twoIsOn: Bool = true
}


struct StatsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var timeObject: TimerObject
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var userObject: UserObject

    @State private var showingSheet = false
    @State private var showingMainMenu = false

    @State private var toggleStates = ToggleStates()
    @State private var topExpanded: Bool = false
    @State private var userStatsExpanded: Bool = false

    var userStats : FetchedResults<UserData>

    @FetchRequest(entity: UserData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserData.countPoses, ascending: false)]) var fetchAllPosesCount: FetchedResults<UserData>

    var sumPoses: Int16 {
        fetchAllPosesCount.reduce(0) { $0 + $1.countPoses }
    }

    @FetchRequest(entity: UserData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserData.timeDrawn, ascending: false)]) var fetchTotalTimeDrawn: FetchedResults<UserData>

    var sumTimeDrawn: Int16 {
        fetchTotalTimeDrawn.reduce(0) { $0 + $1.timeDrawn }
    }

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    var body: some View {
        VStack(alignment: .center) {
            Group {
                Text("Drawing Summary").font(.largeTitle)
                //Text("\(userObject.userName)").font(.headline).padding(.top, 10)
                //Text("\(Image(systemName: "clock"))   Session Length: \(userObject.totalTimeDrawn)").padding(.top, 10)
              //  Text("\(Image(systemName: "clock"))   Draw time: \(userObject.totalTimeDrawn ?? 999)").padding(.top, 10)


                Text("\(Image(systemName: "clock"))   Total Draw time: \((sumTimeDrawn/60)) minutes").padding(.top, 10)

                Text("\(Image(systemName: "pencil.and.outline"))   Poses drawn: \(sumPoses)").padding(.top, 10)

                //Text("\(Image(systemName: "pencil.and.outline"))   Poses drawn: \(userObject.totalPosesDrawn)").padding(.top, 10)
                //Text("\(Image(systemName: "clock"))   Avg time per pose: ").padding(.top, 10)

//                DisclosureGroup("Certificates", isExpanded: $topExpanded) {
//                    CertificateView()
//                    Toggle("Toggle 1", isOn: $toggleStates.oneIsOn)
//                    Toggle("Toggle 2", isOn: $toggleStates.twoIsOn)
//                    DisclosureGroup("Sub-items") {
//                        Text("Sub-item 1")
//                    }
//                }

            }.padding(.horizontal, 20)



            /*
                HStack {
                    Button(action: {
                        //self.showingSheet.toggle()
                        //presentationMode.wrappedValue.dismiss()
                        self.showingSheet = true
                    }) {
                        Text("\(Image(systemName: "info.circle.fill")) \(25 - fetchTotalTimeDrawn) hours till \("usersStats.currectCert") certificate reached.")

                        //Text("\(Image(systemName: "info.circle.fill")) \(25 - userObject.totalTimeDrawn) hours till \(userObject.currectCert) certificate reached.")//Image(systemName: "multiply.circle.fill")//Text("Quit")
                    }.sheet(isPresented: $showingSheet) {
                       // CertificateView()
                        return CertificateView()
                            .environmentObject(self.userObject)
                            .environmentObject(self.prefs)
                            .environmentObject(self.timeObject)
                    }
                    .buttonStyle(BorderlessButtonStyle()).padding(.top, 20)
                    //.font(.callout)
                    .padding(.top, 50)
                }.padding(.horizontal, 20)
            */
            Group {
              //  Text("\(Image(systemName: "asterisk.circle")) Only 1 hr max a day is applied toward certificate time to help build a daily drawing habit.\n").font(.footnote).padding(.top, 10)
                
                Text("\(Image(systemName: "text.quote")) \"Amateurs sit and wait for inspiration. \nThe rest of us just get up and go to work.\n - Stephen King").font(.footnote).padding(.top, 10)//.font(.caption).padding(.top, 50)
 
                    Button("Main Menu") {
                        self.presentationMode.wrappedValue.dismiss()
                    }.padding(.top, 20)
            }.padding(.horizontal, 20)
        }
    } //End UI

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: - FUNCTIONS
}

