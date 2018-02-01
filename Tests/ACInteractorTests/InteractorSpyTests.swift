import XCTest
@testable import ACInteractor

class InteractorSpyTests: XCTestCase {
    
    class SampleRequest: InteractorRequest<SampleResponse> {}
    class SampleResponse {}
    
    let spy = InteractorSpy<SampleRequest>()
    
    let firstRequest = SampleRequest()
    let secondRequest = SampleRequest()
    let firstResponse = SampleResponse()
    let secondResponse = SampleResponse()
    
    override func setUp() {
        super.setUp()
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
    
    // MARK: - Error Handling
    
}
