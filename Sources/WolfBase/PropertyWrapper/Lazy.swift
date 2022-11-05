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

@propertyWrapper
public enum LazyBox<T> {
    case uninitialized(() -> T)
    case initialized(T)
    
    public init(wrappedValue: @autoclosure @escaping () -> T) {
        self = .uninitialized(wrappedValue)
    }
    
    public var wrappedValue: T {
        mutating get {
            switch self {
            case .uninitialized(let initializer):
                let value = initializer()
                self = .initialized(value)
                return value
            case .initialized(let value):
                return value
            }
        }
        
        set {
            self = .initialized(newValue)
        }
    }
}

@propertyWrapper
public class Lazy<T> {
    @LazyBox private var value: T
    private let queue = DispatchQueue(label: "WolfBase.LazySync")
    
    public init(wrappedValue: @autoclosure @escaping () -> T) {
        self._value = LazyBox(wrappedValue: wrappedValue())
    }
    
    public var wrappedValue: T {
        get {
            queue.sync {
                value
            }
        }
        
        set {
            queue.sync {
                value = newValue
            }
        }
    }
}
