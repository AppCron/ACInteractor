import Foundation

@available(*, deprecated, renamed: "InteractorExecutor")
typealias InteractorExecuter = InteractorExecutor

open class InteractorExecutor {
    
    private var interactors = Dictionary<String, AnyObject>()

    public init() {}

    // MARK: - Register
    
    open func registerInteractor<InteractorProtocol: Interactor, RequestProtocol: InteractorRequestProtocol>
        (_ interactor: InteractorProtocol, request: RequestProtocol.Type)
    {
        let key = String(reflecting: request)
        interactors[key] = InteractorWrapper(interactor: interactor)
    }
    
    @available(*, deprecated, message: "Use MyInteractor.Request.self as request parameter.")
    open func registerInteractor<InteractorProtocol: Interactor, Response>
        (_ interactor: InteractorProtocol, request: InteractorRequest<Response>)
    {
        registerInteractor(interactor, request: type(of: request))
    }
    
    // MARK: - Execute
    
    open func execute<Request: InteractorRequestProtocol>(_ request: Request) {
        let key = String(reflecting: request)
        let optionalValue = interactors[key]
        
        guard let value = optionalValue else {
            fireInteractorNotRegisterdError(request)
            return
        }
        
        guard let wrapper = value as? InteractorWrapper<Request> else {
            fireInteractorMismatchError(request)
            return
        }
        
        wrapper.execute(request)
    }
    
    // MARK: - GetInteractor
    
    open func getInteractor<Request: InteractorRequestProtocol>(request: Request) -> AnyObject? {
        let key = String(reflecting: request)
        let optional = interactors[key]
        
        guard let wrapper = optional as? InteractorWrapper<Request> else {
            return nil
        }
        
        return wrapper.wrappedInteractor
    }
    
    // MARK: - Error Handling
    
    private func fireErrorOnRequest(_ request: ErrorRequestProtocol, errorMessage: String) {
        let error = InteractorError(message: errorMessage)
        request.onError?(error)
    }
    
    private func fireInteractorNotRegisterdError(_ request: ErrorRequestProtocol) {
        let message = "ACInteractor.ACInteractorExecutor: No Interactor is registered for this request!"
        fireErrorOnRequest(request, errorMessage: message)
    }
    
    private func fireInteractorMismatchError(_ request: ErrorRequestProtocol) {
        let message = "ACInteractor.ACInteractorExecutor: Request does not match execute function of registered Interactor!"
        fireErrorOnRequest(request, errorMessage: message)
    }
    
}


// MARK: Wrapper

// Wrapper class for interactors.
// This class is required as long as Swift does not support generic protocol types as variable types.
// For instance:
// let x: Interactor<RequestType> does not work
// let x: InteractorWrapper<RequestType> does work

private class InteractorWrapper<Request> {
    
    let executeClosure: (Request) -> Void
    let wrappedInteractor: AnyObject
    
    init<I: Interactor>(interactor: I) where I.Request == Request {
        self.executeClosure = interactor.execute
        self.wrappedInteractor = interactor
    }
    
    func execute(_ request: Request) {
        executeClosure(request)
    }
    
}
