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

public enum ColourError: Error {
    case invalidHexDigit
    case invalidColourStringFormat
}

// This type is named `Colour` using the British spelling to distinguish it from `SwiftUI.Color`
public struct Colour {
    public var c: SIMD4<Double>

    @inlinable public var red: Double {
        get { c[0] }
        set { c[0] = newValue }
    }

    @inlinable public var green: Double {
        get { c[1] }
        set { c[1] = newValue }
    }

    @inlinable public var blue: Double {
        get { c[2] }
        set { c[2] = newValue }
    }

    @inlinable public var alpha: Double {
        get { c[3] }
        set { c[3] = newValue }
    }

    @inlinable public init(c: SIMD4<Double>) {
        self.c = c
    }

    @inlinable public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        c = [red, green, blue, alpha]
    }

    @inlinable public init(redByte: UInt8, greenByte: UInt8, blueByte: UInt8, alphaByte: UInt8 = 255) {
        let red = Double(redByte) / 255.0
        let green = Double(greenByte) / 255.0
        let blue = Double(blueByte) / 255.0
        let alpha = Double(alphaByte) / 255.0
        c = [red, green, blue, alpha]
    }

    @inlinable public init(white: Double, alpha: Double = 1.0) {
        c = [white, white, white, alpha]
    }

    @inlinable public init(data: Data) {
        let r = data[0]
        let g = data[1]
        let b = data[2]
        let a = data.count >= 4 ? data[3] : 255
        self.init(redByte: r, greenByte: g, blueByte: b, alphaByte: a)
    }

    @inlinable public init(colour: Colour, alpha: Double) {
        c = [colour.red, colour.green, colour.blue, alpha]
    }
}

extension Colour: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(red)
        try container.encode(green)
        try container.encode(blue)
        try container.encode(alpha)
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let red = try container.decode(Double.self)
        let green = try container.decode(Double.self)
        let blue = try container.decode(Double.self)
        let alpha = try container.decode(Double.self)
        c = [red, green, blue, alpha]
    }
}

extension Colour {
    // rgb
    // #rgb
    //
    // ^\s*#?(?<r>[[:xdigit:]])(?<g>[[:xdigit:]])(?<b>[[:xdigit:]])\s*$
    private static let singleHexColourRegex = try! NSRegularExpression(pattern: "^\\s*#?(?<r>[[:xdigit:]])(?<g>[[:xdigit:]])(?<b>[[:xdigit:]])\\s*$")

    // rrggbb
    // #rrggbb
    //
    // ^\s*#?(?<r>[[:xdigit:]]{2})(?<g>[[:xdigit:]]{2})(?<b>[[:xdigit:]]{2})\s*$
    private static let doubleHexColourRegex = try! NSRegularExpression(pattern: "^\\s*#?(?<r>[[:xdigit:]]{2})(?<g>[[:xdigit:]]{2})(?<b>[[:xdigit:]]{2})\\s*$")

    // 1 0 0
    // 1 0 0 1
    // 1.0 0.0 0.0
    // 1.0 0.0 0.0 1.0
    // .2 .3 .4 .5
    //
    // ^\s*(?<r>\d*(?:\.\d+)?)\s+(?<g>\d*(?:\.\d+)?)\s+(?<b>\d*(?:\.\d+)?)(?:\s+(?<a>\d*(?:\.\d+)?))?\s*$
    private static let floatColourRegex = try! NSRegularExpression(pattern: "^\\s*(?<r>\\d*(?:\\.\\d+)?)\\s+(?<g>\\d*(?:\\.\\d+)?)\\s+(?<b>\\d*(?:\\.\\d+)?)(?:\\s+(?<a>\\d*(?:\\.\\d+)?))?\\s*$")

    // r: .1 g: 0.512 b: 0.9
    // r: .1 g: 0.512 b: 0.9 a: 1
    // red: .1 green: 0.512 blue: 0.9
    // red: .1 green: 0.512 blue: 0.9 alpha: 1
    //
    // ^\s*(?:r(?:ed)?):\s+(?<r>\d*(?:\.\d+)?)\s+(?:g(?:reen)?):\s+(?<g>\d*(?:\.\d+)?)\s+(?:b(?:lue)?):\s+(?<b>\d*(?:\.\d+)?)(?:\s+(?:a(?:lpha)?):\s+(?<a>\d*(?:\.\d+)?))?
    private static let labeledColourRegex = try! NSRegularExpression(pattern: "^\\s*(?:r(?:ed)?):\\s+(?<r>\\d*(?:\\.\\d+)?)\\s+(?:g(?:reen)?):\\s+(?<g>\\d*(?:\\.\\d+)?)\\s+(?:b(?:lue)?):\\s+(?<b>\\d*(?:\\.\\d+)?)(?:\\s+(?:a(?:lpha)?):\\s+(?<a>\\d*(?:\\.\\d+)?))?")

    // h: .1 s: 0.512 b: 0.9
    // hue: .1 saturation: 0.512 brightness: 0.9
    // h: .1 s: 0.512 b: 0.9 alpha: 1
    // hue: .1 saturation: 0.512 brightness: 0.9 alpha: 1.0
    //
    // ^\s*(?:h(?:ue)?):\s+(?<h>\d*(?:\.\d+)?)\s+(?:s(?:aturation)?):\s+(?<s>\d*(?:\.\d+)?)\s+(?:b(?:rightness)?):\s+(?<b>\d*(?:\.\d+)?)(?:\s+(?:a(?:lpha)?):\s+(?<a>\d*(?:\.\d+)?))?
    private static let labeledHSBColourRegex = try! NSRegularExpression(pattern: "^\\s*(?:h(?:ue)?):\\s+(?<h>\\d*(?:\\.\\d+)?)\\s+(?:s(?:aturation)?):\\s+(?<s>\\d*(?:\\.\\d+)?)\\s+(?:b(?:rightness)?):\\s+(?<b>\\d*(?:\\.\\d+)?)(?:\\s+(?:a(?:lpha)?):\\s+(?<a>\\d*(?:\\.\\d+)?))?")

    
    private static func components(forSingleHexStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            guard let i = Data(hex: string) else {
                throw ColourError.invalidHexDigit
            }
            components[index] = Double(i[0]) / 15.0
        }
    }

    private static func components(forDoubleHexStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            guard let i = Data(hex: string) else {
                throw ColourError.invalidHexDigit
            }
            components[index] = Double(i[0]) / 255.0
        }
    }

    private static func components(forFloatStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            if let f = Double(string) {
                components[index] = Double(f)
            }
        }
    }

    private static func components(forLabeledStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            if let f = Double(string) {
                components[index] = Double(f)
            }
        }
    }

    private static func components(forLabeledHSBStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            if let f = Double(string) {
                components[index] = Double(f)
            }
        }
    }

    public init(string s: String) throws {
        var components: [Double] = [0.0, 0.0, 0.0, 1.0]
        var isHSB = false

        if let strings = Self.singleHexColourRegex.matchedSubstrings(in: s) {
            try type(of: self).components(forSingleHexStrings: strings, components: &components)
        } else if let strings = Self.doubleHexColourRegex.matchedSubstrings(in: s) {
            try type(of: self).components(forDoubleHexStrings: strings, components: &components)
        } else if let strings = Self.floatColourRegex.matchedSubstrings(in: s) {
            try type(of: self).components(forFloatStrings: strings, components: &components)
        } else if let strings = Self.labeledColourRegex.matchedSubstrings(in: s) {
            try type(of: self).components(forLabeledStrings: strings, components: &components)
        } else if let strings = Self.labeledHSBColourRegex.matchedSubstrings(in: s) {
            isHSB = true
            try type(of: self).components(forLabeledHSBStrings: strings, components: &components)
        } else {
            throw ColourError.invalidColourStringFormat
        }

        if isHSB {
            self = Colour(HSBColour(hue: components[0], saturation: components[1], brightness: components[2], alpha: components[3]))
        } else {
            self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
        }
    }
}

extension Colour {
    public static func random(alpha: Double = 1.0) -> Colour {
        Colour(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1),
            alpha: alpha
        )
    }

    public static func random<T>(alpha: Double = 1.0, using generator: inout T) -> Colour where T: RandomNumberGenerator {
        Colour(
            red: Double.random(in: 0...1, using: &generator),
            green: Double.random(in: 0...1, using: &generator),
            blue: Double.random(in: 0...1, using: &generator),
            alpha: alpha
        )
    }
}

extension Colour {
    // NOTE: Not gamma-corrected
    public var luminance: Double {
        red * 0.2126 + green * 0.7152 + blue * 0.0722
    }

    public func withAlphaComponent(_ alpha: Double) -> Colour {
        Colour(colour: self, alpha: alpha)
    }

    public func multiplied(by rhs: Double) -> Colour {
        Colour(red: red * rhs, green: green * rhs, blue: blue * rhs, alpha: alpha)
    }

    public func added(to rhs: Colour) -> Colour {
        Colour(red: red + rhs.red, green: green + rhs.green, blue: blue + rhs.blue, alpha: alpha)
    }

    public static func blend(from: Colour, to: Colour) -> (Double) -> Colour {
        {
            Colour(
                red: (from.red..to.red).at($0),
                green: (from.green..to.green).at($0),
                blue: (from.blue..to.blue).at($0),
                alpha: from.alpha)
        }
    }

    public func blend(to: Colour) -> (Double) -> Colour {
        Self.blend(from: self, to: to)
    }
    
    public func lighten() -> (Double) -> Colour {
        blend(to: .white)
    }
    
    public func darken() -> (Double) -> Colour {
        blend(to: .black)
    }

    /// Identity fraction is 0.0
    public func dodge() -> (Double) -> Colour {
        {
            let f = max(1.0 - $0, 1.0e-7)
            return Colour(
                red: min(red / f, 1.0),
                green: min(green / f, 1.0),
                blue: min(blue / f, 1.0),
                alpha: alpha)
        }
    }

    /// Identity fraction is 0.0
    public func burn() -> (Double) -> Colour {
        {
            let f = max(1.0 - $0, 1.0e-7)
            return Colour(
                red: min(1.0 - (1.0 - red) / f, 1.0),
                green: min(1.0 - (1.0 - green) / f, 1.0),
                blue: min(1.0 - (1.0 - blue) / f, 1.0),
                alpha: alpha)
        }
    }
}

extension Colour {
    public static let black = Colour(red: 0, green: 0, blue: 0, alpha: 1)
    public static let darkGray = Colour(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)
    public static let lightGray = Colour(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
    public static let white = Colour(red: 1, green: 1, blue: 1, alpha: 1)
    public static let gray = Colour(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
    public static let red = Colour(red: 1, green: 0, blue: 0, alpha: 1)
    public static let green = Colour(red: 0, green: 1, blue: 0, alpha: 1)
    public static let darkGreen = Colour(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    public static let blue = Colour(red: 0, green: 0, blue: 1, alpha: 1)
    public static let cyan = Colour(red: 0, green: 1, blue: 1, alpha: 1)
    public static let yellow = Colour(red: 1, green: 1, blue: 0, alpha: 1)
    public static let magenta = Colour(red: 1, green: 0, blue: 1, alpha: 1)
    public static let orange = Colour(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    public static let purple = Colour(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    public static let brown = Colour(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
    public static let clear = Colour(red: 0, green: 0, blue: 0, alpha: 0)
    public static let pink = Colour(red: 1, green: 0.75294118, blue: 0.79607843)

    public static let chartreuse = (Colour.yellow..Colour.green).at(0.5)
    public static let gold = Colour(redByte: 251, greenByte: 212, blueByte: 55)
    public static let blueGreen = Colour(redByte: 0, greenByte: 169, blueByte: 149)
    public static let mediumBlue = Colour(redByte: 0, greenByte: 110, blueByte: 185)
    public static let deepBlue = Colour(redByte: 60, greenByte: 55, blueByte: 149)
}

extension Colour: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Double

    public init(arrayLiteral elements: Double...) {
        if elements.count == 3 {
            c = SIMD4<Double>(elements[0], elements[1], elements[2], 1.0)
        } else if elements.count == 4 {
            c = SIMD4<Double>(elements[0], elements[1], elements[2], elements[3])
        } else {
            preconditionFailure("Array literal must have 3 or 4 elements.")
        }
    }
}

extension Colour: Equatable { }

extension Interval where Bound == Colour {
    @inlinable public func at(_ scalar: Double) -> Colour {
        Colour.blend(from: a, to: b)(scalar)
    }
}

extension Colour: CustomStringConvertible {
    public var description: String {
        return "Colour\(debugSummary)"
    }
}

extension Colour {
    public var debugSummary: String {
        var result: [String] = []
        var needAlpha = true
        switch (red, green, blue, alpha) {
        case (0, 0, 0, 0):
            result.append("clear")
            needAlpha = false
        case (0, 0, 0, _):
            result.append("black")
        case (1, 1, 1, _):
            result.append("white")
        case (0.5, 0.5, 0.5, _):
            result.append("gray")
        case (1, 0, 0, _):
            result.append("red")
        case (0, 1, 0, _):
            result.append("green")
        case (0, 0, 1, _):
            result.append("blue")
        case (0, 1, 1, _):
            result.append("cyan")
        case (1, 0, 1, _):
            result.append("magenta")
        case (1, 1, 0, _):
            result.append("yellow")
        default:
            result.append("r:\(String(red, precision: 2)) g:\(String(green, precision: 2)) b:\(String(blue, precision: 2))")
        }
        if needAlpha && alpha < 1.0 {
            result.append("a: \(String(alpha, precision: 2))")
        }
        return result.joined(separator: ", ").flanked("(", ")")
    }
}

@inlinable public func * (lhs: Colour, rhs: Double) -> Colour {
    return lhs.multiplied(by: rhs)
}

@inlinable public func + (lhs: Colour, rhs: Colour) -> Colour {
    return lhs.added(to: rhs)
}

extension Colour {
    @inlinable public func clamped() -> Colour {
        Colour(c: self.c.clamped(lowerBound: .zero, upperBound: .one))
    }
}
