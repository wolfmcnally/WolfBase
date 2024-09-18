import Testing
import WolfBase

struct NumericTests {
    @Test func testFloatingPointExtensions() {
        #expect((1.1).clamped() == 1.0)
        #expect((-0.1).clamped() == 0.0)
    }
    
    @Test func testComparableExtensions() {
        #expect(10.clamped(to: 0...5) == 5)
        #expect((10.5).clamped(to: (0.0)...(5.5)) == 5.5)
        #expect(Character("Z").clamped(to: Character("A")...Character("F")) == "F")
    }
}
