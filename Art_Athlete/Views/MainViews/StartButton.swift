//
//  StartButton.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-15.
//

import SwiftUI
import Files

struct StartButton: View {
    @ObservedObject var storedUserData = StoredUserData()
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    @Environment(\.managedObjectContext) var context
    @ObservedObject var folderArrayModel: FoldersArrayModel
    @AppStorage("storedFileURLs") var storedFileURLs: [[URL]] = [[]]
    @AppStorage("arrayOfFolderNames") var arrayOfFolderNames: [String] = []

    @State var url : URL = URL(fileURLWithPath: "nil")
    @State var isRandom: Bool = true

    @State var testUrlResourceKey = Set<URLResourceKey>()
    @Binding var rowSelection: Set<String>
    
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: VIEW
    var body: some View {
            Button("Start \(Image(systemName: "play.rectangle.fill"))") {
             //   async { await ... }
               // loadBookmarkedPhotos()
              //  onlyLoadSelectedPhotos()
                loadFolderFiles()
                startSession()
            }
            .keyboardShortcut(.defaultAction)
            .padding(20)
            .padding(.bottom, 20) //.buttonStyle(ButtonOnOffStyle())
    } //END UI View.

    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    //MARK: - Functions
    //Don't confuse with start timer in Timer.swift
    private func startTimer() {
        timeObject.isTimerRunning = true
        timeObject.startTime = Date()
        timeObject.progressValue = 0.0
        timeObject.timeDouble = 0.0
        TimerView(timeObject: _timeObject, prefs: _prefs).startTimer() //, startSession: $startSession
        let newSession = UserData(context: context)
        newSession.date = Date()
    }

    func startSession(){
        print("JD01 : loadLocalPhotos() : \(prefs.arrayOfURLStrings)")
        print("JD20: \(prefs.arrayOfURLStrings.count)")

        if (prefs.arrayOfURLStrings.count < prefs.homeManyPhotosToDraw[prefs.selectorCountTime]) {
            prefs.sPoseCount = prefs.arrayOfURLStrings.count
        } else {
            prefs.sPoseCount = prefs.homeManyPhotosToDraw[prefs.selectorCountTime]
        }

        if (isRandom) {
            prefs.arrayOfURLStrings.shuffle()
        }

        if (prefs.arrayOfURLStrings.isEmpty) {
            prefs.error = "Error loading images..." //Error Oct16 HomeView().error
        } else {
            //prefs.startBoolean.toggle()
            prefs.error = ""
            prefs.sURL = prefs.arrayOfURLStrings[0]
            print("JD500: prefs.sURL --> ", prefs.sURL)
            prefs.localPhotos = true
            prefs.disableSkip = false
            timeObject.timeChosen = Double(prefs.time[prefs.selectorIndexTime]) //Double(prefs.time[prefs.selectorIndexTime])!

            startTimer()
            prefs.startSession = true
        }
    }

    func loadFolderFiles() {
        //  for selectedItem in self.rowSelection{
        print("JD452: loadFolderfiles ")
        do {
            for i in folderArrayModel.folderArray {
                print("JD452: ", i.isToggle)

                if (i.isToggle) {
                    let loadFolderURL = try Folder.documents!.subfolder(named: i.name)
                    for file in try Folder(path: loadFolderURL.path).files {

                        // for file in try Folder(path: Folder.documents!.path).files {
                        prefs.arrayOfURLStrings.append(file.url.absoluteString)
                        //print(file.name)
                    }
                }
                //    print("JD452", loadFolderURL)
                //  let url = URL(string: "https://www.hackingwithswift.com")
                //let targetFolder = try Folder(path: "/users/john/folderB")

                //                Folder.documents!.subfolders.recursive.forEach { folder in
                //                    let newFolder = FoldersModel(name: folder.name)
                //                    folderArrayModel.folderArray.append(newFolder)
                //                }
            }
        } catch {
            print("JD452: error loading files from download folder.", error)
        }

        print("JD452: ", prefs.arrayOfURLStrings)
    }

    func onlyLoadSelectedPhotos() {
        /// 1. Take the array of selected photos.
        ///     - Get it from "MultipleSelectRow"
        ///         - Get the array # 
        ///      - Theoretically, permission is already granted to files? Do I need to still pull it from another array?
        ///
        /// 2a. If I need permission:
        ///     - Scan the stored array for the matching selected photo URLs
        ///
        /// 2b. If I don't need permssion:
        /// 3. Append it to prefs.arrayOfURLStrings
        print("JD402: ", storedFileURLs)

  //     if !(storedFileURLs.isEmpty) { prefs.arrayOfURLStrings.append(String(describing: url)) }

        for selectedItem in self.rowSelection{
            if arrayOfFolderNames.contains(selectedItem) {
                let index = arrayOfFolderNames.firstIndex(of: selectedItem)

                print("\n •••••••••••• Next row in array.")

                for y in 0..<storedFileURLs[index!].count {
                    let url = storedFileURLs[index!][y]
                    print("JD406: ", storedFileURLs[index!][y])
                   // if (url.startAccessingSecurityScopedResource()) {
                        //prefs.arrayOfURLStrings.append(String(describing: storedFileURLs[index!][y]))
                    prefs.arrayOfURLStrings.append(String(describing: url))
                    prefs.arrayOfURLStringsTEMP.append(url.absoluteURL)
                 //   }
                 //   url.stopAccessingSecurityScopedResource()
                }

                ///Loop through entire 2D array.
//                for x in 0..<storedFileURLs.count {
//                    for y in 0..<storedFileURLs[x].count {
//                        prefs.arrayOfURLStrings.append(String(describing: storedFileURLs[x][y]))
//                    }
//                   // prefs.arrayOfURLStrings.append(String(describing: storedFileURLs[i]))
//                }
            }
        }
        print("JD403: ", prefs.arrayOfURLStrings)
    }

 /*   private func restoreFileAccessArray(with bookmarkData: [Data], relativeTo: URL) -> [URL]? {
        var arrayLoadedURLs: [URL]
        do {


            var isStale = false
            arrayLoadedURLs.append(try URL(resolvingBookmarkData: bookmarkData[0], relativeTo: nil, bookmarkDataIsStale: &isStale))
            //let url
            if isStale {
                // bookmarks could become stale as the OS changes
                print("Bookmark is stale, need to save a new one... ")
                saveBookmarkData(for: url)
            }
            return [url]
        } catch {
            print("Error resolving bookmark:", error)
            return nil
        }
    } */ //End func.


    private func loadBookmarkedPhotos() {
        //for photo in storedUserData.arrayWorkingDirectoryBookmark {
        //prefs.arrayOfURLStringsTEMP = restoreFileAccessArray(with: (storedUserData.arrayWorkingDirectoryBookmark))!

        //print("JD84:", prefs.arrayOfURLStringsTEMP)

        print("I can store about 5,000 photos safely, that will equal about 512kb of data. Otherwise may slow down app. But I can also add a loading button dial on start click. Assuming this is stored locally?")
        print("JD1000: arrayWorkingDirectoryBookmark SIZE --> ", storedUserData.arrayWorkingDirectoryBookmark)

//        var testArray: [URL]
//        var x = 0
//
//        for i in prefs.arrayOfURLStringsTEMP {
//            testArray = restoreFileAccessArray(with: storedUserData.arrayWorkingDirectoryBookmark, relativeTo: prefs.arrayOfURLStringsTEMP[x])!
//            x += 1
//        }


        //MARK: - Loads in array of photos.
        for i in 0..<storedUserData.arrayWorkingDirectoryBookmark.count {
         //   storedUserData.arrayWorkingDirectoryBookmark. //kCFURLPathKey

            print("JD410: ", storedUserData.arrayWorkingDirectoryBookmark[i])

            url = restoreFileAccess(with: storedUserData.arrayWorkingDirectoryBookmark[i])!

            //MARK: IS NEEDED.
              if (url.startAccessingSecurityScopedResource()) {
               // prefs.arrayOfURLStrings.append(String(describing: url))
                //print("JD68: LOADING BOOKMARK. \(prefs.arrayOfURLStrings)")
            } else {
                print("JD67: False")
            }
        }
        url.stopAccessingSecurityScopedResource()
        print("\nLOADING BOOKMARK DONE ------------------------------------")
    } //End func.

    private func restoreFileAccess(with bookmarkData: Data) -> URL? { //, relativeTo: URL
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmarkData, relativeTo: nil, bookmarkDataIsStale: &isStale)

            if isStale {
                // bookmarks could become stale as the OS changes
                print("Bookmark is stale, need to save a new one... ")
                saveBookmarkData(for: url)
            }
            return url
        } catch {
            print("Error resolving bookmark:", error)
            return nil
        }
    } //End func.

    private func saveBookmarkData(for workDir: URL) { //URL //for workDir: URL //[URL: Data]
//        testUrlResourceKey
        do {
            let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: testUrlResourceKey, relativeTo: nil)
            //storedUserData.workingDirectoryBookmark = bookmarkData
            storedUserData.arrayWorkingDirectoryBookmark.append(bookmarkData)
        } catch {
            print("Failed to save bookmark data for \(workDir)", error)
        }
    }



  

    //MARK: - Array Bookmarks.
    /*
    private func restoreFileAccessArray(with bookmarkData: [Data]) -> [URL]? {
        /* //FIXME: - Apple docs.
         resourceValues(forKeys: [URLResourceKey], fromBookmarkData: Data) -> [URLResourceKey : Any]?
         */
        do {
            var isStale = false
         //   let url = try URL(resolvingBookmarkData: [bookmarkData], relativeTo: nil, bookmarkDataIsStale: &isStale)

            var urls = [Data]()
           // urls += URL(resolvingBookmarkData: bookmarkData, relativeTo: nil, bookmarkDataIsStale: &isStale)
           // let url = try URL(resourceValues(forKeys: [bookmarkData], fromBookmarkData: Data) -> [URLResourceKey : Any]?)

            if isStale {
                // bookmarks could become stale as the OS changes
                print("Bookmark is stale, need to save a new one... ")
                saveBookmarkData(for: url)
            }
            return [url]
        } catch {
            print("Error resolving bookmark:", error)
            return nil
        }
    } //end func.


    private func saveBookmarkDataArray(for workDir: [URL]) { //URL //for workDir: URL //[URL: Data]
        do {
            let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: nil, relativeTo: nil)

            // save in UserDefaults
          //  storedUserData.workingDirectoryBookmark = bookmarkData
            //print("JD22: \(storedUserData.workingDirectoryBookmark)")

            storedUserData.arrayWorkingDirectoryBookmark.append(bookmarkData)

        } catch {
            print("Failed to save bookmark data for \(workDir)", error)
        }
    } */


} //End Struct.

//struct StartButton_Previews: PreviewProvider {
//    static var previews: some View {
//        StartButton()
//    }
//}
