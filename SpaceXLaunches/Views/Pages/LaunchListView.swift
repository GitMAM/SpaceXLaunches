import SwiftUI
import SwiftData

struct LaunchListView: View {
  private var viewModel: LaunchesViewModel<SwiftDataModelContext<Launch>>
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Launch.launchDateUTC) private var allLaunches: [Launch]
  
  @State private var showUpcoming = false
  @State private var showAlert = false
  
  init(viewModel: LaunchesViewModel<SwiftDataModelContext<Launch>>) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    NavigationStack {
      VStack {
        launchPicker
        launchList
          .navigationTitle("Launches")
      }
    }
    .task {
      if allLaunches.isEmpty {
        await viewModel.getLaunches()
      }
    }
    .refreshable {
      await viewModel.getLaunches()
    }
    .errorAlert(viewModel: viewModel, showAlert: $showAlert)
  }
  
  private var launchPicker: some View {
    LaunchPicker(showUpcoming: $showUpcoming)
  }
  
  private var launchList: some View {
    LaunchList(viewModel: viewModel, showUpcoming: showUpcoming, allLaunches: allLaunches, modelContext: modelContext)
  }
}
