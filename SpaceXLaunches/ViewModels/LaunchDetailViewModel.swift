import Foundation
import SwiftData

/// ViewModel responsible for managing and presenting details of a rocket associated with a launch.
@Observable
final class LaunchDetailViewModel: ErrorHandlingViewModel {
  /// A message to be displayed when an error occurs.
  var errorMessage: String? = nil
  
  /// The network service used to fetch rocket details.
  private let networkService: NetworkService
  
  /// The rocket details associated with the current launch, if any.
  var rocket: Rocket?
  
  /// Initializes a `LaunchDetailViewModel` with a specified network service.
  ///
  /// - Parameter networkService: The `NetworkService` instance used to fetch rocket details.
  init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  // MARK: - Public Methods
  
  /// Fetches rocket details if they are not already loaded.
  ///
  /// - Parameters:
  ///   - launch: The `Launch` object containing the ID of the rocket to fetch.
  ///   - modelContext: The `ModelContext` in which to insert the fetched rocket details.
  /// - Note: This method only initiates the fetch if the `rocket` property is `nil`.
  @MainActor
  func fetchRocketIfNeeded(launch: Launch, modelContext: ModelContext) {
    guard rocket == nil else { return }
    Task {
      await getRocket(modelContext: modelContext, rocketId: launch.rocket)
    }
  }
  
  // MARK: - Private Methods
  
  /// Fetches rocket details from the network service and updates the model context.
  ///
  /// - Parameters:
  ///   - modelContext: The `ModelContext` in which to insert the fetched rocket details.
  ///   - rocketId: The ID of the rocket to fetch.
  /// - Throws: Sets the `errorMessage` if an error occurs during data fetching.
  @MainActor
  private func getRocket(modelContext: ModelContext, rocketId: String) async {
    do {
      let fetchedRocket = try await networkService.fetchRocketDetails(by: rocketId)
      modelContext.insert(fetchedRocket)
      try modelContext.save()
      rocket = fetchedRocket
    } catch {
      errorMessage = "Something went wrong but it's not your fault"
    }
  }
}

