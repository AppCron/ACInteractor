import XCTest
@testable import ACInteractor

class InteractorTests: XCTestCase {
    
    let executer = InteractorExecuter()
    
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
        executer.registerInteractor(firstInteractor, request: firstRequest)
    }
    
    // MARK: execute
    
    func testExecute_withInteractorAndRequest_callsExecuteOnInteractor() {
        // Arrange
        executer.registerInteractor(firstInteractor, request: firstRequest)
        
        // Act
        executer.execute(firstRequest)
        
        // Assert
        XCTAssertEqual(firstInteractor.numberOfExceuteCalls, 1)
        XCTAssert(firstInteractor.executedRequest === firstRequest)
    }
    
    func testExecute_withTwoInteractors_executeOnSecond_callsExecuteOnSecondInteractor() {
        // Arrange
        executer.registerInteractor(firstInteractor, request: firstRequest)
        executer.registerInteractor(secondInteractor, request: secondRequest)
        
        // Act
        executer.execute(secondRequest)
        
        // Assert
        XCTAssertEqual(secondInteractor.numberOfExceuteCalls, 1)
        XCTAssert(secondInteractor.executedRequest === secondRequest)
    }
    
    func testExecute_withTwoInteractors_executeOnBoth_callsExecuteOnEachInteractor() {
        // Arrange
        executer.registerInteractor(firstInteractor, request: firstRequest)
        executer.registerInteractor(secondInteractor, request: secondRequest)
        
        // Act
        executer.execute(firstRequest)
        executer.execute(secondRequest)
        
        // Assert
        XCTAssertEqual(firstInteractor.numberOfExceuteCalls, 1)
        XCTAssert(firstInteractor.executedRequest === firstRequest)
        
        XCTAssertEqual(secondInteractor.numberOfExceuteCalls, 1)
        XCTAssert(secondInteractor.executedRequest === secondRequest)
    }
    
    func testExecute_withUnknownRequest_callsErrorOnRequest() {
        // Act
        executer.execute(firstRequest)
        
        // Assert
        let expected = "ACInteractor.ACInteractorExcuter: No Interactor is registered for this request!"
        XCTAssertEqual(errorMessageFromFirstRequest, expected)
    }
    
    func testExecute_withMismatchRequest_callsErrorOnRequest() {
        // Arrange
        executer.registerInteractor(secondInteractor, request: firstRequest)
        
        // Act
        executer.execute(firstRequest)
        
        // Assert
        let expected = "ACInteractor.ACInteractorExcuter: Request does not match execute function of registered Interactor!"
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


