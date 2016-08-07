import Foundation

public protocol ErrorHandler {
    func handleError(request: ErrorRequest, error: ErrorType)
}


public extension ErrorHandler where Self: Interactor {
    
    func handleError(request: ErrorRequest, error: ErrorType) {
        
    }
    
}
