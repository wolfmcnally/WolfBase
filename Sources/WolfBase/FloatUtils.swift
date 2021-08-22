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

//:Todo Test this

public func serialize<I>(_ n: I) -> Data where I: FloatingPoint {
    var d = Data(repeating: 0, count: MemoryLayout<I>.size)
    d.withUnsafeMutableBytes {
        $0.bindMemory(to: I.self).baseAddress!.pointee = n
    }
    return d
}

public func deserialize<T, D>(_ t: T.Type, _ data: D) -> T? where T: FloatingPoint, D : DataProtocol {
    guard data.count >= MemoryLayout<T>.size else {
        return nil
    }
    return withUnsafeBytes(of: data) { p in
        p.bindMemory(to: T.self).baseAddress!.pointee
    }
}

extension Float: Serializable {
    public var serialized: Data {
        serialize(self)
    }
}

extension Double: Serializable {
    public var serialized: Data {
        serialize(self)
    }
}

extension CGFloat: Serializable {
    public var serialized: Data {
        serialize(self)
    }
}

@available(macOS 11.0, *)
extension Float16: Serializable {
    public var serialized: Data {
        serialize(self)
    }
}

#if arch(i386) || arch(x86_64)
extension Float80: Serializable {
    public var serialized: Data {
        serialize(self)
    }
}
#endif
