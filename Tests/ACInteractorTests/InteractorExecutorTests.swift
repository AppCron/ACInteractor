import XCTest
@testable import ACInteractor

class InteractorExecutorTests: XCTestCase {
    
    let executor = InteractorExecutor()
    
    let firstInteractor = FirstInteractor()
    let secondInteractor = SecondInteractor()
    let firstRequest = FirstInteractor.Request()
    let secondRequest = SecondInteractor.Request()
    
    var errorMessageFromFirstRequest: String?
    
    override func setUp() {
        super.setUp()
        
        firstRequest.onError = { [unowned self] (error: InteractorError) -> Void in
            self.errorMessageFromFirstRequest = error.message
        }
    }
    
    // MARK: - registerInteractor
    
    func testRegisterInteractor_succeeds(){
        // Act
        executor.registerInteractor(firstInteractor, request: firstRequest)
    }
    
    func testRegisterInteractor_callsErrorClosureOnRequest_whenInteractorDoesNotMatchRequest() {
        // Arrange
        executor.registerInteractor(secondInteractor, request: firstRequest)
        
        // Act
        executor.execute(firstRequest)
        
        // Assert
        let expected = "ACInteractor.ACInteractorExecutor: Request does not match execute function of registered Interactor!"
        XCTAssertEqual(errorMessageFromFirstRequest, expected)
    }
    
    // MARK: - execute
    
    func testExecute_callsExecuteOnInteractor_thatIsRegisteredForRequest() {
        // Arrange
        executor.registerInteractor(firstInteractor, request: FirstInteractor.Request.self)
        executor.registerInteractor(secondInteractor, request: SecondInteractor.Request.self)

        // Act
        executor.execute(firstRequest)
        executor.execute(secondRequest)

        // Assert
        XCTAssertEqual(firstInteractor.executedRequests.count, 1)
        XCTAssert(firstInteractor.executedRequests.first === firstRequest)

        XCTAssertEqual(secondInteractor.executedRequests.count, 1)
        XCTAssert(secondInteractor.executedRequests.first === secondRequest)
    }
    
    func testExecute_callsErrorOnRequest_whenNoInteractorIsRegisteredForRequestType() {
        // Arrange
        executor.registerInteractor(secondInteractor, request: secondRequest)

        // Act
        executor.execute(firstRequest)

        // Assert
        let expected = "ACInteractor.ACInteractorExecutor: No Interactor is registered for this request!"
        XCTAssertEqual(errorMessageFromFirstRequest, expected)
    }
    
    func testExecute_callsExecuteOnInteractor_thatIsRegisteredForRequestInstance() {
        // Arrange
        executor.registerInteractor(firstInteractor, request: firstRequest)
        executor.registerInteractor(secondInteractor, request: secondRequest)
        
        // Act
        executor.execute(firstRequest)
        executor.execute(secondRequest)
        
        // Assert
        XCTAssertEqual(firstInteractor.executedRequests.count, 1)
        XCTAssert(firstInteractor.executedRequests.first === firstRequest)
        
        XCTAssertEqual(secondInteractor.executedRequests.count, 1)
        XCTAssert(secondInteractor.executedRequests.first === secondRequest)
    }
    
    func testExecute_callsErrorOnRequest_whenNoInteractorIsRegisteredForRequestInstance() {
        // Arrange
        executor.registerInteractor(secondInteractor, request: secondRequest)
        
        // Act
        executor.execute(firstRequest)
        
        // Assert
        let expected = "ACInteractor.ACInteractorExecutor: No Interactor is registered for this request!"
        XCTAssertEqual(errorMessageFromFirstRequest, expected)
    }
    
    // MARK: - getInteractor
    
    func testGetInteractor_returnsInteractor_registeredForRequest() {
        // Arrange
        executor.registerInteractor(firstInteractor, request: firstRequest)
        executor.registerInteractor(secondInteractor, request: secondRequest)
        
        // Act
        let firstResult = executor.getInteractor(request: firstRequest)
        let secondResult = executor.getInteractor(request: secondRequest)
        
        // Assert
        XCTAssert(firstResult === firstInteractor)
        XCTAssert(secondResult === secondInteractor)
    }
    
    func testGetInteractor_returnsNil_whenNoInteractorIsRegisteredForRequest() {
        // Act
        let result = executor.getInteractor(request: firstRequest)
        
        // Assert
        XCTAssertNil(result)
    }
    
}
