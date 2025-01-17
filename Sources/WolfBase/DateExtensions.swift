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

extension Date {
    /// "Absolute Time" (CFAbsoluteTime) is bit-for-bit reconstructable, while Date.timeIntervalSince1970 and similar are not.
    public init(absoluteTime: Double) {
        self = CFDateCreate(kCFAllocatorDefault, absoluteTime)! as Date
    }
    
    /// "Absolute Time" (CFAbsoluteTime) is bit-for-bit reconstructable, while Date.timeIntervalSince1970 and similar are not.
    public var absoluteTime: Double {
        CFDateGetAbsoluteTime(self as CFDate)
    }
}

extension Date {
    public init(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
        self = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone.init(identifier: "GMT"), year: year, month: month, day: day, hour: hour, minute: minute, second: second).date!
    }
    
    @available(watchOS 8.0, *)
    @available(tvOS 15.0, *)
    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    public init(iso8601 s: String) throws {
        // 2022-01-01
        var s = s
        if s.count == 10 {
            s += "T00:00:00Z"
        }
        self = try Date(s, strategy: .iso8601)
    }

    /// If the `Date`'s time is `00:00:00 UTC`, it returns just the date with the format
    /// `"yyyy-MM-dd"`. Otherwise, it returns the full ISO-8601 formatted string.
    public var ISO8601UTC: String {
        // Create a UTC calendar
        var utcCalendar = Calendar(identifier: .gregorian)
        utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!

        // Extract UTC date components
        let components = utcCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        
        // Check if time is exactly midnight
        if let hour = components.hour,
           let minute = components.minute,
           let second = components.second,
           hour == 0 && minute == 0 && second == 0 {
            // Only date is needed: use a formatter with just the date style.
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = utcCalendar
            dateFormatter.timeZone = utcCalendar.timeZone
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: self)
        } else {
            // Full ISO-8601 with time. We can safely use ISO8601DateFormatter.
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.timeZone = utcCalendar.timeZone
            // Using the format with seconds precision.
            isoFormatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone]
            return isoFormatter.string(from: self)
        }
    }
}

public func deserialize<T, D>(_ t: T.Type, _ data: D) -> Date? where T : DateTag, D : DataProtocol {
    guard let interval = deserialize(Double.self, data) else {
        return nil
    }
    return Date(absoluteTime: interval)
}

extension Date: Serializable {
    public var serialized: Data {
        absoluteTime.serialized
    }
}

public protocol DateTag { }

extension Date: DateTag { }
