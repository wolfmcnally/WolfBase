import XCTest
import WolfBase

final class EnumerationTests: XCTestCase {
    func testEnumeration() throws {
        let e = HTTPMethod.get
        let d = try JSONEncoder().encode(e)
        let e2 = try JSONDecoder().decode(HTTPMethod.self, from: d)
        XCTAssertEqual(e, e2)
        XCTAssertTrue(e2 == .get)
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
