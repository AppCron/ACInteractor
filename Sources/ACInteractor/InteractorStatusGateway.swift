import Foundation

public protocol InteractorStatusGateway {
    func isRunning() -> Bool
    func setRunning(_ running: Bool)
}
