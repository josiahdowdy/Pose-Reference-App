//
//  Extensions.swift
//  ArtAthlete (iOS)
//
//  Created by josiah on 2021-12-09.
//

import Foundation

//MARK: - extensions.
extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()

        for value in self {
            if !result.contains(value) {
                result.append(value)

            }
        }
        self = result
    }
}

