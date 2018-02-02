import XCTest
@testable import ACInteractor

class InteractorSpyTests: XCTestCase {
    
    class SampleRequest: InteractorRequest<SampleResponse> {}
    class SampleResponse {}
    
    let spy = InteractorSpy<SampleRequest>()
    
    let firstRequest = SampleRequest()
    let secondRequest = SampleRequest()
    
    var firstRequestResponse: SampleResponse?
    var secondRequestResponse: SampleResponse?
    var firstRequestError: InteractorError?
    var secondRequestError: InteractorError?
    
    let testError = InteractorError(message: "test error")
    
    override func setUp() {
        super.setUp()
        
        firstRequest.onComplete = { response in
            self.firstRequestResponse = response
        }
        
        firstRequest.onError = { error in
            self.firstRequestError = error
        }
        
        secondRequest.onComplete = { response in
            self.secondRequestResponse = response
        }
        
        secondRequest.onError = { error in
            self.secondRequestError = error
        }
    }
    
    // MARK: - Requests
    
    func testExecutedRequests_returnsExecutedRequests() {
        // Arrange
        spy.execute(firstRequest)
        spy.execute(secondRequest)
        
        // Act
        let executedRequests = spy.executedRequests
        
        // Assert
        XCTAssertEqual(executedRequests.count, 2)
        XCTAssert(executedRequests.first === firstRequest)
        XCTAssert(executedRequests.last === secondRequest)
    }
    
    // MARK: - Response
    
    func testExecute_callsOnComplete_withStoredResponses() {
        // Arrange
        let firstResponse = SampleResponse()
        let secondResponse = SampleResponse()
        spy.returnsResponses = [firstResponse, secondResponse]
        
        // Act
        spy.execute(firstRequest)
        spy.execute(secondRequest)
        
        // Assert
        XCTAssert(firstRequestResponse === firstResponse)
        XCTAssert(secondRequestResponse === secondResponse)
    }
    
    // MARK: - Error Handling
    
    func testExecute_callsOnError_withStoredErrors() {
        // Arrange
        let firstError = InteractorError()
        let secondError = InteractorError()
        spy.returnsErrors = [firstError, secondError]
        
        // Act
        spy.execute(firstRequest)
        spy.execute(secondRequest)
        
        // Assert
        XCTAssert(firstRequestError === firstError)
        XCTAssert(secondRequestError === secondError)
    }
    
    // MARK: - Mixed Responses and Errors
    
    func testExecute_callsOnComplete_afterAllErrorsHaveBeenReturned() {
        // Arrange
        let firstResponse = SampleResponse()
        let secondResponse = SampleResponse()
        spy.returnsResponses = [firstResponse, secondResponse]
        spy.returnsErrors = [testError]
        
        // Act
        spy.execute(firstRequest)
        spy.execute(secondRequest)
        
        // Assert
        XCTAssert(firstRequestResponse == nil)
        XCTAssert(firstRequestError === testError)
        
        XCTAssert(secondRequestResponse === firstResponse)
        XCTAssert(secondRequestError == nil)
    }
    
    func testExecute_callsOnComplete_whenNoErrorConstantIsUsed() {
        // Arrange
        let firstResponse = SampleResponse()
        let secondResponse = SampleResponse()
        spy.returnsResponses = [firstResponse, secondResponse]
        spy.returnsErrors = [spy.noError, testError]
        
        // Act
        spy.execute(firstRequest)
        spy.execute(secondRequest)
        
        // Assert
        XCTAssert(firstRequestResponse === firstResponse)
        XCTAssert(firstRequestError == nil)
        
        XCTAssert(secondRequestResponse == nil)
        XCTAssert(secondRequestError === testError)
    }
    
}
