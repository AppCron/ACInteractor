import Foundation

// Wrapper class for interactors.
// This class is required as long as Swift does not support generic protocol types as variable types.
// For instance:
// let x = Interactor<RequestType> does not work
// let x = InteractorWrapper<RequestType> does work

class InteractorWrapper<Request> {
    
    let executeClosure: Request -> Void
    let wrappedInteractor:AnyObject
    
     init<I: Interactor where I.Request == Request>(interactor: I) {
        self.executeClosure = interactor.execute
        self.wrappedInteractor = interactor
    }
    
     func execute(request: Request) {
        executeClosure(request)
    }
    
}
