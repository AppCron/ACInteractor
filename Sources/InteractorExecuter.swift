import Foundation

public class InteractorExecuter {
    
    private var interactors = Dictionary<String, AnyObject>()
    
    public func registerInteractor<InteractorProtocol: Interactor, Response>
        (interactor: InteractorProtocol, request: InteractorRequest<Response>)
    {
        let key = String(request)
        self.interactors[key] = InteractorWrapper(interactor: interactor)
    }
    
    public func execute<Request>(request: Request) {
        let interactor = self.interactorForRequest(request)
        interactor?.execute(request)
    }
    
    private func interactorForRequest<T>(request:T) -> InteractorWrapper<T>? {
        let key = String(request)
        let value = interactors[key]

        let interactor = value as? InteractorWrapper<T>
    
        return interactor
    }
    
}
