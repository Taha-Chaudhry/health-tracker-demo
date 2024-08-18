//
//  health_trackerApp.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 18/08/2024.
//

import SwiftUI

@main
struct health_trackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
