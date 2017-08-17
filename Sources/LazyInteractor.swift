import Foundation

class LazyInteractor<InteractorType: Interactor>: Interactor {
    
    fileprivate(set) var lazyInstance: InteractorType?
    fileprivate let factory: ((Void) -> InteractorType)
    
    init(factory: @escaping ((Void) -> InteractorType)) {
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
