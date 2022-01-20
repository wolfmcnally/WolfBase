//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

public struct Interval<Bound> {
    public var a: Bound
    public var b: Bound
    
    @inlinable public init(_ a: Bound, _ b: Bound) {
        self.a = a
        self.b = b
    }
}

extension Interval: Equatable where Bound: Equatable { }

extension Interval: CustomStringConvertible {
    public var description: String {
        "\(a)..\(b)"
    }
}

extension Interval {
    /// Returns an interval with the same bounds as this interval, but swapped
    @inlinable public func swapped() -> Interval {
        Interval(b, a)
    }
}

extension Interval where Bound: AdditiveArithmetic {
    @inlinable public var extent: Bound {
        b - a
    }
}

extension Interval where Bound: SIMD, Bound.Scalar: FloatingPoint {
    @inlinable public var extent: Bound {
        b - a
    }
}

extension Interval where Bound: Comparable {
    /// Returns `true` if `a` is less than `b`, and `false` otherwise.
    @inlinable public var isAscending: Bool {
        a < b
    }

    /// Returns `true` if `a` is greater than `b`, and `false` otherwise.
    @inlinable public var isDescending: Bool {
        a > b
    }

    /// Returns `true` if `a` is equal to `b`, and `false` otherwise.
    @inlinable public var isFlat: Bool {
        a == b
    }

    /// Returns an interval with the same bounds as this interval, but where `a` is the minimum bound and `b` is the maximum bound.
    @inlinable public func normalized() -> Interval {
        isAscending ? self : swapped()
    }
    
    /// Returns the lesser of the two bounds
    @inlinable public var min: Bound {
        Swift.min(a, b)
    }

    /// Returns the greater of the two bounds
    @inlinable public var max: Bound {
        Swift.max(a, b)
    }

    /// Returns `true` if the interval contains the value `n`, otherwise returns `false`.
    @inlinable public func contains(_ n: Bound) -> Bool {
        min <= n && n <= max
    }

    /// Returns `true` if the interval fully contains the `other` interval.
    @inlinable public func contains(_ other: Interval) -> Bool {
        min <= other.min && other.max <= max
    }

    /// Returns `true` if the interval intersects with the `other` interval.
    @inlinable public func intersects(with other: Interval) -> Bool {
        contains(other.a) || contains(other.b)
    }

    /// Returns the interval that is the intersection of this interval with the `other` interval.
    /// If the intervals do not intersect, return `nil`.
    @inlinable public func intersection(with other: Interval) -> Interval? {
        guard intersects(with: other) else { return nil }
        return Interval(Swift.max(min, other.min), Swift.min(max, other.max))
    }

    /// Returns an interval with `a` being the least bound of the two intervals,
    /// and `b` being the greatest bound of the two intervals.
    @inlinable public func extent(with other: Interval) -> Interval {
        Interval(Swift.min(min, other.min), Swift.max(max, other.max))
    }
}

extension Interval where Bound: Comparable {
    /// Converts a `ClosedRange` to an Interval.
    @inlinable public init(_ i: ClosedRange<Bound>) {
        self.a = i.lowerBound
        self.b = i.upperBound
    }

    /// Converts this `Interval` to a `ClosedRange`. If `a` > `b` then `b`
    /// will be the range's `lowerBound`.
    @inlinable public var closedRange: ClosedRange<Bound> {
        let i = normalized()
        return i.a ... i.b
    }
}

extension Interval where Bound: FloatingPoint {
    @inlinable public func at(_ scalar: Bound) -> Bound {
        scalar * (b - a) + a
    }
    
    @inlinable public func scalar(at bound: Bound) -> Bound {
        (a - bound) / (a - b)
    }
}

extension Interval where Bound: AdditiveArithmetic & Comparable {
    @inlinable public func inset(by x: Bound) -> Interval<Bound> {
        if isDescending {
            return (a - x) .. (b + x)
        } else {
            return (a + x) .. (b - x)
        }
    }
}

extension Interval where Bound: SIMD {
    @inlinable public func at<S>(_ scalar: S) -> Bound where S == Bound.Scalar, Bound.Scalar: FloatingPoint {
        scalar * (b - a) + a
    }
}

extension Interval where Bound == Date {
    @inlinable public func at(_ scalar: Double) -> Date {
        let ta = a.timeIntervalSinceReferenceDate
        let tb = b.timeIntervalSinceReferenceDate
        return Date(timeIntervalSinceReferenceDate: scalar * (tb - ta) + ta)
    }
    
    @inlinable public func scalar(at bound: Date) -> Double {
        let ta = a.timeIntervalSinceReferenceDate
        let tb = b.timeIntervalSinceReferenceDate
        let tbound = bound.timeIntervalSinceReferenceDate
        return (ta - tbound) / (ta - tb)
    }
}

#if canImport(CoreGraphics)

import CoreGraphics

extension Interval where Bound == CGPoint {
    public func at(_ scalar: CGFloat) -> CGPoint {
        CGPoint(x: (a.x..b.x).at(scalar), y: (a.y..b.y).at(scalar))
    }
}

extension Interval where Bound == CGVector {
    public func at(_ scalar: CGFloat) -> CGVector {
        CGVector(dx: (a.dx..b.dx).at(scalar), dy: (a.dy..b.dy).at(scalar))
    }
}

extension Interval where Bound == CGSize {
    public func at(_ scalar: CGFloat) -> CGSize {
        CGSize(width: (a.width..b.width).at(scalar), height: (a.height..b.height).at(scalar))
    }
}

extension Interval where Bound == CGRect {
    public func at(_ scalar: CGFloat) -> CGRect {
        CGRect(origin: (a.origin..b.origin).at(scalar), size: (a.size..b.size).at(scalar))
    }
}

#endif
