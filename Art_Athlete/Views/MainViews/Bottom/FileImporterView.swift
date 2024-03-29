import SwiftUI
import UniformTypeIdentifiers

struct FileImporterView: View {
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    //@EnvironmentObject var userObject: UserObject

    @State var name = ""
    @State var error = ""
    //@State var wifiError = ""
    @State var isImporting: Bool = false
    @State var fileName = "" //To save file URL in.

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //START VIEW
    var body: some View {
        VStack(alignment: .center) {
            //Text("Art Athlete").font(.largeTitle).padding(.top, 20)
            //Text("\(prefs.userName)").padding(.top, 10) //the artist
            // Button("\(Image(systemName: "gearshape.fill"))")
            //Text("Poses drawn today: \(userObject.totalPosesDrawnToday)").padding(.top, 10)
            
            Text(prefs.error)
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
                }
                .cornerRadius(40)
                .padding(2)
                .background(Color.blue)
                .foregroundColor(.white)
            })
        } //End of Vstack
        //.padding()
        .fileImporter(
            isPresented: $isImporting, allowedContentTypes: [UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
            allowsMultipleSelection: true,
            onCompletion: { result in
                do {
                    let selectedFiles = try result.get()

//                    if (selectedFiles.count < prefs.time[prefs.selectorIndexTime]) {
//                        prefs.sPoseCount = selectedFiles.count
//                    } else {
//                        prefs.sPoseCount = prefs.time[prefs.selectorIndexTime]
//                    }

                    for i in 0...(selectedFiles.count-1) { //selectedFiles.count
                        //print("\n\(i)") //This prints out the photo data
                        saveFile(url: selectedFiles[i])
                    }
                    self.error = ""
                } catch { print("failed") }
            })
       
        
        Spacer() //Space in Vstack to the button for files
    } //---------------------------End of HStack------------------------------------------------------------------------------------------------
    
    //---------------------------FUNCTIONS----------------------------------------------------------------
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
                print("Josiah1: \(error.localizedDescription)")
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

struct FileImporterView_Previews: PreviewProvider {
    static var previews: some View {
        FileImporterView()
            .environmentObject(GlobalVariables())
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
