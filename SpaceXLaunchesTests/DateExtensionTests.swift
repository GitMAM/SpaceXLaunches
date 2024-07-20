import XCTest
@testable import SpaceXLaunches

class DateExtensionTests: XCTestCase {
  
  func testConvertUTCToIrishTime() {
    // Test with a valid UTC date string
    let utcDateString = "2023-07-20T12:34:56.789Z"
    let expectedIrishTime = "Thursday 20 July 2023 at 13:34:56 Irish Standard Time"
    XCTAssertEqual(Date.convertUTCToIrishTime(dateString: utcDateString), expectedIrishTime)
    
    // Test with an invalid date string
    let invalidDateString = "invalid-date"
    XCTAssertEqual(Date.convertUTCToIrishTime(dateString: invalidDateString), "Invalid Date")
    
    // Test with a date string with no milliseconds
    let utcDateStringNoMillis = "2023-07-20T12:34:56Z"
    XCTAssertEqual(Date.convertUTCToIrishTime(dateString: utcDateStringNoMillis), "Invalid Date")
  }
  
  func testFormatDateWithOriginalTimeZone() {
    // Test with a valid date string and time zone offset
    let dateStringWithOffset = "2023-07-20T12:34:56+01:00"
    let expectedFormattedDate = "Thursday 20 July 2023 at 12:34:56 GMT+01:00"
    XCTAssertEqual(Date.formatDateWithOriginalTimeZone(dateString: dateStringWithOffset), expectedFormattedDate)
    
    // Test with a date string in another time zone
    let dateStringWithDifferentOffset = "2023-07-20T12:34:56-04:00"
    let expectedFormattedDateDifferentOffset = "Thursday 20 July 2023 at 12:34:56 GMT-04:00"
    XCTAssertEqual(Date.formatDateWithOriginalTimeZone(dateString: dateStringWithDifferentOffset), expectedFormattedDateDifferentOffset)
    
    // Test with an invalid date string
    let invalidDateString = "invalid-date"
    XCTAssertEqual(Date.formatDateWithOriginalTimeZone(dateString: invalidDateString), "Invalid Date")
    
    // Test with edge case time zones
    let dateStringEdgeCasePositive = "2023-07-20T12:34:56+14:00"
    let expectedFormattedDateEdgeCasePositive = "Thursday 20 July 2023 at 12:34:56 GMT+14:00"
    XCTAssertEqual(Date.formatDateWithOriginalTimeZone(dateString: dateStringEdgeCasePositive), expectedFormattedDateEdgeCasePositive)
    
    let dateStringEdgeCaseNegative = "2023-07-20T12:34:56-12:00"
    let expectedFormattedDateEdgeCaseNegative = "Thursday 20 July 2023 at 12:34:56 GMT-12:00"
    XCTAssertEqual(Date.formatDateWithOriginalTimeZone(dateString: dateStringEdgeCaseNegative), expectedFormattedDateEdgeCaseNegative)
  }
  
  func testTimeZoneOffsetToSeconds() {
    // Test with a positive offset
    XCTAssertEqual(Date.timeZoneOffsetToSeconds("+01:00"), 3600)
    
    // Test with a negative offset
    XCTAssertEqual(Date.timeZoneOffsetToSeconds("-04:00"), -14400)
    
    // Test with an edge case positive offset
    XCTAssertEqual(Date.timeZoneOffsetToSeconds("+14:00"), 50400)
    
    // Test with an edge case negative offset
    XCTAssertEqual(Date.timeZoneOffsetToSeconds("-12:00"), -43200)
  }
}

