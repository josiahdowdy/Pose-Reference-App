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

    @State var url : URL = URL(fileURLWithPath: "nil")
    @State var isRandom: Bool = true

    var body: some View {
            Button("Start \(Image(systemName: "play.rectangle.fill"))") {
                loadBookmarkedPhotos()
                 loadLocalPhotos()
            }
            .keyboardShortcut(.defaultAction)
            .padding(20)
            .padding(.bottom, 20) //.buttonStyle(ButtonOnOffStyle())
    } //END UI View.

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

    func loadLocalPhotos(){
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

    //private func restoreFileAccess(with bookmarkData: Data) -> URL? { //[URL: Data]) -> URL? {
    private func restoreFileAccess(with bookmarkData: Data) -> URL? {
        do {
            var isStale = false

            //            for url in bookmarkData {
            //                let url2 = try URL(resolvingBookmarkData: bookmarkData[url], relativeTo: nil, bookmarkDataIsStale: &isStale)
            //
            //            }
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
        do {
            let bookmarkData = try workDir.bookmarkData(includingResourceValuesForKeys: nil, relativeTo: nil)

            // save in UserDefaults
            userSettings.workingDirectoryBookmark = bookmarkData
            //print("JD22: \(userSettings.workingDirectoryBookmark)")

            userSettings.arrayWorkingDirectoryBookmark.append(bookmarkData)

        } catch {
            print("Failed to save bookmark data for \(workDir)", error)
        }
    }

    private func loadBookmarkedPhotos() {
        //MARK:
        //--> WORKING FOR SINGLE PHOTOURL -->  url = restoreFileAccess(with: userSettings.workingDirectoryBookmark)!

        //prefs.arrayOfURLStringsTEMP.removeAll()

        //for photo in userSettings.arrayWorkingDirectoryBookmark {
        for i in 0..<userSettings.arrayWorkingDirectoryBookmark.count {
            url = restoreFileAccess(with: userSettings.arrayWorkingDirectoryBookmark[i])!

            //FIXME: BOOKMARK URL IS WORKING. NOW, ADD IT TO AN ARRAY.
            if (url.startAccessingSecurityScopedResource()) {
                print("JD67: TRUE")
                prefs.arrayOfURLStrings.append(String(describing: url))
                print("JD68: prefs.arrayOfURLStrings \(prefs.arrayOfURLStrings)")
            } else {
                print("JD67: False")
            }
        }
    }
}

struct StartButton_Previews: PreviewProvider {
    static var previews: some View {
        StartButton()
    }
}
