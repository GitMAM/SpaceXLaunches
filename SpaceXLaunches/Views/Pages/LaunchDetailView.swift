import SwiftUI
import SwiftData

import SwiftUI

struct DetailView: View {
  private let launch: Launch
  @Environment(\.modelContext) private var modelContext
  private let viewModel: LaunchDetailViewModel<SwiftDataModelContext<Rocket>>
  @Query private let rockets: [Rocket]
  @State private var showAlert = false
  
  init(launch: Launch, viewModel: LaunchDetailViewModel<SwiftDataModelContext<Rocket>>) {
    self.launch = launch
    self.viewModel = viewModel
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        LaunchPatchView(patchURL: launch.links?.patch?.small)
        RocketDetailsView(launch: launch, rockets: rockets)
        LaunchFailuresView(failures: launch.failures)
        LaunchDetailsView(details: launch.details)
      }
      .padding()
    }
    .onAppear {
      viewModel.fetchRocketIfNeeded(launch: launch)
    }
    .navigationTitle(launch.missionName)
    .navigationBarTitleDisplayMode(.inline)
    .errorAlert(viewModel: viewModel, showAlert: $showAlert)
  }
}
