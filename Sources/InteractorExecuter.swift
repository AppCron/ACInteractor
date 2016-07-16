import Foundation

public class InteractorExecuter {
    
    private var interactors = Dictionary<String, AnyObject>()
    
    public func registerInteractor<InteractorProtocol: Interactor, Response>
        (interactor: InteractorProtocol, request: InteractorRequest<Response>)
    {
        let key = String(request)
        self.interactors[key] = InteractorWrapper(interactor: interactor)
    }
    
    public func execute<Request: ErrorRequest>(request: Request) {
        
        let key = String(request)
        let optionalValue = interactors[key]
        
        guard let value = optionalValue else {
            request.onError?(NSError(domain: "", code: 1, userInfo: nil))
            return
        }
        
        if let wrapper = value as? InteractorWrapper<Request>
        {
            wrapper.execute(request)
        }
    }
    
}


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
