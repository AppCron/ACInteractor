import Foundation

public protocol ErrorHandler {
    func handleError(request: ErrorRequest, error: ErrorType)
}


public extension ErrorHandler where Self: Interactor {
    
    func handleError(request: ErrorRequest, error: ErrorType) {
        if let error = error as? InteractorError {
            request.onError?(error)
        }
    }
    
}
