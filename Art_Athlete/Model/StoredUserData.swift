//
//  StoredUserData.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-12.
//

import Foundation
import Combine

class StoredUserData: ObservableObject {

    @Published var storedFolderData : Data = Data()
    @Published var arrayOfFolderNames : [String] = []
    @Published var arrayOfFolderURLs : [String] = []
    @Published var storedFolderURL : URL//[URL]()

    @Published var arrayPhotoNames: [String] = []
    @Published var arrayPhotoURLs: [URL] = []  //
    @Published var arrayPhotoDownloadPath: [URL] = []

    @Published var bookmarksArray = [URL: Data]() {
        didSet {
            UserDefaults.standard.set(workingDirectoryBookmark, forKey: "bookmarksArray")
        }
    }

    @Published var folderPath: URL? {
        didSet {
            //.withoutImplicitSecurityScope
            do {
                let bookmark = try folderPath?.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
                UserDefaults.standard.set(bookmark, forKey: "bookmark")
            } catch let error as NSError {
                print("Set Bookmark Fails: \(error.description)")
            }
        }
    }



    @Published var workingDirectoryBookmark : Data {
        didSet {
            UserDefaults.standard.set(workingDirectoryBookmark, forKey: "workingDirectoryBookmark")
        }
    }

    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }

    @Published var isPrivate: Bool {
        didSet {
            UserDefaults.standard.set(isPrivate, forKey: "isAccountPrivate")
        }
    }

    @Published var url: URL {
        didSet {
            UserDefaults.standard.set(url, forKey: "url")
        }
    }

    //public var arraryUserURLs = []



    init() {
        self.username = UserDefaults.standard.object(forKey: "username") as? String ?? "sorry."
        self.workingDirectoryBookmark = UserDefaults.standard.object(forKey: "workingDirectoryBookmark") as? Data ?? Data.init()  
        self.url = UserDefaults.standard.object(forKey: "url") as? URL ?? URL(string: "n")!
      //  self.arrayPhotoURLs = UserDefaults.standard.object(forKey: "arrayPhotoURLs") as? [String] ?? ["none."]//as? URL ?? URL(string: "a")!

        self.storedFolderURL = UserDefaults.standard.object(forKey: "storedFolderURL") as? URL ?? URL(string: "nope")!

        self.storedFolderData = UserDefaults.standard.object(forKey: "storedFolderData") as? Data ?? Data()


        self.isPrivate = UserDefaults.standard.object(forKey: "isAccountPrivate") as? Bool ?? false
    }
}
