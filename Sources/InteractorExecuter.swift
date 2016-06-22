import Foundation

public class InteractorExecuter {
    var interactors = Dictionary<String, AnyObject>()
    
    public func registerInteractor<InteractorType: Interactor>(interactor: InteractorType, request: AnyObject) {
        let key = String(request)
        interactors[key] = InteractorWrapper(interactor: interactor)
    }
    
    public func execute<RequestType, ResponseType>(request:RequestType) -> ResponseType? {
        let interactor: InteractorWrapper<RequestType, ResponseType>? = self.findInteractorForRequest(request)
        return interactor?.execute(request)
    }
    
    private func findInteractorForRequest<RequestType, ResponseType>(request:RequestType) -> InteractorWrapper<RequestType, ResponseType>? {
        let key = String(request)
        let value = interactors[key]

        let interactor = value as? InteractorWrapper<RequestType, ResponseType>
    
        return interactor
    }
}
