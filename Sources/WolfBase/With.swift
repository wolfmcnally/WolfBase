import Foundation

/// The `with` function is based on [the Python `with` statement](https://peps.python.org/pep-0343/#examples).
/// It comes in two forms, one that takes a value and returns a result,
/// and one that takes an `inout` reference to an instance of a value type
/// and performs some manipulation on it.
///
/// - Example:
///
/// ```
/// func testWith() {
///     struct Dog {
///         var name: String
///     }
///
///     var dog = Dog(name: "Puppy")
///
///     with(&dog) { d in
///         d.name = "Magic"
///     }
///
///     print(dog.name) // "Magic"
///
///     class Cat {
///         var name: String
///         init(name: String) { self.name = name }
///         deinit { print("deinit \(name)") }
///     }
///
///     let cat = with(Cat(name: "Kitten")) { c in
///         c.name = "Elliot"
///         return c
///     }
///
///     with(cat) { c in
///         print(c.name) // "Elliot"
///     }
///
///     with(Cat(name: "Jellicle")) { c in
///         print(c.name) // Jellicle
///     }
///
///     print("after deinit Jellicle")
/// }
///
/// // Prints:
/// //   Magic
/// //   Elliot
/// //   Jellicle
/// //   deinit Jellicle
/// //   after deinit Jellicle
/// //   deinit Elliot
/// ```
///
public func with<T, Result>(_ t: T, op: (T) throws -> Result) rethrows -> Result {
    try op(t)
}

/// The `with` function is based on [the Python `with` statement](https://peps.python.org/pep-0343/#examples).
/// It comes in two forms, one that takes a value and returns a result,
/// and one that takes an `inout` reference to an instance of a value type
/// and performs some manipulation on it.
///
/// - Example:
///
/// ```
/// func testWith() {
///     struct Dog {
///         var name: String
///     }
///
///     var dog = Dog(name: "Puppy")
///
///     with(&dog) { d in
///         d.name = "Magic"
///     }
///
///     print(dog.name) // "Magic"
///
///     class Cat {
///         var name: String
///         init(name: String) { self.name = name }
///         deinit { print("deinit \(name)") }
///     }
///
///     let cat = with(Cat(name: "Kitten")) { c in
///         c.name = "Elliot"
///         return c
///     }
///
///     with(cat) { c in
///         print(c.name) // "Elliot"
///     }
///
///     with(Cat(name: "Jellicle")) { c in
///         print(c.name) // Jellicle
///     }
///
///     print("after deinit Jellicle")
/// }
///
/// // Prints:
/// //   Magic
/// //   Elliot
/// //   Jellicle
/// //   deinit Jellicle
/// //   after deinit Jellicle
/// //   deinit Elliot
/// ```
///
public func with<T>(_ t: inout T, op: (inout T) throws -> Void) rethrows {
    try op(&t)
}
