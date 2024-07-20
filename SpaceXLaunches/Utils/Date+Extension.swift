import Foundation

extension Date {
  // Method to convert UTC date to Irish time and format nicely
  static func convertUTCToIrishTime(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    // Convert string to Date
    guard let date = dateFormatter.date(from: dateString) else {
      return "Invalid Date"
    }
    // Convert to Irish time
    dateFormatter.timeZone = TimeZone(identifier: "Europe/Dublin")
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .full
    
    return dateFormatter.string(from: date)
    
  }
  
  // Method to format the given date nicely
  static func formatDateWithOriginalTimeZone(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
    // Convert string to Date
    guard let date = dateFormatter.date(from: dateString) else {
      return "Invalid Date"
    }
    
    let outputFormatter = DateFormatter()
    
    let timeZoneOffset = dateString.suffix(6)
    if let timeZone = TimeZone(secondsFromGMT: Date.timeZoneOffsetToSeconds(String(timeZoneOffset))) {
      outputFormatter.timeZone = timeZone
    }
    // Format date nicely
    outputFormatter.dateStyle = .full
    outputFormatter.timeStyle = .full
    
    return outputFormatter.string(from: date)
  }
  
  static func timeZoneOffsetToSeconds(_ timeZoneOffset: String) -> Int {
    let sign = timeZoneOffset.first == "+" ? 1 : -1
    let components = timeZoneOffset.dropFirst().split(separator: ":").map { Int($0) ?? 0 }
    let hours = components[0]
    let minutes = components[1]
    return sign * ((hours * 3600) + (minutes * 60))
  }
}
