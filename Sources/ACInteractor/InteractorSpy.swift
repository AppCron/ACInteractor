import Foundation

class InteractorSpy<Request: InteractorRequestProtocol>: Interactor {
    
    var returnsResponses = [Request.Response]()
    var returnsErrors = [InteractorError]()
    
    let noError = InteractorError(message: "no error")
    
    private(set) var executedRequests = [Request]()
    
    func execute(_ request: Request) {
        executedRequests.append(request)
        
        if let error = returnsErrors.first {
            returnsErrors.remove(at: 0)
            
            if error != noError {
                request.onError?(error)
                return
            }
        }
        
        if let response = returnsResponses.first {
            returnsResponses.remove(at: 0)
            
            request.onComplete?(response)
            return
        }
    }
    
    // MARK: - Request Count
    
    var isCalledOnce: Bool {
        get {
            return executedRequests.count == 1
        }
    }
    
    var isNeverCalled: Bool {
        get {
            return executedRequests.count == 0
        }
    }
    
    // MARK: - Response Helper
    
    var returnsResponse: Request.Response? {
        get {
            return returnsResponses.first
        }
        set {
            returnsResponses.removeAll()
            if let response = newValue {
                returnsResponses.append(response)
            }
        }
    }
    
    var returnsError: InteractorError? {
        get {
            return returnsErrors.first
        }
        set {
            returnsErrors.removeAll()
            if let error = newValue {
                returnsErrors.append(error)
            }
        }
    }
    
}
