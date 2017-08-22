import XCTest
@testable import ACInteractor

class LazyInteractorTests: XCTestCase {
    
    let testDependency = "testDependency"
    let testFactory = {return TestInteractor(dependency: "testDependency")}
    var lazyInteractor: LazyInteractor<TestInteractor>!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        lazyInteractor = LazyInteractor(factory: testFactory)
    }
    
    // MARK: init()
    
    func testInit_doesNotInitializeLazyInstance()
    {
        // Assert
        XCTAssertNil(lazyInteractor.lazyInstance)
    }
    
    // MARK: getInteractor()
    
    func testGetInteractor_returnsInstanceBuiltWithFactory()
    {
        // Act
        let interactor = lazyInteractor.getInteractor()
        
        // Assert
        XCTAssertEqual(interactor.dependency, testDependency)
    }
    
    
    func testGetInteractor_calledTwice_doesNotCreateNewInstance()
    {
        // Act
        let firstInteractor = lazyInteractor.getInteractor()
        let secondInteractor = lazyInteractor.getInteractor()
        
        // Assert
        XCTAssert(firstInteractor === secondInteractor)
    }
    
    // MARK: execute()
    
    func testExceute_callsExecuteOfInteractor()
    {
        // Arrange
        let request = TestInteractor.Request()
        
        // Act
        lazyInteractor.execute(request)
        
        // Assert
        let interactor = lazyInteractor.getInteractor()
        XCTAssertEqual(interactor.numberOfExceuteCalls, 1)
        XCTAssert(interactor.executedRequest === request)
    }
    
    // MARK: handleError()
    
    func testHandleError_callsHandleErrorOfInteractor() {
        // Arrange
        let request = TestInteractor.Request()
        let error = InteractorError(message: "TestError")
        
        // Act
        lazyInteractor.handleError(request, error: error)
        
        // Assert
        let interactor = lazyInteractor.getInteractor()
        XCTAssert(interactor.handledErrorRequest === request)
        XCTAssert(interactor.handledError as AnyObject === error)
    }
    
    
    // MARK: Test Interactor
    
    class TestInteractor: Interactor {
        let dependency: String
        var numberOfExceuteCalls = 0
        var executedRequest: Request?
        
        var handledErrorRequest: ErrorRequest?
        var handledError: Error?
        
        init(dependency: String) {
            self.dependency = dependency
        }
    
        class Request: InteractorRequest<NSString> {
        }
    
        func execute(_ request: Request) {
            numberOfExceuteCalls += 1
            executedRequest = request
        }
        
        func handleError(_ request: ErrorRequest, error: Error) {
            handledErrorRequest = request
            handledError = error
        }
    }

}
