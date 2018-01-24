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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        firstRequest.onError = { [unowned self] (error: InteractorError) -> Void in
            self.errorMessageFromFirstRequest = error.message
        }
    }
    
    // MARK: registerInteractor
    
    func testRegisterInteractor_succeeds(){
        // Act
        executor.registerInteractor(firstInteractor, request: firstRequest)
    }
    
    // MARK: execute
    
    func testExecute_withInteractorAndRequest_callsExecuteOnInteractor() {
        // Arrange
        executor.registerInteractor(firstInteractor, request: firstRequest)
        
        // Act
        executor.execute(firstRequest)
        
        // Assert
        XCTAssertEqual(firstInteractor.numberOfExceuteCalls, 1)
        XCTAssert(firstInteractor.executedRequest === firstRequest)
    }
    
    func testExecute_withTwoInteractors_executeOnSecond_callsExecuteOnSecondInteractor() {
        // Arrange
        executor.registerInteractor(firstInteractor, request: firstRequest)
        executor.registerInteractor(secondInteractor, request: secondRequest)
        
        // Act
        executor.execute(secondRequest)
        
        // Assert
        XCTAssertEqual(secondInteractor.numberOfExceuteCalls, 1)
        XCTAssert(secondInteractor.executedRequest === secondRequest)
    }
    
    func testExecute_withTwoInteractors_executeOnBoth_callsExecuteOnEachInteractor() {
        // Arrange
        executor.registerInteractor(firstInteractor, request: firstRequest)
        executor.registerInteractor(secondInteractor, request: secondRequest)
        
        // Act
        executor.execute(firstRequest)
        executor.execute(secondRequest)
        
        // Assert
        XCTAssertEqual(firstInteractor.numberOfExceuteCalls, 1)
        XCTAssert(firstInteractor.executedRequest === firstRequest)
        
        XCTAssertEqual(secondInteractor.numberOfExceuteCalls, 1)
        XCTAssert(secondInteractor.executedRequest === secondRequest)
    }
    
    func testExecute_withUnknownRequest_callsErrorOnRequest() {
        // Act
        executor.execute(firstRequest)
        
        // Assert
        let expected = "ACInteractor.ACInteractorExecutor: No Interactor is registered for this request!"
        XCTAssertEqual(errorMessageFromFirstRequest, expected)
    }
    
    func testExecute_withMismatchRequest_callsErrorOnRequest() {
        // Arrange
        executor.registerInteractor(secondInteractor, request: firstRequest)
        
        // Act
        executor.execute(firstRequest)
        
        // Assert
        let expected = "ACInteractor.ACInteractorExecutor: Request does not match execute function of registered Interactor!"
        XCTAssertEqual(errorMessageFromFirstRequest, expected)
    }
    
    
    // MARK: Test Interactors
    
   class FirstInteractor: Interactor {
        var numberOfExceuteCalls = 0
        var executedRequest: Request?
        
        class Request: InteractorRequest<NSString> {
        }
        
    func execute(_ request: Request) {
        numberOfExceuteCalls += 1
        executedRequest = request
        }
    }
    
    class SecondInteractor: Interactor {
        var numberOfExceuteCalls = 0
        var executedRequest: Request?
        
        class Request: InteractorRequest<NSString> {
        }
        
        func execute(_ request: Request) {
            numberOfExceuteCalls += 1
            executedRequest = request
        }
    }
    
}


