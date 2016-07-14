import Foundation

public class InteractorExecuter {
    private var interactors = Dictionary<String, AnyObject>()
    
    public func registerInteractor<InteractorType: Interactor>(interactor: InteractorType, request: AnyObject) {
        let key = String(request.dynamicType)
        self.interactors[key] = InteractorWrapper(interactor: interactor)
    }
    
    public func execute<RequestType>(request: RequestType) {
        let anyInteractor = self.interactors.first?.1;
        let interactor = anyInteractor as? InteractorWrapper<RequestType>
        interactor?.execute(request)
    }
    
    /*
    private func findInteractorForRequest<T>(request:T) -> InteractorWrapper<T>? {
        let key = String(request)
        let value = interactors[key]

        let interactor = value as? InteractorWrapper<T>
    
        return interactor
    }
     */
}
