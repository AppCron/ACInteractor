import XCTest
@testable import ACInteractor

class InteractorRequestTests: XCTestCase {
    
    var onCompleteWasCalled = false
    
    func testOnCompleteVoid_callsOnComplete() {
        // Arrange
        let voidRequest = InteractorRequest<Void>()
        var onCompleteWasCalled = false
        voidRequest.onComplete = { _ in onCompleteWasCalled = true }
        
        // Act
        voidRequest.onCompleteVoid()
        
        // Assert
        XCTAssert(onCompleteWasCalled)
    }
    
}
