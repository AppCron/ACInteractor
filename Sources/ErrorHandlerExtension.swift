import Foundation

public protocol ErrorHandler {
    func handleError(_ request: ErrorRequest, error: Error)
}


public extension ErrorHandler where Self: Interactor {
    
    @available(*, deprecated)
    func handleError(_ request: ErrorRequest, error: Error) {
        let error = error as InteractorError
        request.onError?(error)
    }

}
