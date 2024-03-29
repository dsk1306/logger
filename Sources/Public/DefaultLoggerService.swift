import Bugsnag
import Foundation

public final class DefaultLoggerService {

  // MARK: - Properties

  public var onOptOut: OnOptOutHandler?

  // MARK: - Initialization

  public init(onOptOut: OnOptOutHandler? = nil) {
    self.onOptOut = onOptOut
  }

}

// MARK: - Public Methods

public extension DefaultLoggerService {

  func start(releaseStage: LoggerReleaseStage, apiKey: String) {
    let configuration = BugsnagConfiguration(apiKey)
    configuration.releaseStage = releaseStage.stringValue
    configuration.addOnSendError { [weak self] _ in
      // Prevent logging if opt-out.
      if self?.onOptOut?() == true { return false }
      // Otherwise report error.
      return true
    }

    Bugsnag.start(with: configuration)
  }

}

// MARK: - LoggerService

extension DefaultLoggerService: LoggerService {

  public func log(error: String, file: String, line: Int) {
    let error = StringError(analyticMessage: error)
    log(error: error, file: file, line: line)
  }

  public func log(error: Error, file: String, line: Int) {
    if let error = error as? LoggableError {
      guard error.shouldReport else { return }
      Bugsnag.notifyError(error) { report in
        report.writeErrorClass(from: error)
        report.writeParameters(from: error)
        report.writeContext(file: file, line: line)
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
    if let errorCode = error.errorCode {
      addMetadata(
        errorCode,
        key: "errorCode",
        section: DefaultLoggerService.Constant.sectionName
      )
    }
    guard let parameters = error.analyticParameters else { return }
    for (key, value) in parameters {
      addMetadata(
        value,
        key: key,
        section: DefaultLoggerService.Constant.sectionName
      )
    }
  }

  func writeContext(file: String, line: Int) {
    var file = file
    if let component = file.components(separatedBy: "/").last {
      file = component
    }
    if let component = file.components(separatedBy: ".").first {
      file = component
    }
    self.context = [file, "Line \(line)"].joined(separator: " ")
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

extension DefaultLoggerService {

  struct StringError: LoggableError {

    let analyticMessage: AnalyticMessage

  }

}
