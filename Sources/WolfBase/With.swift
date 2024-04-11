import Foundation

// Perform an in-place mutation of an instance.
public func with<T>(_ t: inout T, op: (inout T) throws -> Void) rethrows {
    try op(&t)
}

// Perform a mutation on a copy of an instance and return the modified copy.
@discardableResult
public func with<T>(_ t: T, op: (inout T) throws -> Void) rethrows -> T {
    var t = t
    try op(&t)
    return t
}
