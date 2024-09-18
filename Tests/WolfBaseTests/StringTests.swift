import Testing
import WolfBase
import Foundation

struct StringTests {
    @Test func testStringExtensions1() {
        let string = "Hello, world!"
        let bytes: [UInt8] = [0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x21]
        let data = bytes.data
        #expect(string.utf8Data == data)
        #expect(string.utf8Data.hex.hexData == data)
    }
    
    @Test func testStringExtensions2() {
        let s = "  Hello, world!  "
        #expect(s.trim() == "Hello, world!")
        #expect(s.removeWhitespaceRuns() == " Hello, world! ")
    }

    @Test func testStringExtensions3() {
        let s = "Hello, world!"
        #expect(s.prefix(count: 5) == "Hello")
        #expect(s.suffix(count: 5) == "orld!")
        #expect(s.prefix(count: 100) == s)
        #expect(s.suffix(count: 100) == s)
    }
    
    @Test func testStringExtensions4() {
        let s = "abcdefghijklmnopqrstuvwxyz"
        #expect(s.chunked(into: 3) == ["abc", "def", "ghi", "jkl", "mno", "pqr", "stu", "vwx", "yz"])
    }
    
    @Test func testStringExtensions5() {
        let s = "123456789"
        #expect(s.truncated(count: 5, terminator: ".") == "12345.")
        #expect(s.truncated(count: 100) == s)
        #expect(s.truncated(count: 3) == "123…")
    }
    
    @Test func testStringFloatPrecision() {
        let f = 1234.5678
        let us = Locale(identifier: "en_US")
        let uk = Locale(identifier: "UK")
        
        #expect(String(f, precision: 2, locale: us) == "1,234.57")
        #expect(String(f, precision: 2, locale: us, usesGroupingSeparator: false) == "1234.57")
        #expect(String(f, precision: 2, locale: uk) == "1 234,57")
        #expect(String(f, precision: 2) == "1234.57")
        #expect(String(f, precision: 0) == "1235")
        #expect(String(f, minPrecision: 5) == "1234.56780")
        
        #expect((f %% (2, us)) == "1,234.57")
        #expect((f %% (2, uk)) == "1 234,57")
        #expect((f %% 2) == "1234.57")
        #expect((f %% 0) == "1235")
        
        #expect("\(f, precision: 2, locale: us)" == "1,234.57")
        #expect("\(f, minPrecision: 5, locale: uk)" == "1 234,56780")
    }
    
    @Test func testUTF8Utils() {
        let string = "Hello, world!"
        let bytes: [UInt8] = [0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x21]
        let data = bytes.data
        #expect(toUTF8(data: data) == string)
        #expect(toData(utf8: string) == data)
    }
    
    @Test func testStringRanges() {
        let dog = "Dog"
        let wolf = "🐺-Wolf" // The wolf emoji takes 2 bytes
        
        #expect(dog.rangeDescription(dog.stringRange) == "0..<3")
        #expect(wolf.rangeDescription(wolf.stringRange) == "0..<6")
        #expect(dog.nsRange† == "{0, 3}")
        #expect(wolf.nsRange† == "{0, 7}")
        
        #expect(dog.rangeDescription(dog.stringRange(0..<1)) == "0..<1")
        #expect(wolf.rangeDescription(wolf.stringRange(0..<1)) == "0..<1")
        
        // Not allowed
        // print(dog[0..<2])
        // print(wolf[0])
        #expect(dog[dog.stringRange(0..<2)] == "Do")
        #expect(wolf[wolf.stringRange(0..<1)] == "🐺")
        
        let dogRange = dog.stringRange(0..<2)
        let wolfRange = dog.convert(range: dogRange, to: wolf)
        #expect(wolf[wolfRange] == "🐺-")
    }
}
