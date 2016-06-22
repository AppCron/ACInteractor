import Foundation

public class InteractorExecuter {
    var interactors = Dictionary<String, AnyObject>()
    
    public func registerInteractor<InteractorType: Interactor>(interactor: InteractorType, request: AnyObject) {
        let key = String(request)
        interactors[key] = InteractorWrapper(interactor: interactor)
    }
    
    public func execute<T>(request:T) {
        let interactor: InteractorWrapper<T>? = self.findInteractorForRequest(request)
        interactor?.execute(request)
    }
    
    private func findInteractorForRequest<T>(request:T) -> InteractorWrapper<T>? {
        let key = String(request)
        let value = interactors[key]

        let interactor = value as? InteractorWrapper<T>
    
        return interactor
    }
}
