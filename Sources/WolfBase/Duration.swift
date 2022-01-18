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

public struct Duration {
    public let value: Double
    public let unit: Unit

    public enum Unit: Int, Comparable, Hashable, Identifiable, CustomStringConvertible {
        case nanosecond
        case microsecond
        case millisecond
        case second
        case minute
        case hour
        case day
        case week
        case month
        case year

        public static func < (lhs: Duration.Unit, rhs: Duration.Unit) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        private static let abbreviations = ["ns", "µs", "ms", "s", "m", "h", "d", "w", "m", "y"]
        
        public var abbreviation: String {
            Self.abbreviations[rawValue]
        }
        
        public var seconds: TimeInterval {
            switch self {
            case .nanosecond:
                return 1 / nanosecondsPerSecond
            case .microsecond:
                return 1 / microsecondsPerSecond
            case .millisecond:
                return 1 / millisecondsPerSecond
            case .second:
                return 1
            case .minute:
                return secondsPerMinute
            case .hour:
                return secondsPerHour
            case .day:
                return secondsPerDay
            case .week:
                return secondsPerWeek
            case .month:
                return secondsPerAverageMonth
            case .year:
                return secondsPerAverageYear
            }
        }
        
        public var id: Int {
            rawValue
        }
        
        public var description: String {
            abbreviation
        }
    }

    public init(value: Double, unit: Unit) {
        self.value = value
        self.unit = unit
    }
    
    public init(seconds: TimeInterval, unit: Unit) {
        self.unit = unit
        self.value = Self.fromSeconds(seconds, to: unit)
    }
    
    public init(nanoseconds: Double) {
        self.init(value: nanoseconds, unit: .nanosecond)
    }
    
    public init(microseconds: Double) {
        self.init(value: microseconds, unit: .microsecond)
    }
    
    public init(milliseconds: Double) {
        self.init(value: milliseconds, unit: .millisecond)
    }
    
    public init(seconds: Double) {
        self.init(value: seconds, unit: .second)
    }
    
    public init(minutes: Double) {
        self.init(value: minutes, unit: .minute)
    }
    
    public init(hours: Double) {
        self.init(value: hours, unit: .hour)
    }
    
    public init(days: Double) {
        self.init(value: days, unit: .day)
    }
    
    public init(weeks: Double) {
        self.init(value: weeks, unit: .week)
    }
    
    public init(months: Double) {
        self.init(value: months, unit: .month)
    }
    
    public init(years: Double) {
        self.init(value: years, unit: .year)
    }
    
    public var nanoseconds: Double {
        Self.fromSeconds(seconds, to: .nanosecond)
    }
    
    public var microseconds: Double {
        Self.fromSeconds(seconds, to: .microsecond)
    }
    
    public var milliseconds: Double {
        Self.fromSeconds(seconds, to: .millisecond)
    }
    
    public var seconds: Double {
        Self.toSeconds(value, from: unit)
    }
    
    public var minutes: Double {
        Self.fromSeconds(seconds, to: .minute)
    }
    
    public var hours: Double {
        Self.fromSeconds(seconds, to: .hour)
    }
    
    public var days: Double {
        Self.fromSeconds(seconds, to: .day)
    }
    
    public var weeks: Double {
        Self.fromSeconds(seconds, to: .week)
    }
    
    public var months: Double {
        Self.fromSeconds(seconds, to: .month)
    }
    
    public var year: Double {
        Self.fromSeconds(seconds, to: .year)
    }

    public static func fromSeconds(_ seconds: TimeInterval, to unit: Unit) -> Double {
        seconds / unit.seconds
    }
    
    public static func toSeconds(_ value: Double, from unit: Unit) -> TimeInterval {
        value * unit.seconds
    }
    
    public func toUnit(_ unit: Unit) -> Duration {
        Duration(value: Self.fromSeconds(seconds, to: unit), unit: unit)
    }
    
    public func units(_ unit: Unit) -> Double {
        seconds / unit.seconds
    }
}

extension Duration: Equatable {
    public static func == (lhs: Duration, rhs: Duration) -> Bool {
        lhs.seconds == rhs.seconds
    }
}

extension Duration: Comparable {
    public static func < (lhs: Duration, rhs: Duration) -> Bool {
        lhs.seconds < rhs.seconds
    }
}

private let formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.maximumFractionDigits = 4
    return f
}()

extension Duration: CustomStringConvertible {
    public var description: String {
        formatter.string(for: value)! + unit.description
    }
}

public func + (lhs: Duration, rhs: Duration) -> Duration {
    let lSeconds = lhs.seconds
    let rSeconds = rhs.seconds
    let unit = lhs.unit < rhs.unit ? rhs.unit : lhs.unit
    return Duration(seconds: lSeconds + rSeconds, unit: unit)
}

public func += (lhs: inout Duration, rhs: Duration) {
    lhs = lhs + rhs
}

public prefix func - (d: Duration) -> Duration {
    Duration(value: -d.value, unit: d.unit)
}

public func -= (lhs: inout Duration, rhs: Duration) {
    lhs = lhs - rhs
}

public func - (lhs: Duration, rhs: Duration) -> Duration {
    lhs + (-rhs)
}

public func * (lhs: Duration, rhs: Double) -> Duration {
    Duration(value: lhs.value * rhs, unit: lhs.unit)
}

public func *= (lhs: inout Duration, rhs: Double) {
    lhs = lhs * rhs
}

public func / (lhs: Duration, rhs: Double) -> Duration {
    Duration(value: lhs.value / rhs, unit: lhs.unit)
}

public func /= (lhs: inout Duration, rhs: Double) {
    lhs = lhs / rhs
}

public func + (lhs: Date, rhs: Duration) -> Date {
    lhs.addingTimeInterval(rhs.seconds)
}

public func += (lhs: inout Date, rhs: Duration) {
    lhs = lhs + rhs
}

public func - (lhs: Date, rhs: Duration) -> Date {
    lhs.addingTimeInterval(-rhs.seconds)
}

public func -= (lhs: inout Date, rhs: Duration) {
    lhs = lhs - rhs
}

extension DateComponentsFormatter {
    public func string(from duration: Duration) -> String? {
        string(from: duration.seconds)
    }
}

extension Duration: Hashable {
}
