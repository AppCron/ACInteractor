import Foundation

public protocol ErrorHandler {
    func handleError(_ request: ErrorRequest, error: Error)
}


public extension ErrorHandler where Self: Interactor {
    
    func handleError(_ request: ErrorRequest, error: Error) {
        if let error = error as? InteractorError {
            request.onError?(error)
        } else {
            let nsError = error as NSError
            let errorWrapper = InteractorError(error: nsError)
            request.onError?(errorWrapper)
        }
    }

}
