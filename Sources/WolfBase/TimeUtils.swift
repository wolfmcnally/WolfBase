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

public let nanosecondsPerSecond = 1_000_000_000.0
public let microsecondsPerSecond = 1_000_000.0
public let millisecondsPerSecond = 1_000.0
public let secondsPerMinute: TimeInterval = 60.0
public let minutesPerHour = 60.0
public let secondsPerHour: TimeInterval = secondsPerMinute * minutesPerHour
public let hoursPerDay = 24.0
public let minutesPerDay = minutesPerHour * hoursPerDay
public let secondsPerDay: TimeInterval = secondsPerMinute * minutesPerDay
public let daysPerWeek = 7.0
public let minutesPerWeek = minutesPerDay * daysPerWeek
public let secondsPerWeek: TimeInterval = secondsPerMinute * minutesPerWeek
public let daysPerAverageMonth = 30.436875
public let minutesPerAverageMonth = minutesPerDay * daysPerAverageMonth
public let secondsPerAverageMonth: TimeInterval = secondsPerMinute * minutesPerAverageMonth
public let daysPerAverageYear = 365.2425
public let minutesPerAverageYear = minutesPerDay * daysPerAverageYear
public let secondsPerAverageYear: TimeInterval = secondsPerMinute * minutesPerAverageYear

public func toNanoseconds(seconds: TimeInterval) -> UInt64 {
    precondition(seconds >= 0)
    return UInt64(seconds * nanosecondsPerSecond)
}
