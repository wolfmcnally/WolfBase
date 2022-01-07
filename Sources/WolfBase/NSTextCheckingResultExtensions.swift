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

extension NSTextCheckingResult {
    public func stringRange(at index: Int, in string: String) -> StringRange {
        return string.stringRange(from: range(at: index))!
    }

    public func captureRanges(in string: String) -> [StringRange] {
        var result = [StringRange]()
        for i in 1 ..< numberOfRanges {
            result.append(stringRange(at: i, in: string))
        }
        return result
    }
}

extension NSTextCheckingResult {
    public func get(at index: Int, in string: String) -> StringRangeReplacement {
        let range = self.stringRange(at: index, in: string)
        let text = String(string[range])
        return (range, text)
    }
}
