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
    
    // MARK: - Init with Error
    
    func testInit_withNsError_copiesValuesFromNsError() {
        // Arrange
        let userInfo: [String: Any] = [NSLocalizedDescriptionKey: "localizedTestDescription", "key2": 2]
        let nsError = NSError(domain: "nserror.domain", code: 13, userInfo: userInfo)
        
        // Act
        let error = MutableInteractorError(error: nsError)
        
        // Assert
        XCTAssertEqual(error.message, nsError.message)
        XCTAssertEqual(error.localizedDescription, nsError.localizedDescription)
        
        XCTAssertEqual(error.code, nsError.code)
        XCTAssertEqual(error.domain, nsError.domain)
        
        XCTAssertEqual(error.userInfo[NSLocalizedDescriptionKey] as? String, "localizedTestDescription")
        XCTAssertEqual(error.userInfo["key2"] as? Int, 2)
    }

    func testInit_withInteractorError_copiesValuesFromInteractorError() {
        // Arrange
        let interactorError = InteractorError(message: "testMessage", code: 42, dict: testErrorDict)
        
        // Act
        let error = MutableInteractorError(error: interactorError)
        
        // Assert
        XCTAssertEqual(error.message, interactorError.message)
        XCTAssertEqual(error.localizedDescription, interactorError.localizedDescription)
        
        XCTAssertEqual(error.code, interactorError.code)
        XCTAssertEqual(error.domain, interactorError.domain)
        
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
