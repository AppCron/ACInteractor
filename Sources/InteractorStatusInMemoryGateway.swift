import Foundation

class InteractorStatusInMemoryGateway: InteractorStatusGateway {
    
    private var running = false
    
    func isRunning() -> Bool {
        return self.running
    }
    
    func setRunning(running: Bool) {
        self.running = running
    }
    
}
