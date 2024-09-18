import Testing
import WolfBase
import Foundation

struct IntervalTests {
    @Test func testFloatingPoint() {
        let i = 10.0..20.0
        
        #expect(i.description == "10.0..20.0")
        
        #expect(i == (10.0..20.0))
        #expect(i.swapped == (20.0..10.0))
        #expect(i.isAscending)
        #expect(!i.isDescending)
        #expect(!i.swapped.isAscending)
        #expect(i.swapped.isDescending)
        #expect(!i.isFlat)
        #expect((10.0..10.0).isFlat)
        #expect(i.swapped.normalized == i)
        #expect(i.min == 10.0)
        #expect(i.max == 20.0)
        
        #expect(i.contains(15))
        #expect(i.contains(10))
        #expect(i.contains(20))
        #expect(!i.contains(0))
        #expect(!i.contains(25))
        
        #expect(i.contains(i))
        #expect(i.contains(15.0..16.0))
        #expect(!i.contains(9.0..11.0))
        #expect(!i.contains(19.0..22.0))
        
        #expect(i.intersects(with: i))
        #expect(i.intersects(with: 15.0..16.0))
        #expect(i.intersects(with: 9.0..11.0))
        #expect(i.intersects(with: 19.0..22.0))
        #expect(!i.intersects(with: 7.0..9.0))
        #expect(!i.intersects(with: 22.0..28.0))

        #expect(i.intersection(with: i) == i)
        #expect(i.intersection(with: 15.0..16.0) == (15.0..16.0))
        #expect(i.intersection(with: 9.0..11.0) == (10.0..11.0))
        #expect(i.intersection(with: 19.0..22.0) == (19.0..20.0))
        #expect(i.intersection(with: 7.0..9.0) == nil)
        #expect(i.intersection(with: 22.0..28.0) == nil)
        
        #expect(i.extent == 10.0)
        #expect(i.extent(with: 1.0..5.0) == (1.0..20.0))
        
        #expect(i == Interval(10.0...20.0))
        #expect(i.closedRange == 10.0...20.0)
        
        let s = i.scale
        #expect(s(-0.5) == 5.0)
        #expect(s(0.0) == 10.0)
        #expect(s(0.5) == 15.0)
        #expect(s(1.0) == 20.0)
        #expect(s(1.5) == 25.0)

        let s2 = i.swapped.scale
        #expect(s2(-0.5) == 25.0)
        #expect(s2(0.0) == 20.0)
        #expect(s2(0.5) == 15.0)
        #expect(s2(1.0) == 10.0)
        #expect(s2(1.5) == 5.0)

        let s3 = i.descale
        #expect(s3(5.0) == -0.5)
        #expect(s3(10.0) == 0.0)
        #expect(s3(20.0) == 1.0)
        #expect(s3(25.0) == 1.5)

        #expect((0..100).inset(by: 5) == (5..95))
        #expect((0..100).inset(by: -5) == (-5..105))
        #expect((100..0).inset(by: 5) == (95..5))
        #expect((100..0).inset(by: -5) == (105..(-5)))
        #expect((50..50).inset(by: 5) == (55..45))
        #expect((50..50).inset(by: -5) == (45..55))
    }
    
    @Test func testSIMD() {
        let i: Interval<SIMD2<Double>> = [10.0, 20.0] .. [30.0, 40.0]
        
        #expect(i.extent == [20.0, 20.0])

        #expect(i.scale(-0.5) == [0.0, 10.0])
        #expect(i.scale(0.0) == [10.0, 20.0])
        #expect(i.scale(0.5) == [20.0, 30.0])
        #expect(i.scale(1.0) == [30.0, 40.0])
        #expect(i.scale(1.5) == [40.0, 50.0])
    }
    
    @Test func testColour() {
        let c = Colour.red..Colour.blue
        
        #expect(c.scale(0.0) == Colour.red)
        #expect(c.scale(0.5) == [0.5, 0.0, 0.5])
        #expect(c.scale(1.0) == Colour.blue)
    }
    
    @Test func testScaleFloatingPoint() {
        let s = scale(domain: 0.0..100.0, range: 500.0..0.0)
        
        #expect(s(0) == 500)
        #expect(s(50) == 250)
        #expect(s(100) == 0)
    }
    
    @Test func testScaleSIMD() {
        let p1: SIMD2 = [50.0, 60.0]
        let p2: SIMD2 = [70.0, 80.0]
        let s = scale(domain: 0.0 .. 1.0, range: p1..p2)
        #expect(s(0) == p1)
        #expect(s(0.5) == [60.0, 70.0])
        #expect(s(1) == p2)
    }
    
    @Test func testScaleColor() {
        let c1 = Colour.red
        let c2 = Colour.blue
        let s = scale(domain: 0.0 .. 100.0, range: c1..c2)

        #expect(s(0.0) == Colour.red)
        #expect(s(50.0) == [0.5, 0.0, 0.5])
        #expect(s(100.0) == Colour.blue)
    }
    
    @Test func testScaleDate() {
        let d1 = Date(year: 1965, month: 1, day: 1)
        let d2 = Date(year: 2022, month: 1, day: 1)

        let d3 = Date(year: 1970, month: 7, day: 31)
        let d4 = Date(year: 2004, month: 10, day: 30)

        let s1 = scale(domain: d1..d2, range: 100..200)
        #expect((s1(d1) %% 3) == "100")
        #expect((s1(d2) %% 3) == "200")
        #expect((s1(d3) %% 3) == "109.784")
        #expect((s1(d4) %% 3) == "169.874")

        let s2 = scale(domain: d1..d2, range: 1965..2022)
        #expect((s2(d1) %% 3) == "1965")
        #expect((s2(d2) %% 3) == "2022")
        #expect((s2(d3) %% 3) == "1970.577")
        #expect((s2(d4) %% 3) == "2004.828")
    }
    
    @Test func testDurationScale() {
        #expect(DurationUnit.seconds.descale(0) == 0)
        #expect(DurationUnit.seconds.descale(0.5) == 0.5)
        #expect(DurationUnit.seconds.descale(1) == 1)

        #expect(DurationUnit.seconds.scale(0) == 0)
        #expect(DurationUnit.seconds.scale(0.5) == 0.5)
        #expect(DurationUnit.seconds.scale(1) == 1)

        #expect(DurationUnit.minutes.descale(0) == 0)
        #expect(DurationUnit.minutes.descale(0.5) == 30)
        #expect(DurationUnit.minutes.descale(1) == 60)
        #expect(DurationUnit.minutes.descale(1/60) == 1)

        #expect(DurationUnit.minutes.scale(0) == 0)
        #expect(DurationUnit.minutes.scale(30) == 0.5)
        #expect(DurationUnit.minutes.scale(60) == 1)
        #expect(DurationUnit.minutes.scale(1) == 1.0/60)

        #expect(DurationUnit.milliseconds.descale(0) == 0)
        #expect(DurationUnit.milliseconds.descale(0.5) == 1.0/2000)
        #expect(DurationUnit.milliseconds.descale(1) == 1.0/1000)
        #expect(DurationUnit.milliseconds.descale(1000) == 1)

        #expect(DurationUnit.milliseconds.scale(0) == 0)
        #expect(DurationUnit.milliseconds.scale(1/2000) == 0.5)
        #expect(DurationUnit.milliseconds.scale(1/1000) == 1)
        #expect(DurationUnit.milliseconds.scale(1) == 1000)
    }
}
