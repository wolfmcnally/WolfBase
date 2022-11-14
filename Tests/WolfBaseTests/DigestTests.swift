import XCTest
import WolfBase

final class DigestTests: XCTestCase {
    func testCRC32() {
        let string = "Hello, world!"
        XCTAssertEqual(CRC32.checksum(string: string), 3957769958)
    }
    
    func testSHA256() {
        let string = "Hello, world!"
        let digest = "315f5bdb76d078c43b8ac0064e4a0164612b1fce77c869345bfc94c75894edd3"
        XCTAssertEqual(string.utf8Data.sha256Digest.hex, digest)
    }
}
