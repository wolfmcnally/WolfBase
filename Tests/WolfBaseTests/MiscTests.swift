import Testing
import WolfBase
import Foundation

struct MiscTests {
    @Test func testByteBufferUtils() {
        struct A: Equatable {
            let a: UInt8
            let b: UInt8
            let c: UInt8
            let d: UInt8
        }
        
        let a = A(a: 10, b: 20, c: 30, d: 40)
        
        let x = withUnsafeByteBuffer(of: a) { unsafeBufferPointer -> Bool in
            #expect(Array(unsafeBufferPointer) == [10, 20, 30, 40])
            return true
        }
        #expect(x)
        
        var b = A(a: 50, b: 60, c: 70, d: 80)
        
        let y = withUnsafeMutableByteBuffer(of: &b) { unsafeMutableBufferPointer -> Bool in
            unsafeMutableBufferPointer[0] = 10
            unsafeMutableBufferPointer[1] = 20
            unsafeMutableBufferPointer[2] = 30
            unsafeMutableBufferPointer[3] = 40
            return true
        }
        #expect(y)
        #expect(a == b)
    }
    
    @Test func testCodableExtensions() throws {
        struct A: Codable, Equatable {
            let a: String
            let b: Int
        }
        
        let a = A(a: "Hello", b: 10)
        let s = #"{"a":"Hello","b":10}"#
        let d = a.json
        
        #expect(a.jsonString == s)
        #expect(s.utf8Data == a.json)
        try #expect(fromJSON(A.self, a.json) == a)
        try #expect(fromJSON(A.self, a.jsonString) == a)
        try #expect(A.fromJSON(d) == a)
        try #expect(A.fromJSON(s) == a)
        try #expect(d.fromJSON(to: A.self) == a)
        try #expect(s.fromJSON(to: A.self) == a)
    }

    @Test func testOptionalExtensions() {
        let a: String? = "Hello"
        let b: String? = nil
        #expect(a.isSome)
        #expect(!a.isNone)
        #expect(!b.isSome)
        #expect(b.isNone)
        #expect(a.unwrap() as! String == "Hello")
        #expect(a.unwrap(String.self) == "Hello")
        #expect(unwrap(a) as! String == "Hello")
        #expect(unwrap(String.self, a) == "Hello")
        #expect(a† == "Hello")
        #expect(b† == "nil")
    }
    
    @Test func testRangeExtensions() {
        let cfRange = CFRange(location: 10, length: 20)
        let nsRange = NSRange(location: 10, length: 20)
        let range = 10 ..< 30
        
        #expect(NSRange(range) == nsRange)
        #expect(NSRange(cfRange) == nsRange)
        
        #expect(CFRange(range) == cfRange)
        #expect(CFRange(nsRange) == cfRange)
        
        #expect(Range(cfRange) == range)
        #expect(Range(nsRange) == range)
    }
    
    @Test func testDuration() {
        let d1 = 60 * .seconds
        let d2 = 1 * .minutes
        let d3 = 60_000 * .milliseconds
        let d4 = 1/60 * .hours

        #expect(d1 == d2)
        #expect(d2 == d3)
        #expect(d3 == d4)
        
        #expect(d1 == 60)
        #expect(d2 == 60)
        #expect(d3 == 60)
        #expect(d4 == 60)
        
        #expect(d1 / .minutes == 1)
        #expect(d2 / .minutes == 1)
        #expect(d3 / .minutes == 1)
        #expect(d4 / .minutes == 1)

        #expect(d1 / .milliseconds == 60_000)
        #expect(d2 / .milliseconds == 60_000)
        #expect(d3 / .milliseconds == 60_000)
        #expect(d4 / .milliseconds == 60_000)

        #expect(d1 / .hours == 1.0/60)
        #expect(d2 / .hours == 1.0/60)
        #expect(d3 / .hours == 1.0/60)
        #expect(d4 / .hours == 1.0/60)
        
        #expect(scale(domain: .minutes, range: .seconds)(1) == 60)
        #expect(scale(domain: .seconds, range: .minutes)(60) == 1)
        #expect(scale(domain: .milliseconds, range: .seconds)(60_000) == 60)
        #expect(scale(domain: .minutes, range: .hours)(1) == 1.0 / 60)
    }
}
