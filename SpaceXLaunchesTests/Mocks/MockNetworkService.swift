import Foundation
@testable import SpaceXLaunches

// Define a mock NetworkService
class MockNetworkService: NetworkService {
  var data: Data?
  var response: URLResponse?
  var error: Error?
  
  init(data: Data?, response: URLResponse?, error: Error?) {
    self.data = data
    self.response = response
    self.error = error
  }
  
  func fetchLaunches() async throws -> [Launch] {
    if let error = error {
      throw error
    }
    guard let data = data else {
      throw NetworkError.unknownError
    }
    
    // Decode the data into an array of `Launch` objects
    do {
      let launches = try JSONDecoder().decode([Launch].self, from: data)
      return launches
    } catch {
      throw NetworkError.decodingFailed
    }
  }
  
  func fetchRocketDetails(by id: String) async throws -> Rocket {
    if let error = error {
      throw error
    }
    guard let data = data else {
      throw NetworkError.unknownError
    }
    
    // Decode the data into a `Rocket` object
    do {
      let rocket = try JSONDecoder().decode(Rocket.self, from: data)
      return rocket
    } catch {
      throw NetworkError.decodingFailed
    }
  }
}

