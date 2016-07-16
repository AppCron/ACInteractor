import XCTest
@testable import ACInteractor

class InteractorTests: XCTestCase {
    
    let executer = InteractorExecuter()
    
    let firstInteractor = FirstInteractor()
    let secondInteractor = SecondInteractor()
    let firstRequest = FirstInteractor.Request()
    let secondRequest = SecondInteractor.Request()
    
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
    }
    
    func testExecute_withTwoInteractors_executeOnSecond_callsExecuteOnSecondInteractor() {
        // Arrange
        executer.registerInteractor(firstInteractor, request: firstRequest)
        executer.registerInteractor(secondInteractor, request: secondRequest)
        
        // Act
        executer.execute(secondRequest)
        
        // Assert
        XCTAssertEqual(secondInteractor.numberOfExceuteCalls, 1)
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
        XCTAssertEqual(secondInteractor.numberOfExceuteCalls, 1)
    }
    
    func testExecute_withUnknownRequest_callsErrorOnRequest() {
        // Arrange
        var errorMessage = ""
        firstRequest.onError = { (error: InteractorError) -> Void in
            errorMessage = error.message
        }
        
        // Act
        executer.execute(firstRequest)
        
        // Assert
        XCTAssertEqual(errorMessage, "ACInteractor.ACInteractorExcuter: No Interactor is registered for this request!")
    }
    
    // MARK: Test Interactors
    
    class TestIntactor {
        init() {
            print("initT")
        }
        var numberOfExceuteCalls = 0
        
        func testExecute() {
            numberOfExceuteCalls += 1
        }
    }
    
    class FirstInteractor: TestIntactor, Interactor {
        class Request: InteractorRequest<NSString> {
        }
        
        func execute(request: Request) {
            self.testExecute()
        }
    }
    
    class SecondInteractor: TestIntactor, Interactor {
        class Request: InteractorRequest<NSString> {
        }
        
        func execute(request: Request) {
            self.testExecute()
        }
    }
    
}
