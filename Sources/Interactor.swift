import Foundation

public protocol Interactor: AnyObject, ErrorHandler {
    associatedtype Request
    func execute(request: Request)
}
