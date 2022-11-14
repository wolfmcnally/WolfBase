import XCTest
import WolfBase

final class CollectionExtensionTests: XCTestCase {
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
}
