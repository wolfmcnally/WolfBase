import Testing
import WolfBase
import Foundation

struct HexTests {
    @Test func testHexUtils1() {
        let byte: UInt8 = 0xab
        let hex = "ab"
        #expect(hex == toHex(byte: byte))
        #expect(byte == toByte(hex: hex))
    }
    
    @Test func testHexUtils2() {
        let hex = "00112233abcdef"
        let bytes: [UInt8] = [0x00, 0x11, 0x22, 0x33, 0xab, 0xcd, 0xef]
        let data = Data(bytes)
        #expect(toData(hex: hex) == data)
        #expect(toBytes(hex: hex) == bytes)
        #expect(toHex(data: data) == hex)
        #expect(toHex(bytes: bytes) == hex)
    }
    
    @Test func testHexUtils3() {
        #expect(UInt8(10).hex == "0a")
        #expect(UInt16(10).hex == "000a")
        #expect(UInt32(10).hex == "0000000a")
        #expect(UInt64(10).hex == "000000000000000a")
        #expect(Int64(-1).hex == "ffffffffffffffff")
    }
    
    @Test func testHexUtils4() {
        #expect(HexData(hex: "0011223344")!.hex == "0011223344")
    }
}
