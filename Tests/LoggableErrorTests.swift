import XCTest
@testable import Logger

final class LoggableErrorTests: XCTestCase {

  // MARK: - Tests

  func test_loggableError() {
    let error: LoggableError = TestError.test

    XCTAssertEqual(error.localizedDescription, Constant.errorDescription)
    XCTAssertEqual(error.analyticMessage, Constant.analyticMessage)
    XCTAssertNil(error.analyticParameters)
  }

  func test_stringError() {
    typealias StringError = DefaultLoggerService.StringError

    let error: LoggableError = StringError(analyticMessage: Constant.errorDescription)

    XCTAssertEqual(error.localizedDescription, Constant.errorDescription)
    XCTAssertEqual(error.analyticMessage, Constant.errorDescription)
  }

}

// MARK: - Constants

private enum Constant {

  static let errorDescription = "Test error"
  static let analyticMessage = "This is test error, sth went wrong"

}

// MARK: - Mock Loggable Error

private enum TestError: LoggableError {

  case test

  var errorDescription: String? {
    switch self {
    case .test:
      return Constant.errorDescription
    }
  }

  var analyticMessage: AnalyticMessage {
    switch self {
    case .test:
      return Constant.analyticMessage
    }
  }

  var analyticParameters: AnalyticParameters { nil }

}
