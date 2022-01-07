import XCTest
import WolfBase

final class WolfBaseTests: XCTestCase {
    func testArrayExtensions() {
        let a = Array(0..<105)
        let b = a.chunked(into: 10)
        XCTAssertEqual(b[2], [20, 21, 22, 23, 24, 25, 26, 27, 28, 29])
        XCTAssertEqual(b[10], [100, 101, 102, 103, 104])
    }
    
    func testDictionaryExtensions() {
        var a: [String : Set<String>] = [:]
        a.add(to: "foo", "bar")
        a.add(to: "baz", "quux")
        a.add(to: "foo", "blah")
        XCTAssertEqual(a.count, 2)
        XCTAssertEqual(a["foo"]!.count, 2)
        
        XCTAssertEqual(Array(a.get(at: "foo")).sorted(), ["bar", "blah"])
        
        XCTAssertEqual(a.remove(from: "baz", "quux"), "quux")
        XCTAssertEqual(a.count, 1)
        XCTAssertNil(a["baz"])

        var b: [String : [String]] = [:]
        b.add(to: "foo", "bar")
        b.add(to: "baz", "quux")
        b.add(to: "foo", "blah")
        XCTAssertEqual(b.count, 2)
        XCTAssertEqual(b["foo"]!.count, 2)

        XCTAssertEqual(Array(b.get(at: "foo")).sorted(), ["bar", "blah"])

        XCTAssertEqual(b.remove(from: "baz", "quux"), "quux")
        XCTAssertEqual(b.count, 1)
        XCTAssertNil(b["baz"])
    }
    
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

    func testCollectionExtensions1() {
        var a = Array(repeating: 0, count: 100)
        XCTAssertTrue(a.isAllZero)
        a[12] = 10
        XCTAssertFalse(a.isAllZero)
    }
    
    func testCollectionExtensions2() {
        let a: [UInt8] = [5, 10, 15, 20, 25]
        XCTAssertEqual(a.hex, "050a0f1419")
    }
    
    func testComparableExtensions() {
        XCTAssertEqual(10.clamped(to: 0...5), 5)
        XCTAssertEqual((10.5).clamped(to: (0.0)...(5.5)), 5.5)
        XCTAssertEqual(Character("Z").clamped(to: Character("A")...Character("F")), "F")
    }
    
    func testCRC32() {
        let string = "Hello, world!"
        XCTAssertEqual(CRC32.checksum(string: string), 3957769958)
    }
    
    func testCryptoKitExtensions() {
        let string = "Hello, world!"
        let digest = "315f5bdb76d078c43b8ac0064e4a0164612b1fce77c869345bfc94c75894edd3"
        XCTAssertEqual(string.utf8Data.sha256Digest.hex, digest)
    }
    
    func testDataExtensions1() {
        let hex = "00112233abcdef"
        let bytes: [UInt8] = [0x00, 0x11, 0x22, 0x33, 0xab, 0xcd, 0xef]
        let data = Data(bytes)
        XCTAssertEqual(Data(hex: hex), data)
        XCTAssertEqual(data.hex, hex)
        XCTAssertEqual(data.bytes, bytes)
        XCTAssertEqual(data.serialized, data)
    }
    
    func testDataExtensions2() {
        let string = "Hello, world!"
        let bytes: [UInt8] = [0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x21]
        XCTAssertEqual(bytes.data.utf8, string)
        XCTAssertEqual(string.utf8Data, bytes.data)
    }
    
    func testDataExtensions3() {
        struct A: Equatable {
            let a: Int
            let b: Double
        }
        
        let a = A(a: 1, b: 2.3)
        var b = A(a: 4, b: 5.6)
        
        let aData = Data(of: a)
        aData.store(into: &b)
        XCTAssertEqual(a, b)
    }
    
    func testDataExtensions4() {
        let bytes: [UInt8] = [0x01, 0x02, 0x03, 0x04]
        let data = Data(bytes)
        
        let a = data.withUnsafeByteBuffer { unsafeBufferPointer -> Bool in
            XCTAssertEqual(Array(unsafeBufferPointer), bytes)
            return true
        }
        XCTAssertTrue(a)
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
    
    func testFloatingPointExtensions() {
        XCTAssertEqual((1.1).clamped, 1.0)
        XCTAssertEqual((-0.1).clamped, 0.0)
    }
    
    func testHexUtils1() {
        let byte: UInt8 = 0xab
        let hex = "ab"
        XCTAssertEqual(hex, toHex(byte: byte))
        XCTAssertEqual(byte, toByte(hex: hex))
    }
    
    func testHexUtils2() {
        let hex = "00112233abcdef"
        let bytes: [UInt8] = [0x00, 0x11, 0x22, 0x33, 0xab, 0xcd, 0xef]
        let data = Data(bytes)
        XCTAssertEqual(toData(hex: hex), data)
        XCTAssertEqual(toBytes(hex: hex), bytes)
        XCTAssertEqual(toHex(data: data), hex)
        XCTAssertEqual(toHex(bytes: bytes), hex)
    }
    
    func testHexUtils3() {
        XCTAssertEqual(UInt8(10).hex, "0a")
        XCTAssertEqual(UInt16(10).hex, "000a")
        XCTAssertEqual(UInt32(10).hex, "0000000a")
        XCTAssertEqual(UInt64(10).hex, "000000000000000a")
        XCTAssertEqual(Int64(-1).hex, "ffffffffffffffff")
    }
    
    func testIntUtils1() {
        let i: UInt64 = 0x123456789abcdef0
        let d = serialize(i)
        XCTAssertEqual(d.hex, "123456789abcdef0")
        XCTAssertEqual(deserialize(UInt64.self, d), i)
        XCTAssertEqual(deserialize(UInt64.self, d, littleEndian: true), 0xf0debc9a78563412)
    }

    func testIntUtils2() {
        let i: UInt16 = 0x1234
        let d = i.serialized
        XCTAssertEqual(d.hex, "1234")
        XCTAssertEqual(deserialize(UInt16.self, d), i)
        XCTAssertEqual(deserialize(UInt16.self, d, littleEndian: true), 0x3412)
    }

    func testIntUtils3() {
        let i: UInt32 = 0x12345678
        let d = i.serialized
        XCTAssertEqual(d.hex, "12345678")
        XCTAssertEqual(deserialize(UInt32.self, d), i)
        XCTAssertEqual(deserialize(UInt32.self, d, littleEndian: true), 0x78563412)
    }
        
    func testFloatSerialization() {
        func test<F>(_ type: F.Type) where F : BinaryFloatingPoint & Serializable {
            let f: F = 12.345
            let t = deserialize(F.self, f.serialized)
            XCTAssertEqual(f, t)
        }
        
        test(Float.self)
        test(Double.self)
        test(CGFloat.self)
    }
    
    func testFloatSerialization2() {
        func test<F>(_ type: F.Type) where F : BinaryFloatingPoint & Serializable, F.RawSignificand: FixedWidthInteger {
            let a = (0..<1000).map { _ in F.random(in: F.leastNormalMagnitude...F.greatestFiniteMagnitude) }
            let b = a.map { $0.serialized }
            let c = b.map { deserialize(F.self, $0) }
            let d = zip(a, c).first(where: {$0 != $1})
            XCTAssertNil(d)
        }

        test(Float.self)
        test(Double.self)
        test(CGFloat.self)
    }
    
    func testFloatSerialization3() {
        func test<F>(_ type: F.Type) where F : BinaryFloatingPoint & Serializable, F.RawSignificand: FixedWidthInteger {
            let a: [F] = [.infinity, -.infinity, .leastNonzeroMagnitude, .pi, .zero]
            let b = a.map { $0.serialized }
            let c = b.map { deserialize(F.self, $0) }
            let d = zip(a, c).first(where: {$0 != $1})
            XCTAssertNil(d)
        }

        test(Float.self)
        test(Double.self)
        test(CGFloat.self)
    }
    
    func testFloatSerialization4() {
        func test<F>(_ type: F.Type) where F : BinaryFloatingPoint & Serializable, F.RawSignificand: FixedWidthInteger {
            let a: F = .nan
            let c = deserialize(F.self, a.serialized)!
            XCTAssert(c.isNaN)
        }

        test(Float.self)
        test(Double.self)
        test(CGFloat.self)
    }

    func testDecimalSerialization() {
        let f: Decimal = 12.345
        let t = deserialize(Decimal.self, f.serialized)
        XCTAssertEqual(f, t)
    }
    
    func testDateSerialization() {
        for _ in 0 ..< 1000 {
            let f = Date()
            let t = deserialize(Date.self, f.serialized)
            XCTAssertEqual(f, t)
        }
    }
    
    func testStringSerialization() {
        let f = "Hello, world!"
        let t = deserialize(String.self, f.serialized)
        XCTAssertEqual(f, t)
    }
    
    func testUUIDSerialization() {
        for _ in 0 ..< 1000 {
            let u = UUID()
            let v = deserialize(UUID.self, u.serialized)
            XCTAssertEqual(u, v)
        }
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
        let us = Locale(identifier: "us")
        let uk = Locale(identifier: "uk")
        
        XCTAssertEqual(String(f, precision: 2, locale: us), "1234.57")
        XCTAssertEqual(String(f, precision: 2, locale: uk), "1234,57")
        XCTAssertEqual(String(f, precision: 0), "1235")
        
        XCTAssertEqual(f %% (2, us), "1234.57")
        XCTAssertEqual(f %% (2, uk), "1234,57")
        XCTAssertEqual(f %% 0, "1235")
    }
    
    func testUTF8Utils() {
        let string = "Hello, world!"
        let bytes: [UInt8] = [0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x21]
        let data = bytes.data
        XCTAssertEqual(toUTF8(data: data), string)
        XCTAssertEqual(toData(utf8: string), data)
    }

    func testEnumeration() throws {
        let e = HTTPMethod.get
        let d = try JSONEncoder().encode(e)
        let e2 = try JSONDecoder().decode(HTTPMethod.self, from: d)
        XCTAssertEqual(e, e2)
        XCTAssertTrue(e2 == .get)
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

struct HTTPMethod: Enumeration, Codable {
    let rawValue: String

    init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    init?(rawValue: String) { self.init(rawValue) }
}

extension HTTPMethod {
    static let get = HTTPMethod("GET")
    static let post = HTTPMethod("POST")
}
