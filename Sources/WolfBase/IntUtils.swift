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

public func toData<I>(_ n: I) -> Data where I: FixedWidthInteger {
    let count = MemoryLayout<I>.size
    var d = Data(repeating: 0, count: count)
    d.withUnsafeMutableBytes {
        $0.bindMemory(to: I.self).baseAddress!.pointee = n.bigEndian
    }
    return d
}

public func toInt<I>(_ t: I.Type, _ data: Data) -> I where I: FixedWidthInteger {
    let count = MemoryLayout<I>.size
    precondition(data.count >= count)
    return data.withUnsafeBytes {
        I(bigEndian: $0.bindMemory(to: I.self).baseAddress!.pointee)
    }
}

extension FixedWidthInteger {
    public var data: Data {
        toData(self)
    }
}

extension Data {
    public var uint: UInt {
        toInt(UInt.self, self)
    }

    public var uint8: UInt8 {
        toInt(UInt8.self, self)
    }

    public var uint16: UInt16 {
        toInt(UInt16.self, self)
    }

    public var uint32: UInt32 {
        toInt(UInt32.self, self)
    }

    public var uint64: UInt64 {
        toInt(UInt64.self, self)
    }

    public var int: Int {
        toInt(Int.self, self)
    }

    public var int8: Int8 {
        toInt(Int8.self, self)
    }

    public var int16: Int16 {
        toInt(Int16.self, self)
    }

    public var int32: Int32 {
        toInt(Int32.self, self)
    }

    public var int64: Int64 {
        toInt(Int64.self, self)
    }
}
