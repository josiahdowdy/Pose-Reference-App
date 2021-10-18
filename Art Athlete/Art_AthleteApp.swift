//
//  Art_AthleteApp.swift
//  Art Athlete
//
//  Created by josiah on 2021-10-18.
//

import SwiftUI

@main
struct Art_AthleteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
