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
