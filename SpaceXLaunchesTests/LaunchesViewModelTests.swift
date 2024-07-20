import XCTest
@testable import SpaceXLaunches

final class LaunchesViewModelTests: XCTestCase {
  
  func testGetLaunches_Success() async {
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
    
    let mockNetworkService = MockNetworkService(data: mockData, response: urlResponse, error: nil)
    let mockModelContext = MockModelContext()
    let viewModel = LaunchesViewModel(networkService: mockNetworkService, modelContext: mockModelContext)
    
    await viewModel.getLaunches()
    
    XCTAssertEqual(mockModelContext.savedObjects.count, 1)
    XCTAssertEqual(mockModelContext.savedObjects.first?.id, "5eb87cd9ffd86e000604b32a")
    XCTAssertNil(viewModel.errorMessage)
  }
  
  func testGetLaunches_Error() async {
    let mockNetworkService = MockNetworkService(data: nil, response: nil, error: NetworkError.unknownError)
    let mockModelContext = MockModelContext()
    let viewModel = LaunchesViewModel(networkService: mockNetworkService, modelContext: mockModelContext)
    
    await viewModel.getLaunches()
    
    XCTAssertTrue(mockModelContext.savedObjects.isEmpty)
    XCTAssertEqual(viewModel.errorMessage, "Something went wrong but it's not your fault")
  }
  
  func testFilteredLaunches() async {
    // Create mock data for launches
    let mockData = """
      [
          {
              "id": "1",
              "name": "Past Launch",
              "date_utc": "2023-01-01T00:00:00.000Z",
              "date_local": "2023-01-01T00:00:00-00:00",
              "success": true,
              "details": "Details of past launch",
              "rocket": "rocket1",
              "upcoming": false,
              "failures": [],
              "links": {
                  "webcast": "https://example.com"
              },
              "crew": []
          },
          {
              "id": "2",
              "name": "Upcoming Launch",
              "date_utc": "2024-01-01T00:00:00.000Z",
              "date_local": "2024-01-01T00:00:00-00:00",
              "success": false,
              "details": "Details of upcoming launch",
              "rocket": "rocket2",
              "upcoming": true,
              "failures": [],
              "links": {
                  "webcast": "https://example.com"
              },
              "crew": []
          }
      ]
      """.data(using: .utf8)!
    
    let urlResponse = HTTPURLResponse(url: URL(string: "https://api.spacexdata.com/v4/launches")!,
                                      statusCode: 200,
                                      httpVersion: nil,
                                      headerFields: nil)!
    
    let mockNetworkService = MockNetworkService(data: mockData, response: urlResponse, error: nil)
    let mockModelContext = MockModelContext()
    let viewModel = LaunchesViewModel<MockModelContext>(networkService: mockNetworkService, modelContext: mockModelContext)
    
    // Fetch the launches
    await viewModel.getLaunches()
    
    // Use the fetched launches for filtering
    let allLaunches = mockModelContext.savedObjects
    
    // Test filtering for upcoming launches
    let filteredUpcoming = viewModel.filteredLaunches(showUpcoming: true, allLaunches: allLaunches)
    XCTAssertEqual(filteredUpcoming.count, 1)
    XCTAssertEqual(filteredUpcoming.first?.id, "2")
    
    // Test filtering for past launches
    let filteredPast = viewModel.filteredLaunches(showUpcoming: false, allLaunches: allLaunches)
    XCTAssertEqual(filteredPast.count, 1)
    XCTAssertEqual(filteredPast.first?.id, "1")
  }
}
