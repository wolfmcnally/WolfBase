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

public typealias StringReplacements = [String: String]

extension String {
    public func replacing(replacements: [StringRangeReplacement]) -> (string: String, ranges: [StringRange]) {
        let source = self
        var target = self
        var targetReplacedRanges = [StringRange]()
        let sortedReplacements = replacements.sorted { $0.0.lowerBound < $1.0.lowerBound }

        var totalOffset = 0
        for (sourceRange, replacement) in sortedReplacements {
            let replacementCount = replacement.count
            let rangeCount = source.distance(from: sourceRange.lowerBound, to: sourceRange.upperBound)
            let offset = replacementCount - rangeCount

            let newTargetStartIndex: StringIndex
            let originalTarget = target
            do {
                let targetStartIndex = target.convert(index: sourceRange.lowerBound, from: source, offset: totalOffset)
                let targetEndIndex = target.index(targetStartIndex, offsetBy: rangeCount)
                let targetReplacementRange = targetStartIndex..<targetEndIndex
                target.replaceSubrange(targetReplacementRange, with: replacement)
                newTargetStartIndex = target.convert(index: targetStartIndex, from: originalTarget)
            }

            targetReplacedRanges = targetReplacedRanges.map { originalTargetReplacedRange in
                let targetReplacedRange = target.convert(range: originalTargetReplacedRange, from: originalTarget)
                guard targetReplacedRange.lowerBound >= newTargetStartIndex else {
                    return targetReplacedRange
                }
                let adjustedStart = target.index(targetReplacedRange.lowerBound, offsetBy: offset)
                let adjustedEnd = target.index(adjustedStart, offsetBy: replacementCount)
                return adjustedStart..<adjustedEnd
            }
            let targetEndIndex = target.index(newTargetStartIndex, offsetBy: replacementCount)
            let targetReplacedRange = newTargetStartIndex..<targetEndIndex
            targetReplacedRanges.append(targetReplacedRange)
            totalOffset += offset
        }

        return (target, targetReplacedRanges)
    }
}

extension String {
    public func replacing(matches regex: NSRegularExpression, using block: (StringRangeReplacement) -> String) -> (string: String, ranges: [StringRange]) {
        let results = (regex ~?? self).map { match -> StringRangeReplacement in
            let matchRange = match.stringRange(in: self, at: 0)
            let substring = String(self[matchRange])
            let replacement = block((matchRange, substring))
            return (matchRange, replacement)
        }
        return replacing(replacements: results)
    }

    public func replacing(matches regex: NSRegularExpression, with replacement: String) -> String {
        replacing(matches: regex, using: { _ in replacement }).string
    }
}

// (?:(?<!\\)#\{(\w+)\})
// The quick #{color} fox #{action} over #{subject}.
private let placeholderReplacementRegex = try! ~/"(?:(?<!\\\\)#\\{(\\w+)\\})"

extension String {
    public func replacingPlaceholders(with replacements: StringReplacements) -> String {
        var replacementsArray = [StringRangeReplacement]()
        let matches = placeholderReplacementRegex ~?? self
        for match in matches {
            let matchRange = stringRange(from: match.range)!
            let placeholderRange = stringRange(from: match.range(at: 1))!
            let replacementName = String(self[placeholderRange])
            if let replacement = replacements[replacementName] {
                replacementsArray.append((matchRange, replacement))
            } else {
                fatalError("Replacement in \"\(self)\" not found for placeholder \"\(replacementName)\".")
            }
        }

        return replacing(replacements: replacementsArray).string
    }
}
