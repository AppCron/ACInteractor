import Foundation

public protocol Interactor {
    associatedtype RequestType
    associatedtype ResponseType
    
    func execute(request: RequestType) -> ResponseType
}
