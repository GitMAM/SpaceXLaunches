import SwiftUI

struct ErrorAlertModifier<ViewModel: ErrorHandlingViewModel>: ViewModifier {
  let viewModel: ViewModel
  @Binding var showAlert: Bool
  
  func body(content: Content) -> some View {
    content
      .onChange(of: viewModel.errorMessage) { oldValue, newValue in
        if oldValue != newValue && newValue != nil {
          showAlert = true
        }
      }
      .alert(isPresented: $showAlert) {
        Alert(
          title: Text("Error"),
          message: Text(viewModel.errorMessage ?? ""),
          dismissButton: .default(Text("OK")) {
            viewModel.errorMessage = nil
          }
        )
      }
  }
}

extension View {
  func errorAlert<ViewModel: ErrorHandlingViewModel>(viewModel: ViewModel, showAlert: Binding<Bool>) -> some View {
    self.modifier(ErrorAlertModifier(viewModel: viewModel, showAlert: showAlert))
  }
}
