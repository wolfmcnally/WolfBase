import XCTest
import WolfBase

final class IntervalTests: XCTestCase {
    func testFloatingPoint() {
        let i = 10.0..20.0
        
        XCTAssertEqual(i.description, "10.0..20.0")
        
        XCTAssertEqual(i, 10.0..20.0)
        XCTAssertEqual(i.swapped(), 20.0..10.0)
        XCTAssertTrue(i.isAscending)
        XCTAssertFalse(i.isDescending)
        XCTAssertFalse(i.swapped().isAscending)
        XCTAssertTrue(i.swapped().isDescending)
        XCTAssertFalse(i.isFlat)
        XCTAssertTrue((10.0..10.0).isFlat)
        XCTAssertEqual(i.swapped().normalized(), i)
        XCTAssertEqual(i.min, 10.0)
        XCTAssertEqual(i.max, 20.0)
        
        XCTAssertTrue(i.contains(15))
        XCTAssertTrue(i.contains(10))
        XCTAssertTrue(i.contains(20))
        XCTAssertFalse(i.contains(0))
        XCTAssertFalse(i.contains(25))
        
        XCTAssertTrue(i.contains(i))
        XCTAssertTrue(i.contains(15.0..16.0))
        XCTAssertFalse(i.contains(9.0..11.0))
        XCTAssertFalse(i.contains(19.0..22.0))
        
        XCTAssertTrue(i.intersects(with: i))
        XCTAssertTrue(i.intersects(with: 15.0..16.0))
        XCTAssertTrue(i.intersects(with: 9.0..11.0))
        XCTAssertTrue(i.intersects(with: 19.0..22.0))
        XCTAssertFalse(i.intersects(with: 7.0..9.0))
        XCTAssertFalse(i.intersects(with: 22.0..28.0))

        XCTAssertEqual(i.intersection(with: i), i)
        XCTAssertEqual(i.intersection(with: 15.0..16.0), 15.0..16.0)
        XCTAssertEqual(i.intersection(with: 9.0..11.0), 10.0..11.0)
        XCTAssertEqual(i.intersection(with: 19.0..22.0), 19.0..20.0)
        XCTAssertEqual(i.intersection(with: 7.0..9.0), nil)
        XCTAssertEqual(i.intersection(with: 22.0..28.0), nil)
        
        XCTAssertEqual(i.extent, 10.0)
        XCTAssertEqual(i.extent(with: 1.0..5.0), 1.0..20.0)
        
        XCTAssertEqual(i, Interval(10.0...20.0))
        XCTAssertEqual(i.closedRange, 10.0...20.0)
        
        XCTAssertEqual(i.at(-0.5), 5.0)
        XCTAssertEqual(i.at(0.0), 10.0)
        XCTAssertEqual(i.at(0.5), 15.0)
        XCTAssertEqual(i.at(1.0), 20.0)
        XCTAssertEqual(i.at(1.5), 25.0)

        XCTAssertEqual(i.swapped().at(-0.5), 25.0)
        XCTAssertEqual(i.swapped().at(0.0), 20.0)
        XCTAssertEqual(i.swapped().at(0.5), 15.0)
        XCTAssertEqual(i.swapped().at(1.0), 10.0)
        XCTAssertEqual(i.swapped().at(1.5), 5.0)

        XCTAssertEqual(i.scalar(at: 5.0), -0.5)
        XCTAssertEqual(i.scalar(at: 10.0), 0.0)
        XCTAssertEqual(i.scalar(at: 20.0), 1.0)
        XCTAssertEqual(i.scalar(at: 25.0), 1.5)
    }
    
    func testSIMD() {
        let i: Interval<SIMD2<Double>> = [10.0, 20.0] .. [30.0, 40.0]
        
        XCTAssertEqual(i.extent, [20.0, 20.0])

        XCTAssertEqual(i.at(-0.5), [0.0, 10.0])
        XCTAssertEqual(i.at(0.0), [10.0, 20.0])
        XCTAssertEqual(i.at(0.5), [20.0, 30.0])
        XCTAssertEqual(i.at(1.0), [30.0, 40.0])
        XCTAssertEqual(i.at(1.5), [40.0, 50.0])
    }
    
    func testColour() {
        let c = Colour.red..Colour.blue
        
        XCTAssertEqual(c.at(0.0), Colour.red)
        XCTAssertEqual(c.at(0.5), [0.5, 0.0, 0.5])
        XCTAssertEqual(c.at(1.0), Colour.blue)
    }
    
    func testScaleFloatingPoint() {
        let s = scale(domain: 0.0..100.0, range: 500.0..0.0)
        
        XCTAssertEqual(s(0), 500)
        XCTAssertEqual(s(50), 250)
        XCTAssertEqual(s(100), 0)
    }
    
    func testScaleSIMD() {
        let p1: SIMD2 = [50.0, 60.0]
        let p2: SIMD2 = [70.0, 80.0]
        let s = scale(domain: 0.0 .. 1.0, range: p1..p2)
        XCTAssertEqual(s(0), p1)
        XCTAssertEqual(s(0.5), [60.0, 70.0])
        XCTAssertEqual(s(1), p2)
    }
    
    func testScaleColor() {
        let c1 = Colour.red
        let c2 = Colour.blue
        let s = scale(domain: 0.0 .. 100.0, range: c1..c2)

        XCTAssertEqual(s(0.0), Colour.red)
        XCTAssertEqual(s(50.0), [0.5, 0.0, 0.5])
        XCTAssertEqual(s(100.0), Colour.blue)
    }
}
