import WolfBase
import Testing

struct DigestTests {
    @Test func testCRC32() {
        let string = "Hello, world!"
        #expect(CRC32.checksum(string: string) == 3957769958)
    }
    
    @available(tvOS 13.0, *)
    @available(iOS 13.0, *)
    @Test func testSHA256() {
        let string = "Hello, world!"
        let digest = "315f5bdb76d078c43b8ac0064e4a0164612b1fce77c869345bfc94c75894edd3"
        #expect(string.utf8Data.sha256Digest.hex == digest)
    }
}
