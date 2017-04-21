import XCTest
@testable import ACInteractor

class InteractorErrorTests: XCTestCase {
    
    var testError: NSError?
    var testErrorDict = [String: Any]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        testError = NSError(domain: "com.appcron", code: 42, userInfo: [NSLocalizedDescriptionKey: "testMessage"])
        
        testErrorDict["key1"] = "value1"
        testErrorDict["key2"] = 2
    }
    
    // MARK: - Init
    
    func testInit_withMessage_setsMessageAsLocalizedDescription() {
        // Act
        let error = InteractorError(message: "testMessage")
        
        // Assert
        XCTAssertEqual(error.localizedDescription, "testMessage")
        XCTAssertEqual(error.userInfo[NSLocalizedDescriptionKey] as? String, "testMessage")
    }
    
    func testInit_withCode_setsCode() {
        // Act
        let error = InteractorError(message: "", code: 42)
        
        // Assert
        XCTAssertEqual(error.code, 42)
    }
    
    func testInit_withDict_setsDict() {
        // Act
        let error = InteractorError(message: "", code: 0, dict: testErrorDict)
        
        // Assert
        XCTAssertEqual(error.dict["key1"] as? String, "value1")
        XCTAssertEqual(error.dict["key2"] as? Int, 2)
    }
    
    // MARK: - Message
    
    func testMessage_returnsLocalizedDescription() {
        // Act
        let message = testError?.message
        
        // Assert
        XCTAssertEqual(message, "testMessage")
    }
    
}
