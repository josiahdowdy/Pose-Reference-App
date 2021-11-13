//
//  DataProvider.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-13.
//

/*
import SwiftUI


struct Note: Codable, Identifiable {

    // MARK: - Properties
    var id = UUID()
    var name: String
    var isFolderSelected: Bool
    var url = URL(string: "nil")

    public var wrappedURL: URL {
        url ?? URL(string: "n")!
    }

//    public var wrappedIsFolderSelected: Bool {
//        isFolderSelected = false
//    }
}



class DataProvider: ObservableObject {
    // MARK: - Properties
    static let shared = DataProvider()
    private let dataSourceURL: URL
    @Published var allNotes = [Note]()

    @Published var workingDirectoryBookmark : Data {
        didSet {
            UserDefaults.standard.set(workingDirectoryBookmark, forKey: "workingDirectoryBookmark")
        }
    }


init() {
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let notesPath = documentsPath.appendingPathComponent("notes").appendingPathExtension("json")
    self.workingDirectoryBookmark = UserDefaults.standard.object(forKey: "workingDirectoryBookmark") as? Data ?? Data.init()  
    dataSourceURL = notesPath

    _allNotes = Published(wrappedValue: getAllNotes())
    //allNotes = getAllNotes()
}
    

    // MARK: - Methods
    private func getAllNotes() -> [Note] {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            let decodedNotes = try! decoder.decode([Note].self, from: data)

            return decodedNotes
        } catch {
            return []
        }
    }

    private func saveNotes() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allNotes)
            try data.write(to: dataSourceURL)
        } catch {

        }
    }

    func create(note: Note) {
        allNotes.insert(note, at: 0)
        saveNotes()
    }

//    func countNotes(note: Note) {
//        allNotes.count
//        saveNotes()
//    }

    func changeNote(note: Note, index: Int) {
        allNotes[index] = note
        saveNotes()
    }

    func delete(_ offsets: IndexSet) {
        allNotes.remove(atOffsets: offsets)
        saveNotes()
    }

    func move(source: IndexSet, destination: Int) {
        allNotes.move(fromOffsets: source, toOffset: destination)
        saveNotes()
    }
}

//struct DataProvider_Previews: PreviewProvider {
//    static var previews: some View {
//        DataProvider()
//    }
//}
*/
