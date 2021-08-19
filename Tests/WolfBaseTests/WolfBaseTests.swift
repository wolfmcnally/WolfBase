import XCTest
import WolfBase

final class WolfBaseTests: XCTestCase {
    func testArrayExtensions() {
        let a = Array(0..<105)
        let b = a.chunked(into: 10)
        XCTAssertEqual(b[2], [20, 21, 22, 23, 24, 25, 26, 27, 28, 29])
        XCTAssertEqual(b[10], [100, 101, 102, 103, 104])
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
    
    func testEncodableExtensions() {
        struct A: Encodable {
            let a: String
            let b: Int
        }
        
        let a = A(a: "Hello", b: 10)
        let s = #"{"a":"Hello","b":10}"#
        
        XCTAssertEqual(a.jsonString, s)
        XCTAssertEqual(s.utf8Data, a.json)
    }
    
    func testHexUtils() {
        let hex = "00112233abcdef"
        let bytes: [UInt8] = [0x00, 0x11, 0x22, 0x33, 0xab, 0xcd, 0xef]
        let data = Data(bytes)
        XCTAssertEqual(toData(hex: hex), data)
        XCTAssertEqual(toBytes(hex: hex), bytes)
        XCTAssertEqual(toHex(data: data), hex)
        XCTAssertEqual(toHex(bytes: bytes), hex)
    }
    
    func testIntUtils1() {
        let i: UInt64 = 0x123456789abcdef0
        let d = toData(i)
        XCTAssertEqual(d.hex, "123456789abcdef0")
        XCTAssertEqual(toInt(UInt64.self, d), i)
    }

    func testIntUtils2() {
        let i: UInt16 = 0x1234
        let d = i.data
        XCTAssertEqual(d.hex, "1234")
        XCTAssertEqual(d.uint16, i)
    }

    func testIntUtils3() {
        let i: UInt32 = 0x12345678
        let d = i.data
        XCTAssertEqual(d.hex, "12345678")
        XCTAssertEqual(d.uint32, i)
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
    
    func testUTF8Utils() {
        let string = "Hello, world!"
        let bytes: [UInt8] = [0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x21]
        let data = bytes.data
        XCTAssertEqual(toUTF8(data: data), string)
        XCTAssertEqual(toData(utf8: string), data)
    }
}