import SwiftUI

protocol ErrorHandlingViewModel: ObservableObject {
  var errorMessage: String? { get set }
}
