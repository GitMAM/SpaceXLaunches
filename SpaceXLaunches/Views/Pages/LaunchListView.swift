import SwiftUI
import SwiftData

// one approach here is we can drive this view from a state enum like so
//enum ViewState {
//    case idle
//    case loading
//    case loaded([Launch])
//    case error(String)
//}
// It's okay to go without that here since we don't have a lot of states to manage and since majority of the times the data will be loaded from local storage

struct LaunchListView: View {
  private let viewModel: LaunchesViewModel<SwiftDataModelContext<Launch>>
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Launch.launchDateUTC) private let allLaunches: [Launch]
  
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
