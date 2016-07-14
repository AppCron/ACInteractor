import XCTest
@testable import ACInteractor

class InteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Test Interactor
    
    class TestInteractor: Interactor {
        var numberOfExceuteCalls = 0
        
        class Request {
        }
        
        func execute(request: Request) {
            numberOfExceuteCalls += 1
        }
    }
        
    // MARK: exceute
    
    func testExecute_withInteractorAndRequest_callsExecuteOnInteractor() {
        // Arrange
        let interactor = TestInteractor()
        let request = TestInteractor.Request()
        let executer = InteractorExecuter()
        executer.registerInteractor(interactor, request: request)
        
        // Act
        executer.execute(request)
        
        // Assert
        XCTAssertEqual(interactor.numberOfExceuteCalls, 1)
    }
    
    
    
    //test Two Requests no throw
}
