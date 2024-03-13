import Foundation

// Version 1: Transform an instance of an input type into an instance of
// a possibly different output type.
public func with<I, O>(_ t: I, op: (I) throws -> O) rethrows -> O {
    try op(t)
}

// Version 2: Perform an in-place mutation of an instance.
public func with<T>(_ t: inout T, op: (inout T) throws -> Void) rethrows {
    try op(&t)
}

// Version 3: Perform a mutation on a copy of an instance and return the
// modified copy.
public func with<T>(_ t: T, op: (inout T) throws -> Void) rethrows -> T {
    var t = t
    try op(&t)
    return t
}
