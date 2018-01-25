import XCTest
@testable import ACInteractor

@available(*, deprecated, message: "InteractorStatusInMemoryGateway will be removed in upcoming releases.")
class InteractorStatusInMemoryGatewayTests: XCTestCase {
    
    let gateway = InteractorStatusInMemoryGateway()
    
    // MARK: isRunning()
    
    func testIsRunning_retursFalseByDefault() {
        // Act
        let running = gateway.isRunning()
        
        // Assert
        XCTAssertEqual(running, false)
    }
    
    func testIsRunning_afterSettingTrue_returnsTrue() {
        // Arrange
        gateway.setRunning(true)
        
        // Act
        let running = gateway.isRunning()
        
        // Assert
        XCTAssertEqual(running, true)
    }
    
    func testIsRunning_afterSettingFalse_returnsFalse() {
        // Arrange
        gateway.setRunning(false)
        
        // Act
        let running = gateway.isRunning()
        
        // Assert
        XCTAssertEqual(running, false)
    }
    
}
