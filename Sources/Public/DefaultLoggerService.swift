import Bugsnag
import Foundation

public final class DefaultLoggerService {

  // MARK: - Properties

  public var onOptOut: OnOptOutHandler?

  // MARK: - Initialization

  public init(onOptOut: OnOptOutHandler?) {
    self.onOptOut = onOptOut
  }

}

// MARK: - LoggerService

extension DefaultLoggerService: LoggerService {

  public func log(error: String) {
    let error = StringError(errorString: error)
    log(error: error)
  }

  public func log(error: Error) {
    if let error = error as? LoggableError {
      guard error.shouldReport else { return }
      Bugsnag.notifyError(error) { report in
        report.writeErrorClass(from: error)
        report.writeParameters(from: error)
        report.writeContext(from: error)
        report.writeErrorMessage(from: error)
        return true
      }
    } else {
      Bugsnag.notifyError(error)
    }
  }

  public func log(deinitOf object: Any) {
    #if DEBUG
    let typeOfObject = type(of: object)
    let describing = String(describing: typeOfObject)
    print(describing)
    #endif
  }

  public func log(items: Any...) {
    #if DEBUG
    print(items)
    #endif
  }

}

// MARK: - Constants

private extension DefaultLoggerService {

  enum Constant {

    static let sectionName = "UserInfo"

  }

}

// MARK: - BugsnagEvent Extension

private extension BugsnagEvent {

  func writeParameters(from error: LoggableError) {
    guard let parameters = error.analyticParameters else { return }
    for (key, value) in parameters {
      addMetadata(
        value,
        key: key,
        section: DefaultLoggerService.Constant.sectionName
      )
    }
  }

  func writeContext(from error: LoggableError) {
    guard let context = error.analyticContext else { return }
    self.context = context
  }

  func writeErrorClass(from error: LoggableError) {
    errors.forEach {
      $0.errorClass = "\(type(of: error))"
    }
  }

  func writeErrorMessage(from error: LoggableError) {
    errors.forEach {
      $0.errorMessage = error.analyticMessage
    }
  }

}

// MARK: - String Error

private extension DefaultLoggerService {

  struct StringError: LoggableError {

    let errorString: String?

    var analyticMessage: AnalyticMessage { errorString }

  }

}
