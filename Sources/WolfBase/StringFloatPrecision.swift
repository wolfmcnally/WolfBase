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

extension String {
    public init(_ value: Double, precision: Int, minPrecision: Int = 0, locale: Locale? = nil, usesGroupingSeparator: Bool? = nil) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let locale = locale {
            formatter.locale = locale
            if let usesGroupingSeparator = usesGroupingSeparator {
                formatter.usesGroupingSeparator = usesGroupingSeparator
            }
        } else {
            #if os(macOS)
            formatter.localizesFormat = false
            #endif
            formatter.usesGroupingSeparator = usesGroupingSeparator ?? false
        }
        formatter.minimumFractionDigits = minPrecision
        formatter.maximumFractionDigits = precision
        self.init(formatter.string(from: value as NSNumber)!)
    }
    
    public init(_ value: Double, minPrecision: Int, locale: Locale? = nil, usesGroupingSeparator: Bool? = nil) {
        self.init(value, precision: 5, minPrecision: minPrecision, locale: locale, usesGroupingSeparator: usesGroupingSeparator)
    }

    public init(_ value: Float, precision: Int, minPrecision: Int = 0, locale: Locale? = nil, usesGroupingSeparator: Bool? = nil) {
        self.init(Double(value), precision: precision, minPrecision: minPrecision, locale: locale, usesGroupingSeparator: usesGroupingSeparator)
    }

    public init(_ value: Float, minPrecision: Int, locale: Locale? = nil, usesGroupingSeparator: Bool? = nil) {
        self.init(Double(value), minPrecision: minPrecision, locale: locale, usesGroupingSeparator: usesGroupingSeparator)
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: Double, precision: Int, minPrecision: Int = 0, locale: Locale? = nil, usesGroupingSeparator: Bool? = nil) {
        appendLiteral(String(value, precision: precision, minPrecision: minPrecision, locale: locale, usesGroupingSeparator: usesGroupingSeparator))
    }
    
    mutating func appendInterpolation(_ value: Double, minPrecision: Int, locale: Locale? = nil, usesGroupingSeparator: Bool? = nil) {
        appendInterpolation(value, precision: 5, minPrecision: minPrecision, locale: locale, usesGroupingSeparator: usesGroupingSeparator)
    }
    
    mutating func appendInterpolation(_ value: Float, precision: Int, minPrecision: Int = 0, locale: Locale? = nil, usesGroupingSeparator: Bool? = nil) {
        appendLiteral(String(value, precision: precision, minPrecision: minPrecision, locale: locale, usesGroupingSeparator: usesGroupingSeparator))
    }

    mutating func appendInterpolation(_ value: Float, minPrecision: Int, locale: Locale? = nil, usesGroupingSeparator: Bool? = nil) {
        appendInterpolation(value, precision: 5, minPrecision: minPrecision, locale: locale, usesGroupingSeparator: usesGroupingSeparator)
    }
}

precedencegroup AttributeAssignmentPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: ComparisonPrecedence
}

infix operator %% : AttributeAssignmentPrecedence

public func %% (value: Double, f: (precision: Int, locale: Locale)) -> String {
    return String(value, precision: f.precision, locale: f.locale)
}

public func %% (value: Float, f: (precision: Int, locale: Locale)) -> String {
    return String(value, precision: f.precision, locale: f.locale)
}

public func %% (value: Double, precision: Int) -> String {
    return String(value, precision: precision)
}

public func %% (value: Float, precision: Int) -> String {
    return String(value, precision: precision)
}
