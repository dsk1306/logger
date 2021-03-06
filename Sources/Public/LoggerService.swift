import Foundation

public protocol LoggerService: AnyObject {

  typealias OnOptOutHandler = () -> Bool

  var onOptOut: OnOptOutHandler? { get set }

  func log(error: String)
  func log(error: Error)
  func log(deinitOf object: Any)
  func log(items: Any...)

}
