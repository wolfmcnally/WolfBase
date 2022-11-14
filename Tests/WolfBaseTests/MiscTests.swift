import XCTest
import WolfBase

final class MiscTests: XCTestCase {
    func testByteBufferUtils() {
        struct A: Equatable {
            let a: UInt8
            let b: UInt8
            let c: UInt8
            let d: UInt8
        }
        
        let a = A(a: 10, b: 20, c: 30, d: 40)
        
        let x = withUnsafeByteBuffer(of: a) { unsafeBufferPointer -> Bool in
            XCTAssertEqual(Array(unsafeBufferPointer), [10, 20, 30, 40])
            return true
        }
        XCTAssertTrue(x)
        
        var b = A(a: 50, b: 60, c: 70, d: 80)
        
        let y = withUnsafeMutableByteBuffer(of: &b) { unsafeMutableBufferPointer -> Bool in
            unsafeMutableBufferPointer[0] = 10
            unsafeMutableBufferPointer[1] = 20
            unsafeMutableBufferPointer[2] = 30
            unsafeMutableBufferPointer[3] = 40
            return true
        }
        XCTAssertTrue(y)
        XCTAssertEqual(a, b)
    }
    
    func testCodableExtensions() throws {
        struct A: Codable, Equatable {
            let a: String
            let b: Int
        }
        
        let a = A(a: "Hello", b: 10)
        let s = #"{"a":"Hello","b":10}"#
        let d = a.json
        
        XCTAssertEqual(a.jsonString, s)
        XCTAssertEqual(s.utf8Data, a.json)
        try XCTAssertEqual(fromJSON(A.self, a.json), a)
        try XCTAssertEqual(fromJSON(A.self, a.jsonString), a)
        try XCTAssertEqual(A.fromJSON(d), a)
        try XCTAssertEqual(A.fromJSON(s), a)
        try XCTAssertEqual(d.fromJSON(to: A.self), a)
        try XCTAssertEqual(s.fromJSON(to: A.self), a)
    }

    func testOptionalExtensions() {
        let a: String? = "Hello"
        let b: String? = nil
        XCTAssertTrue(a.isSome)
        XCTAssertFalse(a.isNone)
        XCTAssertFalse(b.isSome)
        XCTAssertTrue(b.isNone)
        XCTAssertEqual(a.unwrap() as! String, "Hello")
        XCTAssertEqual(a.unwrap(String.self), "Hello")
        XCTAssertEqual(unwrap(a) as! String, "Hello")
        XCTAssertEqual(unwrap(String.self, a), "Hello")
        XCTAssertEqual(a†, "Hello")
        XCTAssertEqual(b†, "nil")
    }
    
    func testRangeExtensions() {
        let cfRange = CFRange(location: 10, length: 20)
        let nsRange = NSRange(location: 10, length: 20)
        let range = 10 ..< 30
        
        XCTAssertEqual(NSRange(range), nsRange)
        XCTAssertEqual(NSRange(cfRange), nsRange)
        
        XCTAssertEqual(CFRange(range), cfRange)
        XCTAssertEqual(CFRange(nsRange), cfRange)
        
        XCTAssertEqual(Range(cfRange), range)
        XCTAssertEqual(Range(nsRange), range)
    }
    
    func testDuration() {
        let d1 = 60 * .seconds
        let d2 = 1 * .minutes
        let d3 = 60_000 * .milliseconds
        let d4 = 1/60 * .hours

        XCTAssertEqual(d1, d2)
        XCTAssertEqual(d2, d3)
        XCTAssertEqual(d3, d4)
        
        XCTAssertEqual(d1, 60)
        XCTAssertEqual(d2, 60)
        XCTAssertEqual(d3, 60)
        XCTAssertEqual(d4, 60)
        
        XCTAssertEqual(d1 / .minutes, 1)
        XCTAssertEqual(d2 / .minutes, 1)
        XCTAssertEqual(d3 / .minutes, 1)
        XCTAssertEqual(d4 / .minutes, 1)

        XCTAssertEqual(d1 / .milliseconds, 60_000)
        XCTAssertEqual(d2 / .milliseconds, 60_000)
        XCTAssertEqual(d3 / .milliseconds, 60_000)
        XCTAssertEqual(d4 / .milliseconds, 60_000)

        XCTAssertEqual(d1 / .hours, 1/60)
        XCTAssertEqual(d2 / .hours, 1/60)
        XCTAssertEqual(d3 / .hours, 1/60)
        XCTAssertEqual(d4 / .hours, 1/60)
        
        XCTAssertEqual(scale(domain: .minutes, range: .seconds)(1), 60)
        XCTAssertEqual(scale(domain: .seconds, range: .minutes)(60), 1)
        XCTAssertEqual(scale(domain: .milliseconds, range: .seconds)(60_000), 60)
        XCTAssertEqual(scale(domain: .minutes, range: .hours)(1), 1 / 60)
    }
}
