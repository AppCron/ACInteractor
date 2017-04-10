import XCTest
@testable import ACInteractor

class ACInteractorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(ACInteractor().text, "Hello, World!")
    }


    static var allTests : [(String, (ACInteractorTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
