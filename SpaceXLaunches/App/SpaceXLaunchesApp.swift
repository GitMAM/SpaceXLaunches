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
  private let sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Launch.self,
      LaunchFailure.self,
      LaunchLink.self,
      Rocket.self
    ])
    
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  var body: some Scene {
    WindowGroup {
      LaunchListView(viewModel: LaunchesViewModel(networkService: SpaceXNetworkService(), modelContext: SwiftDataModelContext(modelContext: sharedModelContainer.mainContext)))
    }
    .modelContainer(sharedModelContainer)
  }
}
