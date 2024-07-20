import Foundation
import SwiftData

@Model
final class LaunchLink: Decodable {
  @Attribute(.unique) var id: UUID = UUID()
  var patch: Patch?
  @Relationship(inverse: \Launch.links) var launch: Launch?
  
  init(patch: Patch?) {
    self.patch = patch
  }
  
  enum CodingKeys: String, CodingKey {
    case patch = "patch"
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    patch = try container.decodeIfPresent(Patch.self, forKey: .patch)
  }
}

@Model
final class Patch: Decodable {
  @Attribute(.unique) var id: UUID = UUID()
  @Attribute var small: URL?
  @Relationship(inverse: \LaunchLink.patch) var link: LaunchLink?
  
  init(small: URL?) {
    self.small = small
  }
  
  enum CodingKeys: String, CodingKey {
    case small = "small"
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    small = try container.decodeIfPresent(URL.self, forKey: .small)
  }
}
