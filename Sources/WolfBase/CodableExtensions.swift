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

extension Encodable {
    public func json(outputFormatting: JSONEncoder.OutputFormatting = []) -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        return try! encoder.encode(self)
    }
    
    public func jsonString(outputFormatting: JSONEncoder.OutputFormatting = []) -> String {
        json(outputFormatting: outputFormatting).utf8!
    }
    
    public var json: Data {
        json(outputFormatting: .sortedKeys)
    }

    public var jsonString: String {
        json.utf8!
    }
}

public func fromJSON<T>(_ t: T.Type, _ json: Data) throws -> T where T : Decodable {
    try JSONDecoder().decode(T.self, from: json)
}

public func fromJSON<T>(_ t: T.Type, _ json: String) throws -> T where T : Decodable {
    try fromJSON(T.self, json.utf8Data)
}

extension Decodable {
    public static func fromJSON(_ data: Data) throws -> Self {
        try WolfBase.fromJSON(Self.self, data)
    }

    public static func fromJSON(_ jsonString: String) throws -> Self {
        try WolfBase.fromJSON(Self.self, jsonString)
    }
}

extension Data {
    public func fromJSON<T>(to t: T.Type) throws -> T where T : Decodable {
        try WolfBase.fromJSON(T.self, self)
    }
}

extension String {
    public func fromJSON<T>(to t: T.Type) throws -> T where T : Decodable {
        try WolfBase.fromJSON(T.self, self)
    }
}
