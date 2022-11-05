import Foundation

@propertyWrapper
public struct Memo<T> {
    private var value: T!
    public var onGet: (() -> T)!

    public init(_ onGet: (() -> T)? = nil) {
        self.onGet = onGet
    }

    public var wrappedValue: T {
        mutating get {
            if value == nil {
                value = onGet()
            }
            return value
        }
    }
    
    public mutating func reset() {
        value = nil
    }
}
