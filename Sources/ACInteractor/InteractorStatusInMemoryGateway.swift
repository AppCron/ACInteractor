import Foundation

class InteractorStatusInMemoryGateway: InteractorStatusGateway {
    
    private var running = false
    
    func isRunning() -> Bool {
        return running
    }
    
    func setRunning(_ running: Bool) {
        self.running = running
    }
    
}
