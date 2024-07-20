import Foundation
import SwiftData

@Model
class LaunchFailure: Decodable {
  @Attribute(.unique) var reason: String?
  var time: Int?
  var altitude: Int?
  @Relationship(inverse: \Launch.failures) var launch: Launch?
  
  init(reason: String?, time: Int?, altitude: Int?) {
    self.reason = reason
    self.time = time
    self.altitude = altitude
  }
  
  enum CodingKeys: String, CodingKey {
    case reason = "reason"
    case time = "time"
    case altitude = "altitude"
  }
  
  required init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    reason = try container.decodeIfPresent(String.self, forKey: .reason)
    time = try container.decodeIfPresent(Int.self, forKey: .time)
    altitude = try container.decodeIfPresent(Int.self, forKey: .altitude)
  }
}
