import Foundation
import XCTest
import WolfBase

class BinarySearchTests: XCTestCase {
    func testBinarySearch() {
        let a = [1, 2, 3, 6, 8, 10, 12, 14, 18, 30]
        for (index, n) in a.enumerated() {
            let found = a.binarySearch(for: n)!
            XCTAssertEqual(found, index)
        }
        XCTAssertNil(a.binarySearch(for: -10))
        XCTAssertNil(a.binarySearch(for: 50))
        XCTAssertNil(a.binarySearch(for: 7))
    }
    
    func testUpperBound() {
        let a = [1, 2, 3, 6, 8, 10, 12, 14, 18, 30]
        XCTAssertEqual(a.upperBound(of: -10), 0)
        XCTAssertEqual(a.upperBound(of: 0), 0)
        XCTAssertEqual(a.upperBound(of: 1), 1)
        XCTAssertEqual(a.upperBound(of: 2), 2)
        XCTAssertEqual(a.upperBound(of: 5), 3)
        XCTAssertEqual(a.upperBound(of: 15), 8)
        XCTAssertEqual(a.upperBound(of: 29), 9)
        XCTAssertEqual(a.upperBound(of: 30), nil)
        XCTAssertEqual(a.upperBound(of: 31), nil)
    }
    
    func testLowerBound() {
        let a = [1, 2, 3, 6, 8, 10, 12, 14, 18, 30]
        XCTAssertEqual(a.lowerBound(of: -10), nil)
        XCTAssertEqual(a.lowerBound(of: 0), nil)
        XCTAssertEqual(a.lowerBound(of: 1), 0)
        XCTAssertEqual(a.lowerBound(of: 2), 1)
        XCTAssertEqual(a.lowerBound(of: 5), 3)
        XCTAssertEqual(a.lowerBound(of: 15), 8)
        XCTAssertEqual(a.lowerBound(of: 29), 9)
        XCTAssertEqual(a.lowerBound(of: 30), 9)
        XCTAssertEqual(a.lowerBound(of: 31), nil)
    }
    
    func testLowerUpperBound() {
        let a = [10, 10, 10, 20, 20, 20, 30, 30]
        let lower = a.lowerBound(of: 20)!
        let upper = a.upperBound(of: 20)!
        XCTAssertEqual(a[lower..<upper], [20, 20, 20])
    }
}
