import XCTest
import WolfBase

struct Dog {
    var name: String
}

class Cat {
    var name: String
    init(name: String) { self.name = name }
    deinit { print("deinit \(name)") }
}

class WithTests: XCTestCase {
    func testWith1() {
        // Version 1: Transform `Void` into a `Dog`.
        var dog1 = with(()) {
            Dog(name: "Puppy")
        }
        
        // Version 2: Perform a mutating action on a `Dog`.
        with(&dog1) { d in
            d.name = "Magic"
        }
        XCTAssertEqual(dog1.name, "Magic")
        
        // Version 3: Perform a mutating action on a copy of a `Dog`.
        let dog2 = dog1
        let dog3 = with(dog2) { d in
            d.name = "Neko"
        }
        XCTAssertEqual(dog3.name, "Neko")
        
        // Version 1: Mutate a `Cat`.
        let cat = with(Cat(name: "Kitten")) { c in
            c.name = "Elliot"
            return c
        }
        XCTAssertEqual(cat.name, "Elliot")
        
        // Version 1, transform a `Cat` into a `Dog`.
        let dog4 = with(cat) { c in
            return Dog(name: c.name)
        }
        XCTAssertEqual(dog4.name, "Elliot")
        
        // Version 2: Replace a `Cat` with a new `Cat`.
        var cat2 = cat
        with(&cat2) { c in
            c = Cat(name: "Jellicle")
        }
        XCTAssertEqual(cat2.name, "Jellicle")
    }
}
