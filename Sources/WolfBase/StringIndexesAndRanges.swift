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

public typealias StringIndex = String.Index
public typealias StringRange = Range<StringIndex>
public typealias StringRangeReplacement = (StringRange, String)

extension String {
    public func rangeDescription(_ range: StringRange) -> String {
        let rangeStart = distance(from: startIndex, to: range.lowerBound)
        let rangeEnd = distance(from: startIndex, to: range.upperBound)
        return "\(rangeStart)..<\(rangeEnd)"
    }

    public func stringRange(nsLocation: Int, nsLength: Int) -> StringRange? {
        let utf16view = utf16
        let from16 = utf16view.index(utf16view.startIndex, offsetBy: nsLocation, limitedBy: utf16view.endIndex)!
        let to16 = utf16view.index(from16, offsetBy: nsLength, limitedBy: utf16view.endIndex)!
        if let from = StringIndex(from16, within: self),
            let to = StringIndex(to16, within: self) {
            return from ..< to
        }
        return nil
    }

    public func stringRange(from nsRange: NSRange?) -> StringRange? {
        guard let nsRange = nsRange else { return nil }
        return stringRange(nsLocation: nsRange.location, nsLength: nsRange.length)
    }

    public func nsLocation(fromIndex index: StringIndex) -> Int {
        return nsRange(from: index..<index)!.location
    }

    public func index(fromLocation nsLocation: Int) -> StringIndex {
        return stringRange(from: NSRange(location: nsLocation, length: 0))!.lowerBound
    }

    public func nsRange(from stringRange: StringRange?) -> NSRange? {
        guard let stringRange = stringRange else { return nil }
        let utf16view = utf16
        let from = String.UTF16View.Index(stringRange.lowerBound, within: utf16view)!
        let to = String.UTF16View.Index(stringRange.upperBound, within: utf16view)!
        let location = utf16view.distance(from: utf16view.startIndex, to: from)
        let length = utf16view.distance(from: from, to: to)
        return NSRange(location: location, length: length)
    }

    #if !os(Linux)
    public func stringRange(from cfRange: CFRange?) -> StringRange? {
        guard let cfRange = cfRange else { return nil }
        return stringRange(nsLocation: cfRange.location, nsLength: cfRange.length)
    }

    public func cfRange(from stringRange: StringRange?) -> CFRange? {
        guard let r = nsRange(from: stringRange) else { return nil }
        return CFRange(r)
    }

    public var cfRange: CFRange {
        return cfRange(from: stringRange)!
    }
    #endif

    public var nsRange: NSRange {
        return nsRange(from: stringRange)!
    }

    public var stringRange: StringRange {
        return startIndex..<endIndex
    }

    public func stringRange(start: Int, end: Int? = nil) -> StringRange {
        let s = self.index(self.startIndex, offsetBy: start)
        let e = self.index(self.startIndex, offsetBy: (end ?? start))
        return s..<e
    }

    public func stringRange(_ r: Range<Int>) -> StringRange {
        return stringRange(start: r.lowerBound, end: r.upperBound)
    }

    public func substring(start: Int, end: Int? = nil) -> String {
        return String(self[stringRange(start: start, end: end)])
    }

    public func substring(_ r: Range<Int>) -> String {
        return substring(start: r.lowerBound, end: r.upperBound)
    }
}

extension String {
    public func convert(index: StringIndex, from string: String, offset: Int = 0) -> StringIndex {
        let distance = string.distance(from: string.startIndex, to: index) + offset
        return self.index(self.startIndex, offsetBy: distance)
    }

    public func convert(index: StringIndex, to string: String, offset: Int = 0) -> StringIndex {
        let distance = self.distance(from: self.startIndex, to: index) + offset
        return string.index(string.startIndex, offsetBy: distance)
    }

    public func convert(range: StringRange, from string: String, offset: Int = 0) -> StringRange {
        let s = convert(index: range.lowerBound, from: string, offset: offset)
        let e = convert(index: range.upperBound, from: string, offset: offset)
        return s..<e
    }

    public func convert(range: StringRange, to string: String, offset: Int = 0) -> StringRange {
        let s = convert(index: range.lowerBound, to: string, offset: offset)
        let e = convert(index: range.upperBound, to: string, offset: offset)
        return s..<e
    }
}
