import Foundation
import SwiftData

/// ViewModel responsible for managing and presenting details of a rocket associated with a launch.
@Observable
final class LaunchDetailViewModel<T: ModelContextProtocol> where T.ObjectType == Rocket {
  /// A message to be displayed when an error occurs.
  var errorMessage: String? = nil
  
  /// The network service used to fetch rocket details.
  private let networkService: NetworkService
  
  /// The rocket details associated with the current launch, if any.
  var rocket: Rocket?
  
  /// The `ModelContextProtocol` instance used to save rocket details.
  private let modelContext: T
  
  /// Initializes a `LaunchDetailViewModel` with a specified network service and model context.
  ///
  /// - Parameters:
  ///   - networkService: The `NetworkService` instance used to fetch rocket details.
  ///   - modelContext: The `ModelContextProtocol` instance used to save fetched rocket details.
  init(networkService: NetworkService, modelContext: T) {
    self.networkService = networkService
    self.modelContext = modelContext
  }
  
  // MARK: - Public Methods
  
  /// Fetches rocket details if they are not already loaded.
  ///
  /// - Parameter launch: The `Launch` object containing the ID of the rocket to fetch.
  /// - Note: This method only initiates the fetch if the `rocket` property is `nil`. If the rocket is already loaded, no action is taken.
  @MainActor
  func fetchRocketIfNeeded(launch: Launch) {
    guard rocket == nil else { return }
    Task {
      await getRocket(rocketId: launch.rocket)
    }
  }
  
  // MARK: - Private Methods
  
  /// Fetches rocket details from the network service and updates the model context.
  ///
  /// - Parameter rocketId: The ID of the rocket to fetch.
  /// - Throws: Sets the `errorMessage` if an error occurs during data fetching or saving.
  @MainActor
  private func getRocket(rocketId: String) async {
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

extension LaunchDetailViewModel: ErrorHandlingViewModel {}

