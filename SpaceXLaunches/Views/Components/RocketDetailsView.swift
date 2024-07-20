import SwiftUI

struct RocketDetailsView: View {
  let launch: Launch
  let rockets: [Rocket]
  
  var body: some View {
    Group {
      Text("Rocket Details")
        .font(.headline)
      let rocket = rockets.first { $0.id == launch.rocket }
      Text("Rocket name: \(rocket?.name ?? "Unknown")")
      Text("Rocket type: \(rocket?.type ?? "Unknown")")
      
      Text("Launch Date (Irish Time):")
        .font(.headline)
      
      Text(Date.convertUTCToIrishTime(dateString: launch.launchDateUTC))
      
      Text("Launch Date (Local Time):")
        .font(.headline)
      
      Text(Date.formatDateWithOriginalTimeZone(dateString: launch.launchLocalDate))
    }
  }
}
