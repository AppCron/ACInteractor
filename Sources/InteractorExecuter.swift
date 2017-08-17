import Foundation

open class InteractorExecuter {
    
    fileprivate var interactors = Dictionary<String, AnyObject>()
    
    // MARK: Register
    
    open func registerInteractor<InteractorProtocol: Interactor, Response>
        (_ interactor: InteractorProtocol, request: InteractorRequest<Response>)
    {
        let key = String(describing: request)
        self.interactors[key] = InteractorWrapper(interactor: interactor)
    }
    
    // MARK: Execute
    
    open func execute<Request: ErrorRequest>(_ request: Request) {
        let key = String(describing: request)
        let optionalValue = interactors[key]
        
        guard let value = optionalValue else {
            self.fireIntactorNotRegisterdError(request)
            return
        }
        
        guard let wrapper = value as? InteractorWrapper<Request> else {
            self.fireIntactorMismatchError(request)
            return
        }
        
        wrapper.execute(request)
    }
    
    // MARK: Error Handling
    
    fileprivate func fireErrorOnRequest(_ request: ErrorRequest, errorMessage: String) {
        let error = InteractorError(message: errorMessage)
        request.onError?(error)
    }
    
    fileprivate func fireIntactorNotRegisterdError(_ request: ErrorRequest) {
        let message = "ACInteractor.ACInteractorExcuter: No Interactor is registered for this request!"
        self.fireErrorOnRequest(request, errorMessage: message)
    }
    
    fileprivate func fireIntactorMismatchError(_ request: ErrorRequest) {
        let message = "ACInteractor.ACInteractorExcuter: Request does not match execute function of registered Interactor!"
        self.fireErrorOnRequest(request, errorMessage: message)
    }
    
}


// MARK: Wrapper

// Wrapper class for interactors.
// This class is required as long as Swift does not support generic protocol types as variable types.
// For instance:
// let x: Interactor<RequestType> does not work
// let x: InteractorWrapper<RequestType> does work

private class InteractorWrapper<Request> {
    
    let executeClosure: (Request) -> Void
    let wrappedInteractor: AnyObject
    
    init<I: Interactor>(interactor: I) where I.Request == Request {
        self.executeClosure = interactor.execute
        self.wrappedInteractor = interactor
    }
    
    func execute(_ request: Request) {
        executeClosure(request)
    }
    
}
