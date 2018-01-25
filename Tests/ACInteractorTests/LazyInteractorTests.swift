import XCTest
@testable import ACInteractor

class LazyInteractorTests: XCTestCase {
    
    let testDependency = "testDependency"
    let testFactory = {return TestInteractor(dependency: "testDependency")}
    var lazyInteractor: LazyInteractor<TestInteractor>!
    
    override func setUp() {
        super.setUp()
        lazyInteractor = LazyInteractor(factory: testFactory)
    }
    
    // MARK: - Init
    
    func testInit_doesNotInitializeLazyInstance()
    {
        // Assert
        XCTAssertNil(lazyInteractor.lazyInstance)
    }
    
    // MARK: - getInteractor
    
    func testGetInteractor_returnsInstanceBuiltWithFactory()
    {
        // Act
        let interactor = lazyInteractor.getInteractor()
        
        // Assert
        XCTAssertEqual(interactor.dependency, testDependency)
    }
    
    
    func testGetInteractor_alwaysReturnsSameInstance()
    {
        // Act
        let firstInteractor = lazyInteractor.getInteractor()
        let secondInteractor = lazyInteractor.getInteractor()
        
        // Assert
        XCTAssert(firstInteractor === secondInteractor)
    }
    
    // MARK: - execute
    
    func testExceute_callsExecuteOfInteractor()
    {
        // Arrange
        let request = TestInteractor.Request()
        
        // Act
        lazyInteractor.execute(request)
        
        // Assert
        let interactor = lazyInteractor.lazyInstance
        XCTAssertEqual(interactor?.executedRequests.count, 1)
        XCTAssert(interactor?.executedRequests.first === request)
    }
    
    func testExecute_alwaysUsesSameInteractorInstance() {
        // Arrange
        let firstRequest = TestInteractor.Request()
        let secondRequest = TestInteractor.Request()
        
        // Act
        lazyInteractor.execute(firstRequest)
        lazyInteractor.execute(secondRequest)
        
        // Assert
        let interactor = lazyInteractor.lazyInstance
        XCTAssertEqual(interactor?.executedRequests.count, 2)
        XCTAssert(interactor?.executedRequests.first === firstRequest)
        XCTAssert(interactor?.executedRequests.last === secondRequest)
    }
    
}
