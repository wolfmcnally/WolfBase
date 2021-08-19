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

//  The purpose of the † (dagger) postfix operator (typed by pressing option-t) is to create a string representation of an optional value that is the unwrapped version of the value if it is not nil, and simply "nil" if it is.
//
//    var a: Int?
//
//    print(a)          // prints "nil", also has warning, "Expression implicitly coerced from 'Int?' to Any"
//    print("\(a)")     // prints "nil"
//    print(a†)         // prints "nil"
//
//    a = 5
//
//    print(a)          // prints "Optional(5)", also has warning, "Expression implicitly coerced from 'Int?' to Any"
//    print("\(a)")     // prints "Optional(5)"
//    print(a†)         // prints "5"

import Foundation

public protocol OptionalProtocol {
    func unwrappedString() -> String
    var isNone: Bool { get }
    var isSome: Bool { get }
    func unwrap() -> Any
    func unwrap<T>(_ t: T.Type) -> T
}

extension Optional: OptionalProtocol {
    public func unwrappedString() -> String {
        switch self {
        case .some(let wrapped as OptionalProtocol): return wrapped.unwrappedString()
        case .some(let wrapped): return String(describing: wrapped)
        case .none: return String(describing: self)
        }
    }

    public var isNone: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }

    public var isSome: Bool {
        switch self {
        case .none: return false
        case .some: return true
        }
    }

    public func unwrap() -> Any {
        switch self {
        case .none: preconditionFailure("trying to unwrap nil")
        case .some(let unwrapped): return unwrapped
        }
    }
    
    public func unwrap<T>(_ t: T.Type) -> T {
        unwrap() as! T
    }
}

public func unwrap<A>(_ any: A) -> Any {
    guard let optional = any as? OptionalProtocol, optional.isSome else {
        return any
    }
    return optional.unwrap()
}

public func unwrap<T, A>(_ t: T.Type, _ any: A) -> T {
    unwrap(any) as! T
}

postfix operator †
public postfix func † <X> (x: X?) -> String {
    return x.unwrappedString()
}
