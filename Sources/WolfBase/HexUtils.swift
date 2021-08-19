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

public func toData(hex: String) -> Data? {
    let len = hex.count / 2
    var result = Data(capacity: len)
    for i in 0..<len {
        let j = hex.index(hex.startIndex, offsetBy: i*2)
        let k = hex.index(j, offsetBy: 2)
        let bytes = hex[j..<k]
        if var num = UInt8(bytes, radix: 16) {
            result.append(&num, count: 1)
        } else {
            return nil
        }
    }
    return result
}

public func toBytes(hex: String) -> [UInt8]? {
    toData(hex: hex)?.bytes
}

public func toHex(data: Data) -> String {
    data.reduce(into: "") {
        $0 += String(format: "%02x", $1)
    }
}

public func toHex(bytes: [UInt8]) -> String {
    toHex(data: bytes.data)
}
