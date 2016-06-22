import Foundation

// Wrapper class for interactors
// This class is required as long as Swift does not support generic protocol types as variable types.
// For instance:
// let x = Interactor<RequestType> does not work
// let x = InteractorWrapper<InputType> does work

class InteractorWrapper<InputType>: Interactor {
    let executeClosure: InputType -> Void
    let wrappedInteractor:AnyObject
    
     init<T: Interactor where T.RequestType == InputType>(interactor: T) {
        self.executeClosure = interactor.execute
        self.wrappedInteractor = interactor as! AnyObject
    }
    
     func execute(request:InputType) {
        executeClosure(request)
    }
    
}
