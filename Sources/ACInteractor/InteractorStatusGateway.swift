import Foundation

@available(*, deprecated, message: "InteractorStatusGateway will be removed in upcoming releases.")
public protocol InteractorStatusGateway {
    func isRunning() -> Bool
    func setRunning(_ running: Bool)
}
