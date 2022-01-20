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

public struct TimeSpan {
    public var start: Date
    public var duration: Duration
    
    public init(start: Date, duration: Duration) {
        precondition(duration.value >= 0)
        self.start = start
        self.duration = duration
    }
    
    public init(start: Date, end: Date) {
        precondition(end >= start)
        let duration = Duration(
            value: end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate,
            unit: .second
        )
        self.init(start: start, duration: duration)
    }
    
    public init(_ range: ClosedRange<Date>) {
        self.init(start: range.lowerBound, end: range.upperBound)
    }
    
    public init(_ range: Range<Date>) {
        self.init(start: range.lowerBound, end: range.upperBound)
    }

    public var range: Range<Date> {
        get {
            start..<end
        }
        
        set {
            self.start = newValue.lowerBound
            self.end = newValue.upperBound
        }
    }

    public var end: Date {
        get {
            start + duration
        }
        
        set {
            start = newValue - duration
        }
    }
}

public struct ClosedTimeSpan {
    public var start: Date
    public var duration: Duration
    
    public init(start: Date, duration: Duration) {
        precondition(duration.value >= 0)
        self.start = start
        self.duration = duration
    }
    
    public init(start: Date, end: Date) {
        precondition(end >= start)
        let duration = Duration(
            value: end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate,
            unit: .second
        )
        self.init(start: start, duration: duration)
    }

    public init(_ range: ClosedRange<Date>) {
        self.init(start: range.lowerBound, end: range.upperBound)
    }

    public var range: ClosedRange<Date> {
        get {
            start...end
        }
        
        set {
            self.start = newValue.lowerBound
            self.end = newValue.upperBound
        }
    }
    
    public var end: Date {
        get {
            start + duration
        }
        
        set {
            start = newValue - duration
        }
    }
}
