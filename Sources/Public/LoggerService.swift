import Foundation

public protocol LoggerService: AnyObject {

  typealias OnOptOutHandler = () -> Bool

  var onOptOut: OnOptOutHandler? { get set }

  func log(error: String, file: String, line: Int)
  func log(error: Error, file: String, line: Int)
  func log(deinitOf object: Any)
  func log(items: Any...)

}

public extension LoggerService {

  func log(error: String, file: String = #file, line: Int = #line) {
    log(error: error, file: file, line: line)
  }

  func log(error: Error, file: String = #file, line: Int = #line) {
    log(error: error, file: file, line: line)
  }

}
