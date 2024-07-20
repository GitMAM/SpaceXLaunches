import XCTest
@testable import SpaceXLaunches
import SwiftData

final class MockURLSession: URLSessionProtocol {
  let data: Data?
  let urlResponse: URLResponse?
  let error: Error?
  
  init(data: Data?, urlResponse: URLResponse?, error: Error?) {
    self.data = data
    self.urlResponse = urlResponse
    self.error = error
  }
  
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    if let error = error {
      throw error
    }
    if let data = data, let response = urlResponse {
      return (data, response)
    } else {
      throw NetworkError.unknownError
    }
  }
}
