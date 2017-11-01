import Foundation

public class LazyInteractor<InteractorType: Interactor>: Interactor {
    
    private(set) var lazyInstance: InteractorType?
    private let factory: (() -> InteractorType)
    
    public init(factory: @escaping (() -> InteractorType)) {
        self.factory = factory
    }
    
    public func getInteractor() -> InteractorType {
        if let instance = lazyInstance {
            return instance
        }
        
        let instance = factory()
        lazyInstance = instance
        
        return instance
    }
    
    public func execute(_ request: InteractorType.Request) {
        getInteractor().execute(request)
    }
    
}


extension LazyInteractor: ErrorHandler {
    
    public func handleError(_ request: ErrorRequest, error: Error) {
        getInteractor().handleError(request, error: error)
    }
    
}
