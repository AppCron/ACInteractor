import Foundation

class InteractorSpy<Request: InteractorRequestProtocol>: Interactor {
    
    var returnsResponses = [Request.Response]()
    var returnsErrors = [InteractorError]()
    
    let noError = InteractorError(message: "no error")
    
    private(set) var executedRequests = [Request]()
    
    func execute(_ request: Request) {
        
    }
    
}
