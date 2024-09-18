import WolfBase
import Testing
import Foundation

struct CollectionExtensionTests {
    @Test func testArrayExtensions() {
        let a = Array(0..<105)
        let b = a.chunked(into: 10)
        #expect(b[2] == [20, 21, 22, 23, 24, 25, 26, 27, 28, 29])
        #expect(b[10] == [100, 101, 102, 103, 104])
    }
    
    @Test func testDictionaryExtensions() {
        var a: [String : Set<String>] = [:]
        a.add(to: "foo", "bar")
        a.add(to: "baz", "quux")
        a.add(to: "foo", "blah")
        #expect(a.count == 2)
        #expect(a["foo"]!.count == 2)
        
        #expect(Array(a.get(at: "foo")).sorted() == ["bar", "blah"])
        
        #expect(a.remove(from: "baz", "quux") == "quux")
        #expect(a.count == 1)
        #expect(a["baz"] == nil)

        var b: [String : [String]] = [:]
        b.add(to: "foo", "bar")
        b.add(to: "baz", "quux")
        b.add(to: "foo", "blah")
        #expect(b.count == 2)
        #expect(b["foo"]!.count == 2)

        #expect(Array(b.get(at: "foo")).sorted() == ["bar", "blah"])

        #expect(b.remove(from: "baz", "quux") == "quux")
        #expect(b.count == 1)
        #expect(b["baz"] == nil)
    }

    @Test func testCollectionExtensions1() {
        var a = Array(repeating: 0, count: 100)
        #expect(a.isAllZero)
        a[12] = 10
        #expect(!a.isAllZero)
    }
    
    @Test func testCollectionExtensions2() {
        let a: [UInt8] = [5, 10, 15, 20, 25]
        #expect(a.hex == "050a0f1419")
    }
    
    @Test func testDataExtensions1() {
        let hex = "00112233abcdef"
        let bytes: [UInt8] = [0x00, 0x11, 0x22, 0x33, 0xab, 0xcd, 0xef]
        let data = Data(bytes)
        #expect(Data(hex: hex) == data)
        #expect(data.hex == hex)
        #expect(data.bytes == bytes)
        #expect(data.serialized == data)
    }
    
    @Test func testDataExtensions2() {
        let string = "Hello, world!"
        let bytes: [UInt8] = [0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x21]
        #expect(bytes.data.utf8 == string)
        #expect(string.utf8Data == bytes.data)
    }
    
    @Test func testDataExtensions3() {
        struct A: Equatable {
            let a: Int
            let b: Double
        }
        
        let a = A(a: 1, b: 2.3)
        var b = A(a: 4, b: 5.6)
        
        let aData = Data(of: a)
        aData.store(into: &b)
        #expect(a == b)
    }
    
    @Test func testDataExtensions4() {
        let bytes: [UInt8] = [0x01, 0x02, 0x03, 0x04]
        let data = Data(bytes)
        
        let a = data.withUnsafeByteBuffer { unsafeBufferPointer -> Bool in
            #expect(Array(unsafeBufferPointer) == bytes)
            return true
        }
        #expect(a)
    }
}
