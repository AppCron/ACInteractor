import Foundation

class LazyInteractor<InteractorType: Interactor>: Interactor {
    
    private(set) var lazyInstance: InteractorType?
    private let factory: (() -> InteractorType)
    
    init(factory: @escaping (() -> InteractorType)) {
        self.factory = factory
    }
    
    func getInteractor() -> InteractorType {
        if let instance = lazyInstance {
            return instance
        }
        
        let instance = factory()
        lazyInstance = instance
        
        return instance
    }
    
    func execute(_ request: InteractorType.Request) {
        getInteractor().execute(request)
    }
    
}


extension LazyInteractor: ErrorHandler {
    
    func handleError(_ request: ErrorRequest, error: Error) {
        getInteractor().handleError(request, error: error)
    }
    
}
