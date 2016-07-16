import Foundation

public protocol Interactor {
    
    associatedtype Request

    func execute(request: Request)

}
