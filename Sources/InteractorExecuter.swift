import Foundation

public class InteractorExecuter {
    var interactors = Dictionary<String, AnyObject>()
    
    public func execute<RequestType>(request:RequestType) {
        //TODO: Make magic happen
        
        let interactor: AnyObject = interactors[String(request)]!
 
        print("%@", interactor)
    }
    
    public func registerInteractor<InteractorType: Interactor>(interactor: InteractorType, request: AnyObject) {
        let key = String(request)
        interactors[key] = interactor
    }
}
