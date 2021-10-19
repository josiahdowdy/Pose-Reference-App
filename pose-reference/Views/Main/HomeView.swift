import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    @EnvironmentObject var prefs: Settings
    @EnvironmentObject var timeObject: TimerObject
    //@EnvironmentObject var userObject: UserObject
    
    @State private var showStats = false
    @State private var showSettings = false
    
    @State var name = ""
    @State var error = ""
    //@State var wifiError = ""
    @State var isImporting: Bool = false
    @State var fileName = "" //To save file URL in.
    
    var body: some View {
        VStack(alignment: .center) {
            //This is the top right settings menu.
            DotMenuView(unsplashPhotos: $prefs.unsplashPhotosView,localPhotos: $prefs.localPhotosView, showStats: $showStats, showSettings: $showSettings)
            
                .sheet(isPresented: $showStats) {
                    return StatsView()
                        //.environmentObject(self.userObject)
                        .environmentObject(self.prefs)
                        .environmentObject(self.timeObject)
                }
                .sheet(isPresented: $showSettings) {
                    return SettingsView()
                      //  .environmentObject(self.userObject)
                        .environmentObject(self.prefs)
                        .environmentObject(self.timeObject)
                }
            
            Text("Art Athlete").font(.largeTitle).padding(.top, 20)
            Text("\(prefs.userName)").padding(.top, 10) //the artist
            // Button("\(Image(systemName: "gearshape.fill"))")
            //Text("Poses drawn today: \(userObject.totalPosesDrawnToday)").padding(.top, 10)
            
            Text(prefs.error)

            /// Import local photos
            if (prefs.localPhotosView) {
                Button(action: {
                    isImporting = false
                    
                    //fix broken picker sheet
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isImporting = true
                    }
                }, label: {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                        
                        Text("Files: \(prefs.sPoseCount)")
                            .font(.headline)
                    }.padding(6)
                    
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    //.padding(.horizontal)
                })
            }
        } //End of Vstack
        .padding()
        .fileImporter(
            isPresented: $isImporting, allowedContentTypes: [UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
            allowsMultipleSelection: true,
            onCompletion: { result in
                do {
                    let selectedFiles = try result.get()
                    prefs.sPoseCount = selectedFiles.count
                    
                    for i in 0...(selectedFiles.count-1) { //selectedFiles.count
                        //print("\n\(i)") //This prints out the photo data
                        saveFile(url: selectedFiles[i])
                    }
                    self.error = ""
                } catch { print("failed") }
            })
        .toolbar {
            Menu("Action") {
            }
        }
        
        Spacer() //Space in Vstack to the button for files
    } //End of HStack
    
    
    func saveFile (url: URL) {
        var actualPath: URL
        
        if (CFURLStartAccessingSecurityScopedResource(url as CFURL)) { // <- here
            
            let fileData = try? Data.init(contentsOf: url)
            let fileName = url.lastPathComponent
            
            actualPath = getDocumentsDirectory().appendingPathComponent(fileName)
            
            // print("\nactualPath = \(actualPath)\n") //Prints out the actual path.
            do {
                try fileData?.write(to: actualPath)
                prefs.arrayOfURLStrings.append(String(describing: actualPath))
                //print("\nString: arrayOfURLStrings: \n\(prefs.arrayOfURLStrings)\n")
                if(fileData == nil){
                    print("Permission error!")
                }
                else {
                    //print("Success.")
                }
            } catch {
                print(error.localizedDescription)
            }
            CFURLStopAccessingSecurityScopedResource(url as CFURL) // <- and here
            
        }
        else {
            print("Permission error!")
        }
        
        func getDocumentsDirectory() -> URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    } //End of struct
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Settings())
            .environmentObject(TimerObject())
        //.environmentObject(UserObject())
    }
}


/*
 
 ///Wifi message
 if !(error.isEmpty) {
 //Text(error)
 if !(prefs.localPhotosView) { //|| !(unsplashPhotos))
 // Text("\(Image(systemName: "wifi.exclamationmark")) \(wifiError)").font(.footnote).padding(20) //xmark.octagon.fill
 //Text(wifiError)
 }
 }
 
 */
