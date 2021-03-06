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

public struct HSBColour: Codable {
    public var c: SIMD4<Double>

    @inlinable public var hue: Double {
        get { return c[0] }
        set { c[0] = newValue }
    }

    @inlinable public var saturation: Double {
        get { return c[1] }
        set { c[1] = newValue }
    }

    @inlinable public var brightness: Double {
        get { return c[2] }
        set { c[2] = newValue }
    }

    @inlinable public var alpha: Double {
        get { return c[3] }
        set { c[3] = newValue }
    }

    @inlinable public init(hue: Double, saturation: Double, brightness: Double, alpha: Double = 1) {
        c = [hue, saturation, brightness, alpha]
    }

    public init(_ color: Colour) {
        let r = color.red
        let g = color.green
        let b = color.blue
        let alpha = color.alpha

        let maxValue = max(r, g, b)
        let minValue = min(r, g, b)

        let brightness = maxValue

        let d = maxValue - minValue;
        let saturation = maxValue == 0 ? 0 : d / maxValue

        let hue: Double
        if (maxValue == minValue) {
            hue = 0 // achromatic
        } else {
            switch maxValue {
            case r: hue = ((g - b) / d + (g < b ? 6 : 0)) / 6
            case g: hue = ((b - r) / d + 2) / 6
            case b: hue = ((r - g) / d + 4) / 6
            default: fatalError()
            }
        }
        c = [hue, saturation, brightness, alpha]
    }
}

extension Colour {
    public init(_ hsb: HSBColour) {
        let v = hsb.brightness.clamped()
        let s = hsb.saturation.clamped()
        let red: Double
        let green: Double
        let blue: Double
        let alpha = hsb.alpha
        if s <= 0.0 {
            red = v
            green = v
            blue = v
        } else {
            var h = hsb.hue.truncatingRemainder(dividingBy: 1.0)
            if h < 0.0 { h += 1.0 }
            h *= 6.0
            let i = Int(floor(h))
            let f = h - Double(i)
            let p = v * (1.0 - s)
            let q = v * (1.0 - (s * f))
            let t = v * (1.0 - (s * (1.0 - f)))
            switch i {
            case 0: red = v; green = t; blue = p
            case 1: red = q; green = v; blue = p
            case 2: red = p; green = v; blue = t
            case 3: red = p; green = q; blue = v
            case 4: red = t; green = p; blue = v
            case 5: red = v; green = p; blue = q
            default: red = 0; green = 0; blue = 0; assert(false, "unknown hue sector")
            }
        }
        self = [red, green, blue, alpha]
    }
}
