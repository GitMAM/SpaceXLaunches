import Foundation

/// Enum representing possible errors that can occur during network operations.
enum NetworkError: Error, Equatable {
  /// Indicates that the URL is invalid.
  case invalidURL
  
  /// Indicates that the request failed with the given HTTP status code.
  case requestFailed(statusCode: Int)
  
  /// Indicates that decoding the response data failed.
  case decodingFailed
  
  /// Represents an unknown error that does not fit other cases.
  case unknownError
}

/// Protocol defining network service operations to fetch data from the network.
protocol NetworkService: Sendable {
  /// Fetches a list of launches asynchronously.
  ///
  /// - Returns: An array of `Launch` objects representing the launches.
  /// - Throws: A `NetworkError` if the request fails or the data cannot be decoded.
  func fetchLaunches() async throws -> [Launch]
  
  /// Fetches details for a specific rocket by its ID asynchronously.
  ///
  /// - Parameter id: The ID of the rocket to fetch details for.
  /// - Returns: A `Rocket` object containing the details of the rocket.
  /// - Throws: A `NetworkError` if the request fails, the data cannot be decoded, or the ID is empty.
  func fetchRocketDetails(by id: String) async throws -> Rocket
}

/// Protocol defining methods for performing network data requests.
protocol URLSessionProtocol: Sendable {
  /// Performs a network request for the specified URL request.
  ///
  /// - Parameter request: The `URLRequest` to be executed.
  /// - Returns: A tuple containing the response `Data` and `URLResponse`.
  /// - Throws: An error if the request fails.
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

// Default implementation of `URLSessionProtocol` using `URLSession`.
extension URLSession: URLSessionProtocol {}

// Class implementing `NetworkService` to interact with the SpaceX API.
final class SpaceXNetworkService: NetworkService {
  /// Base URL for the SpaceX API.
  private let baseURL = "https://api.spacexdata.com/v4"
  
  /// The session used for performing network requests.
  private let session: URLSessionProtocol
  
  /// Initializes the network service with a specified session.
  ///
  /// - Parameter session: The `URLSessionProtocol` instance to use for network requests. Defaults to `URLSession.shared`.
  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
  }
  
  // MARK: - Public Methods
  
  /// Fetches a list of SpaceX launches.
  ///
  /// - Returns: An array of `Launch` objects.
  /// - Throws: A `NetworkError` if the request fails or the data cannot be decoded.
  func fetchLaunches() async throws -> [Launch] {
    return try await fetchData(endpoint: "/launches")
  }
  
  /// Fetches details of a rocket by its ID.
  ///
  /// - Parameter id: The ID of the rocket.
  /// - Returns: A `Rocket` object containing the rocket's details.
  /// - Throws: A `NetworkError` if the request fails, the ID is empty, or the data cannot be decoded.
  func fetchRocketDetails(by id: String) async throws -> Rocket {
    guard !id.isEmpty else {
      throw NetworkError.invalidURL
    }
    return try await fetchData(endpoint: "/rockets/\(id)")
  }
  
  // MARK: - Private Methods
  
  /// Fetches data from the API for the specified endpoint.
  ///
  /// - Parameter endpoint: The API endpoint to fetch data from.
  /// - Returns: A decoded object of type `T` from the response data.
  /// - Throws: A `NetworkError` if the request fails, the status code is not 200, or the data cannot be decoded.
  private func fetchData<T: Decodable>(endpoint: String) async throws -> T {
    guard let url = URL(string: baseURL + endpoint) else {
      throw NetworkError.invalidURL
    }
    
    let request = URLRequest(url: url)
    let (data, response) = try await session.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.unknownError
    }
    
    guard httpResponse.statusCode == 200 else {
      throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
    }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      throw NetworkError.decodingFailed
    }
  }
}
