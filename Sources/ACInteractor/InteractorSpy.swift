import Foundation

public class InteractorSpy<Request: InteractorRequestProtocol>: Interactor {
    
    public var returnsResponses = [Request.Response]()
    public var returnsErrors = [InteractorError]()
    
    public let noError = InteractorError(message: "no error")
    
    public private(set) var executedRequests = [Request]()

    public init() {}
    
    public func execute(_ request: Request) {
        executedRequests.append(request)
        
        if let error = returnsErrors.first {
            returnsErrors.remove(at: 0)
            
            if error != noError {
                request.onComplete?(.failure(error))
                return
            }
        }
        
        if let response = returnsResponses.first {
            if returnsResponses.count > 1 {
                returnsResponses.remove(at: 0)
            }
            
            request.onComplete?(.success(response))
            return
        }
    }
    
    public func reset() {
        executedRequests.removeAll()
        returnsResponses.removeAll()
        returnsErrors.removeAll()
    }

    // MARK: - Request Count
    
    public var lastRequest: Request? {
        get {
            return executedRequests.last
        }
    }
    
    public var isCalledOnce: Bool {
        get {
            return executedRequests.count == 1
        }
    }
    
    public var isNeverCalled: Bool {
        get {
            return executedRequests.count == 0
        }
    }
    
    // MARK: - Response Helper
    
    public var returnsResponse: Request.Response? {
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
    
    public var returnsError: InteractorError? {
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
