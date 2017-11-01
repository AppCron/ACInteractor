import Foundation

public class InteractorStatusInMemoryGateway: InteractorStatusGateway {
    
    private var running = false
    
    public func isRunning() -> Bool {
        return running
    }
    
    public func setRunning(_ running: Bool) {
        self.running = running
    }
    
}
