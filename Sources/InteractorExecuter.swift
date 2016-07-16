import Foundation

public class InteractorExecuter {
    
    private var interactors = Dictionary<String, AnyObject>()
    
    // MARK: Register
    
    public func registerInteractor<InteractorProtocol: Interactor, Response>
        (interactor: InteractorProtocol, request: InteractorRequest<Response>)
    {
        let key = String(request)
        self.interactors[key] = InteractorWrapper(interactor: interactor)
    }
    
    // MARK: Execute
    
    public func execute<Request: ErrorRequest>(request: Request) {
        let key = String(request)
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
    
    private func fireErrorOnRequest(request: ErrorRequest, errorMessage: String) {
        let error = InteractorError(message: errorMessage)
        request.onError?(error)
    }
    
    private func fireIntactorNotRegisterdError(request: ErrorRequest) {
        let message = "ACInteractor.ACInteractorExcuter: No Interactor is registered for this request!"
        self.fireErrorOnRequest(request, errorMessage: message)
    }
    
    private func fireIntactorMismatchError(request: ErrorRequest) {
        let message = "ACInteractor.ACInteractorExcuter: Request does not match execute function of registered Interactor!"
        self.fireErrorOnRequest(request, errorMessage: message)
    }
    
}


// MARK: Wrapper

// Wrapper class for interactors.
// This class is required as long as Swift does not support generic protocol types as variable types.
// For instance:
// let x = Interactor<RequestType> does not work
// let x = InteractorWrapper<RequestType> does work

private class InteractorWrapper<Request> {
    
    let executeClosure: Request -> Void
    let wrappedInteractor: AnyObject
    
    init<I: Interactor where I.Request == Request>(interactor: I) {
        self.executeClosure = interactor.execute
        self.wrappedInteractor = interactor
    }
    
    func execute(request: Request) {
        executeClosure(request)
    }
    
}
