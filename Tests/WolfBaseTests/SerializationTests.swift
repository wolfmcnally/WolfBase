import Testing
import WolfBase
import Foundation

struct SerializationTests {
    @Test func testIntUtils1() {
        let i: UInt64 = 0x123456789abcdef0
        let d = serialize(i)
        #expect(d.hex == "123456789abcdef0")
        #expect(deserialize(UInt64.self, d) == i)
        #expect(deserialize(UInt64.self, d, littleEndian: true) == 0xf0debc9a78563412)
    }

    @Test func testIntUtils2() {
        let i: UInt16 = 0x1234
        let d = i.serialized
        #expect(d.hex == "1234")
        #expect(deserialize(UInt16.self, d) == i)
        #expect(deserialize(UInt16.self, d, littleEndian: true) == 0x3412)
    }

    @Test func testIntUtils3() {
        let i: UInt32 = 0x12345678
        let d = i.serialized
        #expect(d.hex == "12345678")
        #expect(deserialize(UInt32.self, d) == i)
        #expect(deserialize(UInt32.self, d, littleEndian: true) == 0x78563412)
    }
        
    @Test func testFloatSerialization() {
        func test<F>(_ type: F.Type) where F : BinaryFloatingPoint & Serializable {
            let f: F = 12.345
            let t = deserialize(F.self, f.serialized)
            #expect(f == t)
        }
        
        test(Float.self)
        test(Double.self)
        test(CGFloat.self)
    }
    
    @Test func testFloatSerialization2() {
        func test<F>(_ type: F.Type) where F : BinaryFloatingPoint & Serializable, F.RawSignificand: FixedWidthInteger {
            let a = (0..<1000).map { _ in F.random(in: F.leastNormalMagnitude...F.greatestFiniteMagnitude) }
            let b = a.map { $0.serialized }
            let c = b.map { deserialize(F.self, $0) }
            let d = zip(a, c).first(where: {$0 != $1})
            #expect(d == nil)
        }

        test(Float.self)
        test(Double.self)
        test(CGFloat.self)
    }
    
    @Test func testFloatSerialization3() {
        func test<F>(_ type: F.Type) where F : BinaryFloatingPoint & Serializable, F.RawSignificand: FixedWidthInteger {
            let a: [F] = [.infinity, -.infinity, .leastNonzeroMagnitude, .pi, .zero]
            let b = a.map { $0.serialized }
            let c = b.map { deserialize(F.self, $0) }
            let d = zip(a, c).first(where: {$0 != $1})
            #expect(d == nil)
        }

        test(Float.self)
        test(Double.self)
        test(CGFloat.self)
    }
    
    @Test func testFloatSerialization4() {
        func test<F>(_ type: F.Type) where F : BinaryFloatingPoint & Serializable, F.RawSignificand: FixedWidthInteger {
            let a: F = .nan
            let c = deserialize(F.self, a.serialized)!
            #expect(c.isNaN)
        }

        test(Float.self)
        test(Double.self)
        test(CGFloat.self)
    }

    @Test func testDecimalSerialization() {
        let f: Decimal = 12.345
        let t = deserialize(Decimal.self, f.serialized)
        #expect(f == t)
    }
    
    @Test func testDateSerialization() {
        for _ in 0 ..< 1000 {
            let f = Date()
            let t = deserialize(Date.self, f.serialized)
            #expect(f == t)
        }
    }
    
    @Test func testStringSerialization() {
        let f = "Hello, world!"
        let t = deserialize(String.self, f.serialized)
        #expect(f == t)
    }
    
    @Test func testUUIDSerialization() {
        for _ in 0 ..< 1000 {
            let u = UUID()
            let v = deserialize(UUID.self, u.serialized)
            #expect(u == v)
        }
    }
}
