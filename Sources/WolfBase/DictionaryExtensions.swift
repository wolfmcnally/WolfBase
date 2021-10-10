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

extension Dictionary {
    /// For dictionaries where `Value` is `Set<T>`, inserts the `value: T` into the `Set` corresponding to the given `key`, creating the `Set` if necessary.
    public mutating func add<T>(to key: Key, _ value: T) where Value == Set<T> {
        if self[key] == nil {
            self[key] = .init()
        }
        self[key]!.insert(value)
    }
    
    /// For dictionaries where `Value` is `Set<T>`, removes the `value: T` from the `Set` corresponding to the given `key`, and removes the `Set` from the dictionary if it becomes empty.
    ///
    /// Returns the removed value or `nil`.
    @discardableResult
    public mutating func remove<T>(from key: Key, _ value: T) -> T? where Value == Set<T> {
        guard self[key]?.contains(value) ?? false else {
            return nil
        }
        let removed = self[key]!.remove(value)
        if self[key]!.isEmpty {
            self.removeValue(forKey: key)
        }
        return removed
    }
    
    /// For dictionaries where `Value` is an `Array<T>`, appends the `value: T` to the `Array` corresponding to the given `key`, creating the `Array` if necessary.
    public mutating func add<T>(to key: Key, _ value: T) where Value == Array<T> {
        if self[key] == nil {
            self[key] = .init()
        }
        self[key]!.append(value)
    }
    
    /// For dictionaries where `Value` is an `Array<T>`, removes the first `value: T` from the `Array` corresponding to the given `key`, and removes the `Array` from the dictionary if it becomes empty.
    ///
    /// Returns the removed value or `nil`.
    @discardableResult
    public mutating func remove<T>(from key: Key, _ value: T) -> T? where Value == Array<T>, T: Equatable {
        guard let index = self[key]?.firstIndex(of: value) else {
            return nil
        }
        let removed = self[key]!.remove(at: index)
        if self[key]!.isEmpty {
            self.removeValue(forKey: key)
        }
        return removed
    }
}
