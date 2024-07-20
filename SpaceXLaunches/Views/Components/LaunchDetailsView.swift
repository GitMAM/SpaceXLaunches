import SwiftUI

struct LaunchDetailsView: View {
  let details: String?
  
  var body: some View {
    Group {
      if let details = details {
        Text("More Details")
          .font(.headline)
        Text(details)
      }
    }
  }
}
