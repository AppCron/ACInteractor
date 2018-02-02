import Foundation

class InteractorSpy<Request: InteractorRequestProtocol>: Interactor {
    
    var returnsResponses = [Request.Response]()
    var returnsErrors = [InteractorError]()
    
    let noError = InteractorError(message: "no error")
    
    private(set) var executedRequests = [Request]()
    
    func execute(_ request: Request) {
        executedRequests.append(request)
        
        if let response = returnsResponses.first {
            returnsResponses.remove(at: 0)
            request.onComplete?(response)
        }
        
        if let error = returnsErrors.first {
            returnsErrors.remove(at: 0)
            request.onError?(error)
        }
    }
    
}
