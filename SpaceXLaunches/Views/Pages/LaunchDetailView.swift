import SwiftUI
import SwiftData

import SwiftUI

struct DetailView: View {
  let launch: Launch
  @Environment(\.modelContext) private var modelContext
  var viewModel: LaunchDetailViewModel<SwiftDataModelContext<Rocket>>
  @Query private var rockets: [Rocket]
  @State private var showAlert = false

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
