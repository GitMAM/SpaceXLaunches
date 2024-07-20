//
//  SpaceXLaunchesTests.swift
//  SpaceXLaunchesTests
//
//  Created by Mohamed Ali on 19/07/2024.
//

import XCTest
@testable import SpaceXLaunches

class MockURLSession: URLSessionProtocol {
  var data: Data?
  var urlResponse: URLResponse?
  var error: Error?
  
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



final class SpaceXNetworkServiceTests: XCTestCase {
  
  func testFetchLaunches_Success() async throws {
    let mockData = """
    [
        {
            "id": "5eb87cd9ffd86e000604b32a",
            "name": "FalconSat",
            "date_utc": "2006-03-24T22:30:00.000Z",
            "date_local": "2006-03-24T15:30:00-07:00",
            "success": true,
            "details": "Engine failure at 33 seconds and loss of vehicle",
            "rocket": "5e9d0d95eda69955f709d1eb",
            "upcoming": false,
            "failures": [],
            "links": {
                "webcast": "https://www.youtube.com/watch?v=0a_00nJ_Y88"
            },
            "crew": []
        }
    ]
    """.data(using: .utf8)!
    
    let urlResponse = HTTPURLResponse(url: URL(string: "https://api.spacexdata.com/v4/launches")!,
                                      statusCode: 200,
                                      httpVersion: nil,
                                      headerFields: nil)!
    
    let session = MockURLSession(data: mockData, urlResponse: urlResponse, error: nil)
    let service = SpaceXNetworkService(session: session)
    
    do {
      let launches = try await service.fetchLaunches()
      XCTAssertEqual(launches.count, 1)
      XCTAssertEqual(launches.first?.id, "5eb87cd9ffd86e000604b32a")
    } catch {
      XCTFail("Expected success, but got error: \(error)")
    }
  }
  
  
  func testFetchRocketDetails_Success() async throws {
    let mockData = """
        {
            "id": "5e9d0d95eda69955f709d1eb",
            "name": "Falcon 1",
            "type": "rocket"
        }
        """.data(using: .utf8)!
    
    let urlResponse = HTTPURLResponse(url: URL(string: "https://api.spacexdata.com/v4/rockets/5e9d0d95eda69955f709d1eb")!,
                                      statusCode: 200,
                                      httpVersion: nil,
                                      headerFields: nil)!
    
    let session = MockURLSession(data: mockData, urlResponse: urlResponse, error: nil)
    let service = SpaceXNetworkService(session: session)
    
    do {
      let rocket = try await service.fetchRocketDetails(by: "5e9d0d95eda69955f709d1eb")
      XCTAssertEqual(rocket.id, "5e9d0d95eda69955f709d1eb")
      XCTAssertEqual(rocket.name, "Falcon 1")
      XCTAssertEqual(rocket.type, "rocket")
    } catch {
      XCTFail("Expected success, but got error: \(error)")
    }
  }
  
  func testFetchRocketDetails_InvalidURL() async {
    let session = MockURLSession(data: nil, urlResponse: nil, error: nil)
    let service = SpaceXNetworkService(session: session)
    
    do {
      _ = try await service.fetchRocketDetails(by: "")
      XCTFail("Expected failure, but got success")
    } catch let error as NetworkError {
      XCTAssertEqual(error, NetworkError.invalidURL)
    } catch {
      XCTFail("Expected NetworkError.invalidURL, but got: \(error)")
    }
  }
  
  func testFetchData_RequestFailed() async {
    let urlResponse = HTTPURLResponse(url: URL(string: "https://api.spacexdata.com/v4/launches")!,
                                      statusCode: 404,
                                      httpVersion: nil,
                                      headerFields: nil)!
    
    let session = MockURLSession(data: nil, urlResponse: urlResponse, error: nil)
    let service = SpaceXNetworkService(session: session)
    
    do {
      _ = try await service.fetchLaunches()
      XCTFail("Expected failure, but got success")
    } catch let error as NetworkError {
      XCTAssertEqual(error, .unknownError)
    } catch {
      XCTFail("Expected NetworkError.requestFailed, but got: \(error)")
    }
    
  }
  
  func testFetchData_DecodingFailed() async {
    let mockData = "invalid json".data(using: .utf8)!
    
    let urlResponse = HTTPURLResponse(url: URL(string: "https://api.spacexdata.com/v4/launches")!,
                                      statusCode: 200,
                                      httpVersion: nil,
                                      headerFields: nil)!
    
    let session = MockURLSession(data: mockData, urlResponse: urlResponse, error: nil)
    let service = SpaceXNetworkService(session: session)
    
    do {
      _ = try await service.fetchLaunches()
      XCTFail("Expected failure, but got success")
    } catch let error as NetworkError {
      XCTAssertEqual(error, NetworkError.decodingFailed)
    } catch {
      XCTFail("Expected NetworkError.decodingFailed, but got: \(error)")
    }
  }
}
