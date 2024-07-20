import SwiftUI

struct LaunchList: View {
  private let viewModel: LaunchesViewModel
  private let showUpcoming: Bool
  private let allLaunches: [Launch]
  
  init(viewModel: LaunchesViewModel, showUpcoming: Bool, allLaunches: [Launch]) {
    self.viewModel = viewModel
    self.showUpcoming = showUpcoming
    self.allLaunches = allLaunches
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
    let detailViewModel = LaunchDetailViewModel(networkService: SpaceXNetworkService())
    return DetailView(launch: launch, viewModel: detailViewModel)
  }
}
