import Foundation

enum NetworkError: Error, Equatable {
  case invalidURL
  case requestFailed(statusCode: Int)
  case decodingFailed
  case unknownError
}

protocol NetworkService {
  func fetchLaunches() async throws -> [Launch]
  func fetchRocketDetails(by id: String) async throws -> Rocket
}

protocol URLSessionProtocol {
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

class SpaceXNetworkService: NetworkService {
  private let baseURL = "https://api.spacexdata.com/v4"
  private let session: URLSessionProtocol
  
  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
  }
  
  // MARK: - Public Methods
  func fetchLaunches() async throws -> [Launch] {
    return try await fetchData(endpoint: "/launches")
  }
  
  func fetchRocketDetails(by id: String) async throws -> Rocket {
    guard !id.isEmpty else {
      throw NetworkError.invalidURL
    }
    return try await fetchData(endpoint: "/rockets/\(id)")
  }
  
  // MARK: - Private Methods
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
