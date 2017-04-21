import XCTest
@testable import ACInteractor

class MutableInteractorErrorTests: XCTestCase {
    
    var testError: MutableInteractorError?
    var testErrorDict = [String: Any]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        testError = MutableInteractorError(message: "")
        
        testErrorDict["key1"] = "value1"
        testErrorDict["key2"] = 2
    }
    
    // MARK: - Init
    
    func testInit_withMessage_setsMessage() {
        // Act
        let error = MutableInteractorError(message: "testMessage")
        
        // Assert
        XCTAssertEqual(error.message, "testMessage")
    }
    
    func testInit_withCode_setsCode() {
        // Act
        let error = MutableInteractorError(message: "", code: 42)
        
        // Assert
        XCTAssertEqual(error.code, 42)
    }
    
    func testInit_withDict_setsDict() {
        // Act
        let error = MutableInteractorError(message: "", code: 0, dict: testErrorDict)
        
        // Assert
        XCTAssertEqual(error.dict["key1"] as? String, "value1")
        XCTAssertEqual(error.dict["key2"] as? Int, 2)
    }
    
    // MARK: - Setters
    
    func testSetMessage_setsMessage() {
        // Act
        testError?.message = "newMessage"
        
        // Assert
        XCTAssertEqual(testError?.message, "newMessage")
    }
    
    func testSetCode_setCode() {
        // Act
        testError?.code = 42
        
        // Assert
        XCTAssertEqual(testError?.code, 42)
    }
    
    func testSetDict_setsDict() {
        // Act
        testError?.dict = testErrorDict
        
        // Assert
        XCTAssertEqual(testError?.dict["key1"] as? String, "value1")
        XCTAssertEqual(testError?.dict["key2"] as? Int, 2)
    }
    
    func testSetDictValue_addsDictValue() {
        // Arrange
        testError?.dict = testErrorDict
        
        // Act
        testError?.dict["newKey"] = "newValue"
        
        // Assert
        XCTAssertEqual(testError?.dict["newKey"] as? String, "newValue")
        XCTAssertEqual(testError?.dict.count, testErrorDict.count + 1)
    }
    
}
