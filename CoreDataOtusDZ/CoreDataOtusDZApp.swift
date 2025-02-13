//
//  CoreDataOtusDZApp.swift
//  CoreDataOtusDZ
//
//  Created by Вячеслав Вовк on 13.02.2025.
//

import SwiftUI

@main
struct CoreDataOtusDZApp: App {
    let persistenceController = PersistenceController.shared
    @ObservedObject var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
