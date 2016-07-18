import Foundation

class LazyInteractor<InteractorType: Interactor>: Interactor {
    
    private(set) var lazyInstance: InteractorType?
    private let factory: (Void -> InteractorType)
    
    init(factory:(Void -> InteractorType)) {
        self.factory = factory
    }
    
    func getInteractor() -> InteractorType {
        if let instance = lazyInstance {
            return instance
        }
        
        let instance = factory()
        self.lazyInstance = instance
        
        return instance
    }
    
    func execute(request: InteractorType.Request) {
        
    }
    
}
