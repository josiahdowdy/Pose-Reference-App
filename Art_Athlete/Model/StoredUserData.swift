//
//  StoredUserData.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-12.
//

import Foundation
import Combine

@MainActor
class StoredUserData: ObservableObject {

    @Published var arrayWorkingDirectoryBookmark : [Data] {
        didSet {
            UserDefaults.standard.set(arrayWorkingDirectoryBookmark, forKey: "arrayWorkingDirectoryBookmark")
        }
    }

    //@Published var recoveredURL : URL

    @Published var showPhoto : Bool = false
    @Published var storedFolderData : Data = Data()
    @Published var arrayOfFolderNames : [String] = []
    @Published var arrayOfFolderURLs : [String] = []
    @Published var storedFolderURL : URL//[URL]()

    @Published var arrayPhotoNames: [String] = []
    @Published var savedFileURLs: [URL] = []  //
    @Published var arrayPhotoDownloadPath: [URL] = []
    @Published var photo : Data = Data() //= UIImage()
    @Published var photoArray : [Data] = [] //= UIImage()



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

//    @Published var fileURL: URL {
//        return URL(fileURLWithPath: workingDirectoryBookmark)
//    }

    //public var arraryUserURLs = []



    init() {
        self.username = UserDefaults.standard.object(forKey: "username") as? String ?? "sorry."

        self.workingDirectoryBookmark = UserDefaults.standard.object(forKey: "workingDirectoryBookmark") as? Data ?? Data.init()
        self.arrayWorkingDirectoryBookmark = UserDefaults.standard.object(forKey: "arrayWorkingDirectoryBookmark") as? [Data] ?? [Data].init()

        self.url = UserDefaults.standard.object(forKey: "url") as? URL ?? URL(string: "n")!
        self.storedFolderURL = UserDefaults.standard.object(forKey: "storedFolderURL") as? URL ?? URL(string: "nope")!

        self.arrayOfFolderNames = UserDefaults.standard.object(forKey: "arrayOfFolderNames") as? [String] ?? ["none"]


       // self.recoveredURL = UserDefaults.standard.object(forKey: "recoveredURL") as? URL ?? URL(string: "nope")!

        self.storedFolderData = UserDefaults.standard.object(forKey: "storedFolderData") as? Data ?? Data()
        self.photo = UserDefaults.standard.object(forKey: "photo") as? Data ?? Data()
        self.isPrivate = UserDefaults.standard.object(forKey: "isAccountPrivate") as? Bool ?? false
    }
}
