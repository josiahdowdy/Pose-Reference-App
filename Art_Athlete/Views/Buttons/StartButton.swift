//
//  StartButton.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-15.
//

import SwiftUI

struct StartButton: View {
    @ObservedObject var userSettings = StoredUserData()
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    @Environment(\.managedObjectContext) var context

    var cdFolders: FetchedResults<PhotoFolders>

    @State var url : URL = URL(fileURLWithPath: "nil")
    @State var isRandom: Bool = true

    @State var testUrlResourceKey = Set<URLResourceKey>()
    
    /*.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.*/
    var body: some View {
            Button("Start \(Image(systemName: "play.rectangle.fill"))") {
                loadBookmarkedPhotos()
                //MultipleSelectRow(cdFolders: cdFolders).loadSelectedPhotos() //loadSelectedBookmarkedPhotos()
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
            prefs.localPhotos = true
            prefs.disableSkip = false
            timeObject.timeChosen = Double(prefs.time[prefs.selectorIndexTime]) //Double(prefs.time[prefs.selectorIndexTime])!

            startTimer()
            prefs.startSession = true
        }
    }



    private func restoreFileAccess(with bookmarkData: Data) -> URL? {
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
    }

    private func saveBookmarkData(for workDir: URL) { //URL //for workDir: URL //[URL: Data]
//        testUrlResourceKey
        do {
            let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: testUrlResourceKey, relativeTo: nil)
            //userSettings.workingDirectoryBookmark = bookmarkData
            userSettings.arrayWorkingDirectoryBookmark.append(bookmarkData)
        } catch {
            print("Failed to save bookmark data for \(workDir)", error)
        }
    }


    private func loadBookmarkedPhotos() {
        //for photo in userSettings.arrayWorkingDirectoryBookmark {
        //prefs.arrayOfURLStringsTEMP = restoreFileAccessArray(with: (userSettings.arrayWorkingDirectoryBookmark))!

        print("JD84:", prefs.arrayOfURLStringsTEMP)

        //MARK: - Loads in array of photos.
        for i in 0..<userSettings.arrayWorkingDirectoryBookmark.count {

            url = restoreFileAccess(with: userSettings.arrayWorkingDirectoryBookmark[i])!

            //FIXME: BOOKMARK URL IS WORKING. NOW, ADD IT TO AN ARRAY.
            if (url.startAccessingSecurityScopedResource()) {
                prefs.arrayOfURLStrings.append(String(describing: url))
                //print("JD68: LOADING BOOKMARK. \(prefs.arrayOfURLStrings)")
            } else {
                print("JD67: False")
            }
        }
        url.stopAccessingSecurityScopedResource()

        print("\nLOADING BOOKMARK DONE ------------------------------------")
    } //End func.
  

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
          //  userSettings.workingDirectoryBookmark = bookmarkData
            //print("JD22: \(userSettings.workingDirectoryBookmark)")

            userSettings.arrayWorkingDirectoryBookmark.append(bookmarkData)

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
