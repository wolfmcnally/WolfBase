import Testing
import WolfBase

struct Dog {
    var name: String
}

class Cat {
    var name: String
    init(name: String) { self.name = name }
    deinit { print("deinit \(name)") }
}

struct WithTests {
    @Test func testWith1() {
        var dog1 = Dog(name: "Puppy")
        
        // Version 1: Perform a mutating action on a `Dog`.
        with(&dog1) { d in
            d.name = "Magic"
        }
        #expect(dog1.name == "Magic")
        
        // Version 2: Perform a mutating action on a copy of a `Dog`.
        let dog2 = dog1
        let dog3 = with(dog2) { d in
            d.name = "Neko"
        }
        #expect(dog3.name == "Neko")
        
        let cat = Cat(name: "Kitten")
        
        // Version 2: Replace a `Cat` with a new `Cat`.
        var cat2 = cat
        with(&cat2) { c in
            c = Cat(name: "Jellicle")
        }
        #expect(cat.name == "Kitten")
        #expect(cat2.name == "Jellicle")
    }
}
