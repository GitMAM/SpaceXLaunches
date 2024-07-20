//
//  SpaceXLaunchesApp.swift
//  SpaceXLaunches
//
//  Created by Mohamed Ali on 19/07/2024.
//

import SwiftUI
import SwiftData

@main
struct SpaceXLaunchesApp: App {
  // Create a shared model container
  private let sharedModelContainer: ModelContainer = {
    // Define the schema with all data models
    let schema = Schema([
      Launch.self,
      LaunchFailure.self,
      LaunchLink.self,
      Rocket.self
    ])
    
    // Configure model settings
    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: false
    )
    
    do {
      // Initialize and return the model container
      return try ModelContainer(
        for: schema,
        configurations: [modelConfiguration]
      )
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  var body: some Scene {
    WindowGroup {
      // Pass the model context to the view model
      LaunchListView(
        viewModel: LaunchesViewModel(
          networkService: SpaceXNetworkService(),
          modelContext: SwiftDataModelContext(modelContext: sharedModelContainer.mainContext)
        )
      )
    }
    // Attach the model container to the scene
    .modelContainer(sharedModelContainer)
  }
}

