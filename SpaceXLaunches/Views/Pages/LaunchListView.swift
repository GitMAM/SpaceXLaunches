import SwiftUI
import SwiftData

struct LaunchListView: View {
  private let viewModel: LaunchesViewModel
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Launch.launchDateUTC) private var allLaunches: [Launch]
  
  @State private var showUpcoming = false
  @State private var showAlert = false
  
  init(viewModel: LaunchesViewModel) {
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
        await viewModel.getLaunches(modelContext: modelContext)
      }
    }
    .refreshable {
      await viewModel.getLaunches(modelContext: modelContext)
    }
    .errorAlert(viewModel: viewModel, showAlert: $showAlert)
  }
  
  private var launchPicker: some View {
    LaunchPicker(showUpcoming: $showUpcoming)
  }
  
  private var launchList: some View {
    LaunchList(viewModel: viewModel, showUpcoming: showUpcoming, allLaunches: allLaunches)
  }
}
