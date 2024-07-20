import SwiftUI

struct LaunchPatchView: View {
  let patchURL: URL?

  var body: some View {
    Group {
      if let patchURL = patchURL {
        AsyncImage(url: patchURL) { image in
          image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 100, maxHeight: 100)
        } placeholder: {
          ProgressView()
        }
      }
    }
  }
}

