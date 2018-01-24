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
        XCTAssertEqual(interactor.executedRequests.count, 1)
        XCTAssert(interactor.executedRequests.first === request)
    }
    
}
