//
//  health_trackerApp.swift
//  health-tracker
//
//  Created by Taha Chaudhry on 18/08/2024.
//

import SwiftUI
import CoreData

@main
struct health_trackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
