import XCTest
@testable import ACInteractor

class LazyInteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    // MARK: Init
    
    func testInit_doesNotInitializeLazyInstance()
    {
        // Arrange
        let factory = {return TestInteractor(dependency: "")}
        
        // Act
        let lazyInteractor = LazyInteractor(factory: factory)
        
        // Assert
        XCTAssertNil(lazyInteractor.lazyInstance)
    }
    
    
    
    // MARK: Test Interactors
    
    class TestInteractor: Interactor {
        let dependency: String
        
        init(dependency: String) {
            self.dependency = dependency
        }
    
        class Request: InteractorRequest<NSString> {
        }
    
        func execute(request: Request) {
        }
    }

}
