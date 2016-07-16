import Foundation

public protocol Interactor: AnyObject {
    associatedtype Request
    func execute(request: Request)
}
