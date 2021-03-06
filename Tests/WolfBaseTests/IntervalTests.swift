import XCTest
import WolfBase

final class IntervalTests: XCTestCase {
    func testFloatingPoint() {
        let i = 10.0..20.0
        
        XCTAssertEqual(i.description, "10.0..20.0")
        
        XCTAssertEqual(i, 10.0..20.0)
        XCTAssertEqual(i.swapped, 20.0..10.0)
        XCTAssertTrue(i.isAscending)
        XCTAssertFalse(i.isDescending)
        XCTAssertFalse(i.swapped.isAscending)
        XCTAssertTrue(i.swapped.isDescending)
        XCTAssertFalse(i.isFlat)
        XCTAssertTrue((10.0..10.0).isFlat)
        XCTAssertEqual(i.swapped.normalized, i)
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
        
        let s = i.scale
        XCTAssertEqual(s(-0.5), 5.0)
        XCTAssertEqual(s(0.0), 10.0)
        XCTAssertEqual(s(0.5), 15.0)
        XCTAssertEqual(s(1.0), 20.0)
        XCTAssertEqual(s(1.5), 25.0)

        let s2 = i.swapped.scale
        XCTAssertEqual(s2(-0.5), 25.0)
        XCTAssertEqual(s2(0.0), 20.0)
        XCTAssertEqual(s2(0.5), 15.0)
        XCTAssertEqual(s2(1.0), 10.0)
        XCTAssertEqual(s2(1.5), 5.0)

        let s3 = i.descale
        XCTAssertEqual(s3(5.0), -0.5)
        XCTAssertEqual(s3(10.0), 0.0)
        XCTAssertEqual(s3(20.0), 1.0)
        XCTAssertEqual(s3(25.0), 1.5)

        XCTAssertEqual((0..100).inset(by: 5), 5..95)
        XCTAssertEqual((0..100).inset(by: -5), -5..105)
        XCTAssertEqual((100..0).inset(by: 5), 95..5)
        XCTAssertEqual((100..0).inset(by: -5), 105..(-5))
        XCTAssertEqual((50..50).inset(by: 5), 55..45)
        XCTAssertEqual((50..50).inset(by: -5), 45..55)
    }
    
    func testSIMD() {
        let i: Interval<SIMD2<Double>> = [10.0, 20.0] .. [30.0, 40.0]
        
        XCTAssertEqual(i.extent, [20.0, 20.0])

        XCTAssertEqual(i.scale(-0.5), [0.0, 10.0])
        XCTAssertEqual(i.scale(0.0), [10.0, 20.0])
        XCTAssertEqual(i.scale(0.5), [20.0, 30.0])
        XCTAssertEqual(i.scale(1.0), [30.0, 40.0])
        XCTAssertEqual(i.scale(1.5), [40.0, 50.0])
    }
    
    func testColour() {
        let c = Colour.red..Colour.blue
        
        XCTAssertEqual(c.scale(0.0), Colour.red)
        XCTAssertEqual(c.scale(0.5), [0.5, 0.0, 0.5])
        XCTAssertEqual(c.scale(1.0), Colour.blue)
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
    
    func testScaleDate() {
        let d1 = Date(year: 1965, month: 1, day: 1)
        let d2 = Date(year: 2022, month: 1, day: 1)

        let d3 = Date(year: 1970, month: 7, day: 31)
        let d4 = Date(year: 2004, month: 10, day: 30)

        let s1 = scale(domain: d1..d2, range: 100..200)
        XCTAssertEqual(s1(d1) %% 3, "100")
        XCTAssertEqual(s1(d2) %% 3, "200")
        XCTAssertEqual(s1(d3) %% 3, "109.784")
        XCTAssertEqual(s1(d4) %% 3, "169.874")

        let s2 = scale(domain: d1..d2, range: 1965..2022)
        XCTAssertEqual(s2(d1) %% 3, "1965")
        XCTAssertEqual(s2(d2) %% 3, "2022")
        XCTAssertEqual(s2(d3) %% 3, "1970.577")
        XCTAssertEqual(s2(d4) %% 3, "2004.828")
    }
    
    func testDurationScale() {
        XCTAssertEqual(DurationUnit.seconds.descale(0), 0)
        XCTAssertEqual(DurationUnit.seconds.descale(0.5), 0.5)
        XCTAssertEqual(DurationUnit.seconds.descale(1), 1)

        XCTAssertEqual(DurationUnit.seconds.scale(0), 0)
        XCTAssertEqual(DurationUnit.seconds.scale(0.5), 0.5)
        XCTAssertEqual(DurationUnit.seconds.scale(1), 1)

        XCTAssertEqual(DurationUnit.minutes.descale(0), 0)
        XCTAssertEqual(DurationUnit.minutes.descale(0.5), 30)
        XCTAssertEqual(DurationUnit.minutes.descale(1), 60)
        XCTAssertEqual(DurationUnit.minutes.descale(1/60), 1)

        XCTAssertEqual(DurationUnit.minutes.scale(0), 0)
        XCTAssertEqual(DurationUnit.minutes.scale(30), 0.5)
        XCTAssertEqual(DurationUnit.minutes.scale(60), 1)
        XCTAssertEqual(DurationUnit.minutes.scale(1), 1/60)

        XCTAssertEqual(DurationUnit.milliseconds.descale(0), 0)
        XCTAssertEqual(DurationUnit.milliseconds.descale(0.5), 1/2000)
        XCTAssertEqual(DurationUnit.milliseconds.descale(1), 1/1000)
        XCTAssertEqual(DurationUnit.milliseconds.descale(1000), 1)

        XCTAssertEqual(DurationUnit.milliseconds.scale(0), 0)
        XCTAssertEqual(DurationUnit.milliseconds.scale(1/2000), 0.5)
        XCTAssertEqual(DurationUnit.milliseconds.scale(1/1000), 1)
        XCTAssertEqual(DurationUnit.milliseconds.scale(1), 1000)
    }
}
