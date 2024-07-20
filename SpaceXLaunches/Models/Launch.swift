import Foundation
import SwiftData

@Model
class Launch: Codable {
  @Attribute(.unique) var id: String
  var missionName: String
  var launchDateUTC: String
  var launchLocalDate: String
  var launchSuccess: Bool?
  var details: String?
  var rocket: String
  var upcoming: Bool
  var failures: [LaunchFailure]?
  var links: LaunchLink?
  var crew: [String]?
  
  init(id: String, missionName: String,
       launchDateUTC: String,
       launchSuccess: Bool? = nil,
       details: String? = nil,
       rocket: String,
       upcoming: Bool,
       failures: [LaunchFailure]?,
       launchLocalDate: String,
       links: LaunchLink?) {
    self.id = id
    self.missionName = missionName
    self.launchDateUTC = launchDateUTC
    self.launchSuccess = launchSuccess
    self.details = details
    self.rocket = rocket
    self.upcoming = upcoming
    self.failures = failures
    self.launchLocalDate = launchLocalDate
    self.links = links
  }
  
  // this is required because of the @Model macro
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case missionName = "name"
    case launchDateUTC = "date_utc"
    case launchSuccess = "success"
    case details = "details"
    case rocket = "rocket"
    case links = "links"
    case upcoming = "upcoming"
    case failures = "failures"
    case launchLocalDate = "date_local"
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    missionName = try container.decode(String.self, forKey: .missionName)
    launchDateUTC = try container.decode(String.self, forKey: .launchDateUTC)
    launchLocalDate = try container.decode(String.self, forKey: .launchLocalDate)
    launchSuccess = try container.decodeIfPresent(Bool.self, forKey: .launchSuccess)
    details = try container.decodeIfPresent(String.self, forKey: .details)
    rocket = try container.decode(String.self, forKey: .rocket)
    upcoming = try container.decode(Bool.self, forKey: .upcoming)
    failures = try container.decodeIfPresent([LaunchFailure].self, forKey: .failures)
    links = try container.decodeIfPresent(LaunchLink.self, forKey: .links)
  }
  
  func encode(to encoder: any Encoder) throws {}
}
