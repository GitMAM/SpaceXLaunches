import SwiftUI

/// A protocol that provides error handling capabilities for view models.
///
/// Conforming types must implement an `errorMessage` property that can be observed for displaying error messages.
protocol ErrorHandlingViewModel: ObservableObject {
    /// A message to be displayed when an error occurs.
    ///
    /// This property should be updated with a descriptive error message whenever an error is encountered.
    /// The view observing this view model can use this property to display appropriate error messages to the user.
    var errorMessage: String? { get set }
}
