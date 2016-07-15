import Foundation

public protocol Interactor {
    
    associatedtype RequestType

    func execute(request: RequestType)

}
