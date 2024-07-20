import Foundation
import SwiftData
import SwiftUI

@Observable
final class LaunchesViewModel: ErrorHandlingViewModel {
  private let networkService: NetworkService
  var errorMessage: String? = nil

  var selectedLaunch: Launch?

  init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  @MainActor
  func getLaunches(modelContext: ModelContext) async {
    do {
      let launches = try await networkService.fetchLaunches()
      await MainActor.run {
        launches.forEach { launch in
          modelContext.insert(launch)
        }
      }
    } catch {
      errorMessage = "Something went wrong but it's not your fault"
    }
  }
  
  func filteredLaunches(showUpcoming: Bool, allLaunches: [Launch]) -> [Launch] {
    allLaunches.filter { launch in
      showUpcoming ? launch.upcoming : !launch.upcoming
    }
  }
}
