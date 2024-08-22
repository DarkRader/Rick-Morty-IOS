//
//  RickAndMortyIOSApp.swift
//  RickAndMortyIOS
//
//  Created by DarkRader on 14.08.2024.
//

import SwiftUI

@main
struct RickAndMortyIOSApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            RickAndMortyTabView()
                .environment(
                    \.managedObjectContext, dataController.container.viewContext)
        }
    }
}
