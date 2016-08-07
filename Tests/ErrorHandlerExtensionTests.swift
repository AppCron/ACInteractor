import XCTest
@testable import ACInteractor

class ErrorHandlerExtensionTests: XCTestCase {
    
    let interactor = TestInteractor()
    let request = TestInteractor.Request()
    var onErrorResponse: ErrorType?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        request.onError = { [unowned self] (error: ErrorType) in
            self.onErrorResponse = error
        }
    }
    
    // MARK: handleError()
    
    func testHandleError_withInteractorError_callsOnError_withInteractorError() {
        // Arrange
        let error = InteractorError(message: "TestError")
        
        // Act
        interactor.handleError(request, error: error)
        
        // Assert
        let errorResponse = onErrorResponse as? InteractorError
        XCTAssert(errorResponse === error)
    }
    
    func testHandleError_withNsError_callsOnError_withWrappedNsError() {
        // Arrange
        let nsErrorMessage = "NSError Message"
        let nsError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: nsErrorMessage])
        
        // Act
        interactor.handleError(request, error: nsError)
        
        // Assert
        let errorResponse = onErrorResponse as? InteractorError
        XCTAssertEqual(errorResponse?.message, nsErrorMessage)
        XCTAssert(errorResponse?.nsError === nsError)
    }

    
    // MARK: Test Interactor
    
    class TestInteractor: Interactor {
        class Request: InteractorRequest<Void> {
        }
        
        func execute(request: Request) {
        }
    }
    
    
    // MARK: Test Error
    
    class TestError: ErrorType {
    }
        
}
