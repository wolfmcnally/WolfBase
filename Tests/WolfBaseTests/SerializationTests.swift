import XCTest
import WolfBase

final class SerializationTests: XCTestCase {
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
}
