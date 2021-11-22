import SwiftUI

struct DotMenuView: View {
    @EnvironmentObject var prefs: GlobalVariables
    
    //@Binding var unsplashPhotos: Bool
   //@Binding var localPhotos: Bool
    @Binding var showStats: Bool
    @Binding var showSettings: Bool
    
    @State private var checked = false
    
    var body: some View {
        Group {
            HStack{
                Menu {
                    /*
                    Button("Unsplash Photos") {
                        unsplashPhotos.toggle()
                        localPhotos.toggle()
                    }
                    Button("Local Photos") {
                        localPhotos.toggle()
                        unsplashPhotos.toggle()
                    } */
                    Button("Memorize") {
                        //self.error = "Memorize on: photo interval of 2 seconds on and 3 seconds off."
                    }
                    Button("Stats") {
                        showStats.toggle()
                    }
                    Button("Settings") {
                        showSettings.toggle()
                    }
                    Button("Hide Timer") {
                        prefs.hideTimer.toggle()
                    }
                    NavigationView {
                        NavigationLink(destination: Text("SecretTunnel")) {
                            Text("Hello, World!")
                        }
                        .navigationTitle("Navigation")
                    }
                    HStack {
                        CheckBoxView(checked: $checked)
                        //Spacer()
                        Text("Show Timer")
                    }
                    
                } label: {
                    Label("", systemImage: "line.horizontal.3.circle")
                }
                
                Spacer()
                
                /*
                Menu {
                    Button("Stats \(Image(systemName: "percent")) ") {
                        self.showStats.toggle()
                    }.sheet(isPresented: $showStats) {
                        //StatsView(timeObject: _timeObject, prefs: _prefs, userObject: _userObject)
                        return StatsView()//(isPresented: $showingSheet)
                            .environmentObject(self.userObject)
                            .environmentObject(self.prefs)
                            .environmentObject(self.timeObject)
                    }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    
                    //Load Photos Button
                    Button("\(Image(systemName: "folder.fill")) Load Photos") {
                        self.showStats.toggle()
                    }.sheet(isPresented: $showStats) {
                        //StatsView(timeObject: _timeObject, prefs: _prefs, userObject: _userObject)
                        return StatsView()//(isPresented: $showingSheet)
                            .environmentObject(self.userObject)
                            .environmentObject(self.prefs)
                            .environmentObject(self.timeObject)
                    }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    
                    //Spacer()
                    
                    //Settings
                    Button("\(Image(systemName: "gearshape.fill")) Settings") {
                        self.showSettings.toggle()
                    }.sheet(isPresented: $showSettings) {
                        //StatsView(timeObject: _timeObject, prefs: _prefs, userObject: _userObject)
                        return SettingsView()//(isPresented: $showingSheet)
                            .environmentObject(self.userObject)
                            .environmentObject(self.prefs)
                            .environmentObject(self.timeObject)
                    }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                } label: {
                    Label("", systemImage: "gearshape.fill")
                }
 */
             
            }
        }
    }
}
