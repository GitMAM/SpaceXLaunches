import SwiftUI

struct LaunchPicker: View {
  @Binding var showUpcoming: Bool
  
  var body: some View {
    Picker("Launches", selection: $showUpcoming) {
      Text("Upcoming").tag(true)
      Text("Past").tag(false)
    }
    .pickerStyle(SegmentedPickerStyle())
    .padding()
  }
}
