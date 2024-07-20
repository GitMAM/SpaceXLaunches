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
        // no reason to add a router here since this is very straight forward operation but in a real app this would be either a router or coordinator of some sort or state based navigation to help with deeplinking etc ..
        
        // Pseudocode for Router-based Navigation
        /*
         class Router {
         func navigateToDetail(for launch: Launch) -> some View {
         // Initialize and return the detail view
         let detailViewModel = LaunchDetailViewModel(networkService: SpaceXNetworkService(), modelContext: SwiftDataModelContext(modelContext: modelContext))
         return DetailView(launch: launch, viewModel: detailViewModel)
         }
         }
         
         // Usage
         Button(action: { router.navigateToDetail(for: item) }) {
         Text(item.missionName)
         }
         */
        
        NavigationLink(destination: viewModel.destinationView(for: item, modelContext: modelContext)) {
          Text(item.missionName)
        }
      }
    }
  }
}
