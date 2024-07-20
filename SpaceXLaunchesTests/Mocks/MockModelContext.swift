@testable import SpaceXLaunches
import Foundation

class MockModelContext: ModelContextProtocol {
  var savedObjects: [Launch] = []
  
  func insert(_ object: Launch) {
    savedObjects.append(object)
  }
  
  func save() throws {
    // Assume saving is always successful
  }
}

class MockRocketModelContext: ModelContextProtocol {
  var savedObjects: [Rocket] = []
  
  func insert(_ object: Rocket) {
    savedObjects.append(object)
    
    print(savedObjects.count)
  }
  
  func save() throws {
    // Assume save is successful
  }
}
