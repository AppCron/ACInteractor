import Foundation
@testable import ACInteractor

class TestInteractor: Interactor {
    
    class Request: InteractorRequest<String> {
    }
    
    let dependency: String
    private(set) var executedRequests = [Request]()
    
    init(dependency: String) {
        self.dependency = dependency
    }
    
    func execute(_ request: Request) {
        executedRequests.append(request)
    }
    
}
