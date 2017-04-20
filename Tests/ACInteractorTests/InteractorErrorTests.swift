import XCTest
@testable import ACInteractor

class InteractorErrorTests: XCTestCase {
    
    let errorMessage = "errorMessage"
    var testError: NSError?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.testError = NSError(domain: "com.appcron", code: 42, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    }
    
    // MARK: - Init
    
    func testInit_withMessage_setsMessageAsLocalizedDescription() {
        // Act
        let error = InteractorError(message: errorMessage)
        
        // Assert
        XCTAssertEqual(error.localizedDescription, errorMessage)
        XCTAssertEqual(error.userInfo[NSLocalizedDescriptionKey] as? String, errorMessage)
    }
    
    func testInit_withCode_setsCode() {
        // Act
        let error = InteractorError(message: "", code: 42)
        
        // Assert
        XCTAssertEqual(error.code, 42)
    }
    
    // MARK: - Message
    
    func testMessage_returnsLocalizedDescription() {
        // Act
        let message = testError?.message
        
        // Assert
        XCTAssertEqual(message, "errorMessage")
    }
    
}
