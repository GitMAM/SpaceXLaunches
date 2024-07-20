import SwiftUI

struct LaunchFailuresView: View {
  let failures: [LaunchFailure]?
  
  var body: some View {
    Group {
      Text("Launch Failures")
        .font(.headline)
      if let failures = failures, !failures.isEmpty {
        ForEach(failures, id: \.self) { failure in
          VStack(alignment: .leading) {
            if let reason = failure.reason {
              Text("Reason: \(reason)")
            }
            if let time = failure.time {
              Text("Time: \(time) seconds")
            }
            if let altitude = failure.altitude {
              Text("Altitude: \(altitude) meters")
            }
          }
          .padding(.vertical, 4)
        }
      } else {
        Text("No failures")
      }
    }
  }
}
