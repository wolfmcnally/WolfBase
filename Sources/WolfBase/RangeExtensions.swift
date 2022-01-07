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

#if canImport(CoreFoundation)
import CoreFoundation
extension NSRange {
    public init(_ c: CFRange) {
        self.init(location: c.location, length: c.length)
    }

    public init(_ r: Range<Int>) {
        self.init(location: r.lowerBound, length: r.count)
    }
}

extension CFRange {
    public init(_ n: NSRange) {
        self.init(location: n.location, length: n.length)
    }

    public init(_ r: Range<Int>) {
        self.init(location: r.lowerBound, length: r.count)
    }
}

extension CFRange: Equatable {
    public static func ==(lhs: CFRange, rhs: CFRange) -> Bool {
        lhs.location == rhs.location && lhs.length == rhs.length
    }
}

extension Range where Bound == CFIndex {
    public init(_ c: CFRange) {
        let loc = c.location
        let len = c.length
        self = loc ..< (loc + len)
    }
}
#endif
