import Foundation
import SwiftData
import SwiftUI

/// ViewModel responsible for managing and presenting launch data.
///
/// This view model handles fetching launch data from a network service and saving it into a specified model context.
/// It also provides functionality to filter launches based on their upcoming status.
///
/// - T: The type of `ModelContextProtocol` used for managing model objects, which must be `Launch` in this case.
@Observable
final class LaunchesViewModel<T: ModelContextProtocol> where T.ObjectType == Launch {
  /// The network service used to fetch launch data.
  private let networkService: NetworkService
  
  /// The model context used to save launch data or a mock context for testing purposes.
  private let modelContext: T
  
  /// A message to be displayed when an error occurs.
  var errorMessage: String? = nil
  
  /// Initializes a `LaunchesViewModel` with a specified network service and model context.
  ///
  /// - Parameters:
  ///   - networkService: The `NetworkService` instance used to fetch launch data.
  ///   - modelContext: The `ModelContextProtocol` instance used to save the fetched launch data. This can be a real context or a mock context for testing.
  init(networkService: NetworkService, modelContext: T) {
    self.networkService = networkService
    self.modelContext = modelContext
  }
  
  // MARK: - Public Methods
  
  /// Fetches launches from the network service and inserts them into the model context.
  ///
  /// This method performs an asynchronous operation to fetch the launches. After fetching, it inserts each launch into the provided model context
  /// and saves the context. If an error occurs during fetching or saving, an error message is set.
  ///
  /// - Throws: Sets the `errorMessage` property if an error occurs during data fetching or saving.
  @MainActor
  func getLaunches() async {
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
  /// - Returns: An array of `Launch` objects that match the filter criteria based on the `showUpcoming` flag.
  func filteredLaunches(showUpcoming: Bool, allLaunches: [Launch]) -> [Launch] {
    allLaunches.filter { launch in
      showUpcoming ? launch.upcoming : !launch.upcoming
    }
  }
  
  
  func destinationView(for launch: Launch, modelContext: ModelContext) -> some View {
    // Initialize and return the detail view
    let detailViewModel = LaunchDetailViewModel(networkService: SpaceXNetworkService(), modelContext: SwiftDataModelContext(modelContext: modelContext))
    return DetailView(launch: launch, viewModel: detailViewModel)
  }
}


/// An extension for `LaunchesViewModel` that conforms to the `ErrorHandlingViewModel` protocol.
///
/// This extension adds functionality to handle and present errors that occur during data operations.
/// By conforming to `ErrorHandlingViewModel`, `LaunchesViewModel` gains access to error handling capabilities
/// that can be utilized to manage error states in a standardized way.
extension LaunchesViewModel: ErrorHandlingViewModel {}

