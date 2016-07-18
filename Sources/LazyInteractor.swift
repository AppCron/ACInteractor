import Foundation

class LazyInteractor<InteractorType: Interactor>: Interactor {
    
    private(set) var lazyInstance: InteractorType?
    
    init(factory:(Void -> InteractorType)) {
        
    }
    
    func execute(request: InteractorType.Request) {
        
    }
    
}
