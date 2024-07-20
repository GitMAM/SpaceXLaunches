import SwiftUI
import SwiftData

struct LaunchList: View {
  private let viewModel: LaunchesViewModel<SwiftDataModelContext<Launch>>
  private let showUpcoming: Bool
  private let allLaunches: [Launch]
  private let modelContext: ModelContext
  
  init(viewModel: LaunchesViewModel<SwiftDataModelContext<Launch>>, showUpcoming: Bool, allLaunches: [Launch], modelContext: ModelContext) {
    self.viewModel = viewModel
    self.showUpcoming = showUpcoming
    self.allLaunches = allLaunches
    self.modelContext = modelContext
  }
  
  var body: some View {
    List {
      ForEach(viewModel.filteredLaunches(showUpcoming: showUpcoming, allLaunches: allLaunches)) { item in
        // no reason to add a router here since this is very straight forward operation but in a real app this would be either a router or coordinator of some sort.
        NavigationLink(destination: launchDetailView(for: item)) {
          Text(item.missionName)
        }
      }
    }
  }
  
  private func launchDetailView(for launch: Launch) -> some View {
    let detailViewModel = LaunchDetailViewModel(networkService: SpaceXNetworkService(), modelContext: SwiftDataModelContext(modelContext: modelContext))
    return DetailView(launch: launch, viewModel: detailViewModel)
  }
}
