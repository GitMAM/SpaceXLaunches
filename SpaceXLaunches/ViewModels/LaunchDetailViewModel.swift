import Foundation
import SwiftData

@Observable
final class LaunchDetailViewModel: ErrorHandlingViewModel {
  var errorMessage: String? = nil
  
  private let networkService: NetworkService
  var rocket: Rocket?
  
  init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  @MainActor
  func fetchRocketIfNeeded(launch: Launch, modelContext: ModelContext) {
    guard rocket == nil else { return }
    Task {
      await getRocket(modelContext: modelContext, rocketId: launch.rocket)
    }
  }
  
  @MainActor
  private func getRocket(modelContext: ModelContext, rocketId: String) async {
    do {
      let fetchedRocket = try await networkService.fetchRocketDetails(by: rocketId)
      modelContext.insert(fetchedRocket)
      rocket = fetchedRocket
    } catch {
      errorMessage = "Something went wrong but it's not your fault"
    }
  }
}
