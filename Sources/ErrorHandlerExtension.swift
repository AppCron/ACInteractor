import Foundation

public protocol ErrorHandler {
    func handleError(error: ErrorType)
}


public extension ErrorHandler where Self: Interactor {
    
    func handleError(error: ErrorType) {
        
    }
    
}
