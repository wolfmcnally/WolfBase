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

public func scale<Bound>(domain: Interval<Bound>, range: Interval<Bound>) -> (Bound) -> Bound where Bound: FloatingPoint {
    {
        range.scale(domain.descale($0))
    }
}

public func scale<S>(domain: Interval<S.Scalar>, range: Interval<S>) -> (S.Scalar) -> S where S: SIMD, S.Scalar: FloatingPoint {
    {
        range.scale(domain.descale($0))
    }
}

public func scale(domain: Interval<Double>, range: Interval<Colour>) -> (Double) -> Colour {
    {
        range.scale(domain.descale($0))
    }
}

public func scale(domain: Interval<Date>, range: Interval<Double>) -> (Date) -> Double {
    {
        range.scale(domain.descale($0))
    }
}

public func scale(domain: DurationUnit, range: DurationUnit) -> (Double) -> Double {
    {
        range.scale(domain.descale($0))
    }
}
