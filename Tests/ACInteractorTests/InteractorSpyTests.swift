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
    
    // MARK: - Request Count
    
    func testIsCalledOnce_returnsTrue_whenCalledOnce() {
        var testData = [(executionCalls: Int, result: Bool)]()
        testData.append((executionCalls: 0, result: false))
        testData.append((executionCalls: 1, result: true))
        testData.append((executionCalls: 2, result: false))
        
        for test in testData {
            // Arrange
            for _ in 0..<test.executionCalls {
                spy.execute(firstRequest)
            }
            
            // Act
            let isCalledOnce = spy.isCalledOnce
            
            // Assert
            XCTAssertEqual(isCalledOnce, test.result)
        }
    }
    
    func testIsNeverCalled_returnsTrue_whenNeverCalled() {
        var testData = [(executionCalls: Int, result: Bool)]()
        testData.append((executionCalls: 0, result: true))
        testData.append((executionCalls: 1, result: false))
        
        for test in testData {
            // Arrange
            for _ in 0..<test.executionCalls {
                spy.execute(firstRequest)
            }
            
            // Act
            let isCalledOnce = spy.isNeverCalled
            
            // Assert
            XCTAssertEqual(isCalledOnce, test.result)
        }
    }
    
    // MARK: - Response Helper
    
    func testReturnsResponse_returnsFirstStoredResponse() {
        // Arrange
        let firstResponse = SampleResponse()
        let secondResponse = SampleResponse()
        spy.returnsResponses = [firstResponse, secondResponse]
        
        // Act
        let response = spy.returnsResponse
        
        // Assert
        XCTAssert(response === firstResponse)
    }
    
    func testSetReturnsResponse_storesResponse_overridesExistingOnes() {
        // Arange
        spy.returnsResponses = [SampleResponse(), SampleResponse()]
        let newResponse = SampleResponse()
        
        // Act
        spy.returnsResponse = newResponse
        
        // Assert
        XCTAssert(spy.returnsResponses.first === newResponse)
        XCTAssertEqual(spy.returnsResponses.count, 1)
    }
    
    func testReturnsError_returnsFirstStoredError() {
        // Arange
        let firstError = InteractorError()
        let secondError = InteractorError()
        spy.returnsErrors = [firstError, secondError]
        
        // Act
        let error = spy.returnsError
        
        // Assert
        XCTAssert(error === firstError)
    }
    
    func testSetReturnsError_storesError_overridesExistingOnes() {
        // Arange
        spy.returnsErrors = [InteractorError(), InteractorError()]
        let newError = InteractorError()
        
        // Act
        spy.returnsError = newError
        
        // Assert
        XCTAssert(spy.returnsErrors.first === newError)
        XCTAssertEqual(spy.returnsErrors.count, 1)
    }
    
}
