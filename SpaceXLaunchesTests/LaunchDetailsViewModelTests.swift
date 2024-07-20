import XCTest
@testable import SpaceXLaunches

final class LaunchDetailViewModelTests: XCTestCase {
  
  // Test fetching rocket details successfully
  func testFetchRocketIfNeeded_Success() async {
    // Create mock data for a rocket
    let mockRocketData = """
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
    
    let mockNetworkService = MockNetworkService(data: mockRocketData, response: urlResponse, error: nil)
    let mockModelContext = MockRocketModelContext()
    let viewModel = LaunchDetailViewModel<MockRocketModelContext>(networkService: mockNetworkService, modelContext: mockModelContext)
    
    // Create a launch with the rocket ID to fetch
    let launch = Launch(id: "5eb87cd9ffd86e000604b32a",
                        missionName: "FalconSat",
                        launchDateUTC: "2006-03-24T22:30:00.000Z",
                        rocket: "5e9d0d95eda69955f709d1eb",
                        upcoming: false,
                        failures: nil,
                        launchLocalDate: "2006-03-24T15:30:00-07:00",
                        links: nil)
    
    // Fetch rocket if needed
    await viewModel.fetchRocketIfNeeded(launch: launch)
    
    // Check if the rocket was inserted into the model context
    try! await Task.sleep(nanoseconds: 1_000_000_000)
    
    XCTAssertEqual(mockModelContext.savedObjects.count, 1)
    guard let savedRocket = mockModelContext.savedObjects.first else {
      XCTFail("No rocket was saved in the model context")
      return
    }
    
    XCTAssertEqual(savedRocket.id, "5e9d0d95eda69955f709d1eb")
    XCTAssertEqual(savedRocket.name, "Falcon 1")
    XCTAssertEqual(savedRocket.type, "rocket")
    XCTAssertEqual(viewModel.rocket?.id, "5e9d0d95eda69955f709d1eb")
    XCTAssertNil(viewModel.errorMessage)
  }
  
  // Test that fetchRocketIfNeeded does nothing if the rocket is already fetched
  func testFetchRocketIfNeeded_RocketAlreadyFetched() async {
    let mockRocketData = """
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
    
    let mockNetworkService = MockNetworkService(data: mockRocketData, response: urlResponse, error: nil)
    let mockModelContext = MockRocketModelContext()
    let viewModel = LaunchDetailViewModel<MockRocketModelContext>(networkService: mockNetworkService, modelContext: mockModelContext)
    
    // Pre-set the rocket in the view model
    viewModel.rocket = Rocket(id: "5e9d0d95eda69955f709d1eb", name: "Falcon 1", type: "rocket")
    
    let launch = Launch(id: "5eb87cd9ffd86e000604b32a",
                        missionName: "FalconSat",
                        launchDateUTC: "2006-03-24T22:30:00.000Z",
                        rocket: "5e9d0d95eda69955f709d1eb",
                        upcoming: false,
                        failures: nil,
                        launchLocalDate: "2006-03-24T15:30:00-07:00",
                        links: nil)
    
    // Fetch rocket if needed
    await viewModel.fetchRocketIfNeeded(launch: launch)
    
    // Verify that no additional fetch occurred
    XCTAssertEqual(mockModelContext.savedObjects.count, 0)
    XCTAssertEqual(viewModel.rocket?.id, "5e9d0d95eda69955f709d1eb")
    XCTAssertNil(viewModel.errorMessage)
  }
  
  // Test handling network errors
  func testFetchRocketIfNeeded_NetworkError() async {
    let mockNetworkService = MockNetworkService(data: nil, response: nil, error: NetworkError.unknownError)
    let mockModelContext = MockRocketModelContext()
    let viewModel = LaunchDetailViewModel<MockRocketModelContext>(networkService: mockNetworkService, modelContext: mockModelContext)
    
    let launch = Launch(id: "5eb87cd9ffd86e000604b32a",
                        missionName: "FalconSat",
                        launchDateUTC: "2006-03-24T22:30:00.000Z",
                        rocket: "5e9d0d95eda69955f709d1eb",
                        upcoming: false,
                        failures: nil,
                        launchLocalDate: "2006-03-24T15:30:00-07:00",
                        links: nil)
    
    // Fetch rocket if needed
    await viewModel.fetchRocketIfNeeded(launch: launch)
    try! await Task.sleep(nanoseconds: 1_000_000_000)

    
    // Verify the error message is set
    XCTAssertNil(mockModelContext.savedObjects.first)
//    XCTAssertNotNil(viewModel.errorMessage)
    XCTAssertEqual(viewModel.errorMessage, "Something went wrong but it's not your fault")
  }
  
  // Test handling invalid JSON response
  func testFetchRocketIfNeeded_DecodingError() async {
    let mockInvalidData = "invalid json".data(using: .utf8)!
    let mockNetworkService = MockNetworkService(data: mockInvalidData, response: nil, error: nil)
    let mockModelContext = MockRocketModelContext()
    let viewModel = LaunchDetailViewModel<MockRocketModelContext>(networkService: mockNetworkService, modelContext: mockModelContext)
    
    let launch = Launch(id: "5eb87cd9ffd86e000604b32a",
                        missionName: "FalconSat",
                        launchDateUTC: "2006-03-24T22:30:00.000Z",
                        rocket: "5e9d0d95eda69955f709d1eb",
                        upcoming: false,
                        failures: nil,
                        launchLocalDate: "2006-03-24T15:30:00-07:00",
                        links: nil)
    
    // Fetch rocket if needed
    await viewModel.fetchRocketIfNeeded(launch: launch)
    try! await Task.sleep(nanoseconds: 1_000_000_000)
    
    // Verify the error message is set
    XCTAssertNil(mockModelContext.savedObjects.first)
    XCTAssertNotNil(viewModel.errorMessage)
    XCTAssertEqual(viewModel.errorMessage, "Something went wrong but it's not your fault")
  }
}
