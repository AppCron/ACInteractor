import Foundation

protocol InteractorStatusGateway {
    func isRunning() -> Bool
    func setRunning(running: Bool)
}
