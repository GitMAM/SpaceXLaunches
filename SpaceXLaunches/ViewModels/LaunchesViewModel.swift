import Foundation
import SwiftData
import SwiftUI

/// ViewModel responsible for managing and presenting launches data.
@Observable
final class LaunchesViewModel: ErrorHandlingViewModel {
  /// The network service used to fetch launch data.
  private let networkService: NetworkService
  
  /// A message to be displayed when an error occurs.
  var errorMessage: String? = nil
  
  /// The currently selected launch, if any.
  var selectedLaunch: Launch?
  
  /// Initializes a `LaunchesViewModel` with a specified network service.
  ///
  /// - Parameter networkService: The `NetworkService` instance used to fetch launch data.
  init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  // MARK: - Public Methods
  
  /// Fetches launches from the network service and inserts them into the provided model context.
  ///
  /// - Parameter modelContext: The `ModelContext` in which to insert the fetched launches.
  /// - Throws: Sets the `errorMessage` if an error occurs during data fetching.
  @MainActor
  func getLaunches(modelContext: ModelContext) async {
    do {
      let launches = try await networkService.fetchLaunches()
      await MainActor.run {
        launches.forEach { launch in
          modelContext.insert(launch)
        }
      }
      try modelContext.save()
    } catch {
      errorMessage = "Something went wrong but it's not your fault"
    }
  }
  
  /// Filters a list of launches based on whether to show upcoming launches or not.
  ///
  /// - Parameters:
  ///   - showUpcoming: A Boolean indicating whether to filter for upcoming launches (`true`) or past launches (`false`).
  ///   - allLaunches: An array of `Launch` objects to filter.
  /// - Returns: An array of `Launch` objects that match the filter criteria.
  func filteredLaunches(showUpcoming: Bool, allLaunches: [Launch]) -> [Launch] {
    allLaunches.filter { launch in
      showUpcoming ? launch.upcoming : !launch.upcoming
    }
  }
}

