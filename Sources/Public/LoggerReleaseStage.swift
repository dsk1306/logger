import Foundation

enum LoggerReleaseStage {

  case testFlight
  case development
  case production

  var stringValue: String {
    switch self {
    case .testFlight:
      return "TestFlight"
    case .development:
      return "Development"
    case .production:
      return "Production"
    }
  }

}
