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

public func toData<S>(hex: S) -> Data? where S: StringProtocol {
    guard hex.count & 1 == 0 else {
        return nil
    }
    let len = hex.count / 2
    var result = Data(capacity: len)
    for i in 0..<len {
        let j = hex.index(hex.startIndex, offsetBy: i*2)
        let k = hex.index(j, offsetBy: 2)
        let hexByte = hex[j..<k]
        if var num = toByte(hex: hexByte) {
            result.append(&num, count: 1)
        } else {
            return nil
        }
    }
    return result
}

public func toByte<S>(hex: S) -> UInt8? where S: StringProtocol {
    guard hex.count == 2 else {
        return nil
    }
    return UInt8(hex, radix: 16)
}

public func toBytes<S>(hex: S) -> [UInt8]? where S: StringProtocol {
    toData(hex: hex)?.bytes
}

public func toHex(byte: UInt8) -> String {
    String(format: "%02x", byte)
}

public func toHex(data: Data) -> String {
    data.reduce(into: "") {
        $0 += toHex(byte: $1)
    }
}

public func toHex(bytes: [UInt8]) -> String {
    toHex(data: bytes.data)
}

extension FixedWidthInteger {
    public var hex: String {
        return withUnsafeByteBuffer(of: self.bigEndian) { p in
            p.reduce(into: "") {
                $0.append(toHex(byte: $1))
            }
        }
    }
}
