import XCTest
import WolfBase

final class StringTests: XCTestCase {
    func testStringExtensions1() {
        let string = "Hello, world!"
        let bytes: [UInt8] = [0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x21]
        let data = bytes.data
        XCTAssertEqual(string.utf8Data, data)
        XCTAssertEqual(string.utf8Data.hex.hexData, data)
    }
    
    func testStringExtensions2() {
        let s = "  Hello, world!  "
        XCTAssertEqual(s.trim(), "Hello, world!")
        XCTAssertEqual(s.removeWhitespaceRuns(), " Hello, world! ")
    }

    func testStringExtensions3() {
        let s = "Hello, world!"
        XCTAssertEqual(s.prefix(count: 5), "Hello")
        XCTAssertEqual(s.suffix(count: 5), "orld!")
        XCTAssertEqual(s.prefix(count: 100), s)
        XCTAssertEqual(s.suffix(count: 100), s)
    }
    
    func testStringExtensions4() {
        let s = "abcdefghijklmnopqrstuvwxyz"
        XCTAssertEqual(s.chunked(into: 3), ["abc", "def", "ghi", "jkl", "mno", "pqr", "stu", "vwx", "yz"])
    }
    
    func testStringExtensions5() {
        let s = "123456789"
        XCTAssertEqual(s.truncated(count: 5, terminator: "."), "12345.")
        XCTAssertEqual(s.truncated(count: 100), s)
        XCTAssertEqual(s.truncated(count: 3), "123…")
    }
    
    func testStringFloatPrecision() {
        let f = 1234.5678
        let us = Locale(identifier: "en_US")
        let uk = Locale(identifier: "UK")
        
        XCTAssertEqual(String(f, precision: 2, locale: us), "1,234.57")
        XCTAssertEqual(String(f, precision: 2, locale: us, usesGroupingSeparator: false), "1234.57")
        XCTAssertEqual(String(f, precision: 2, locale: uk), "1 234,57")
        XCTAssertEqual(String(f, precision: 2), "1234.57")
        XCTAssertEqual(String(f, precision: 0), "1235")
        XCTAssertEqual(String(f, minPrecision: 5), "1234.56780")
        
        XCTAssertEqual(f %% (2, us), "1,234.57")
        XCTAssertEqual(f %% (2, uk), "1 234,57")
        XCTAssertEqual(f %% 2, "1234.57")
        XCTAssertEqual(f %% 0, "1235")
        
        XCTAssertEqual("\(f, precision: 2, locale: us)", "1,234.57")
        XCTAssertEqual("\(f, minPrecision: 5, locale: uk)", "1 234,56780")
    }
    
    func testUTF8Utils() {
        let string = "Hello, world!"
        let bytes: [UInt8] = [0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x21]
        let data = bytes.data
        XCTAssertEqual(toUTF8(data: data), string)
        XCTAssertEqual(toData(utf8: string), data)
    }
    
    func testStringRanges() {
        let dog = "Dog"
        let wolf = "🐺-Wolf" // The wolf emoji takes 2 bytes
        
        XCTAssertEqual(dog.rangeDescription(dog.stringRange), "0..<3")
        XCTAssertEqual(wolf.rangeDescription(wolf.stringRange), "0..<6")
        XCTAssertEqual(dog.nsRange†, "{0, 3}")
        XCTAssertEqual(wolf.nsRange†, "{0, 7}")
        
        XCTAssertEqual(dog.rangeDescription(dog.stringRange(0..<1)), "0..<1")
        XCTAssertEqual(wolf.rangeDescription(wolf.stringRange(0..<1)), "0..<1")
        
        // Not allowed
        // print(dog[0..<2])
        // print(wolf[0])
        XCTAssertEqual(dog[dog.stringRange(0..<2)], "Do")
        XCTAssertEqual(wolf[wolf.stringRange(0..<1)], "🐺")
        
        let dogRange = dog.stringRange(0..<2)
        let wolfRange = dog.convert(range: dogRange, to: wolf)
        XCTAssertEqual(wolf[wolfRange], "🐺-")
    }
}
