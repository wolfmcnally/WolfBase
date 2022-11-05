import Foundation

@propertyWrapper
public struct Notify<T: Equatable> {
    public var value: T!
    public var onChange: (() -> Void)?

    public init() {
    }

    public var wrappedValue: T {
        get { value }
        set {
            if value != newValue {
                value = newValue
                onChange?()
            }
        }
    }
}

