import XCTest
import WolfBase

final class HexTests: XCTestCase {
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
    
    func testHexUtils4() {
        XCTAssertEqual(HexData(hex: "0011223344")!.hex, "0011223344")
    }
}
