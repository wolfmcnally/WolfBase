import XCTest
import WolfBase

final class NumericTests: XCTestCase {
    func testFloatingPointExtensions() {
        XCTAssertEqual((1.1).clamped(), 1.0)
        XCTAssertEqual((-0.1).clamped(), 0.0)
    }
    
    func testComparableExtensions() {
        XCTAssertEqual(10.clamped(to: 0...5), 5)
        XCTAssertEqual((10.5).clamped(to: (0.0)...(5.5)), 5.5)
        XCTAssertEqual(Character("Z").clamped(to: Character("A")...Character("F")), "F")
    }
}
