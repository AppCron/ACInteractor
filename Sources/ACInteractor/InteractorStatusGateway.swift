import Foundation

protocol InteractorStatusGateway {
    func isRunning() -> Bool
    func setRunning(_ running: Bool)
}
