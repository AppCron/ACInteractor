import XCTest
@testable import ACInteractor

class InteractorErrorTests: XCTestCase {
    
    let errorMessage = "errorMessage"
    var nsError: NSError!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.nsError = NSError(domain: "com.appcron", code: 42, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    }
    
    // MARK: init
    
    func testInit_withMessage_setsMessage() {
        // Act
        let error = InteractorError(message: errorMessage)
        
        // Assert
        XCTAssertEqual(error.message, errorMessage)
    }
    
    func testInit_withNsError_setsMessage() {
        // Act
        let error = InteractorError(error: nsError)
        
        // Assert
        XCTAssertEqual(error.message, errorMessage)
    }
    
    func testInit_withNsError_setsNsError() {
        // Act
        let error = InteractorError(error: nsError)
        
        // Assert
        XCTAssertEqual(error.nsError, nsError)
    }
    
}
