import Foundation
import SwiftData

@Model
// this could have a relation to the Launch but I chose not to give it in this case to reduce complexity.
final class Rocket: Decodable {
  @Attribute(.unique) var id: String
  var name: String
  var type: String
  
  init(id: String, name: String, type: String) {
    self.id = id
    self.name = name
    self.type = type
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case name = "name"
    case type = "type"
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    type = try container.decode(String.self, forKey: .type)
  }
}
