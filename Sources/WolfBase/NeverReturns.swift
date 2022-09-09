import Foundation

@_transparent
public func todo(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("todo", file: file, line: line)
}

@_transparent
public func unimplemented(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("unimplemented", file: file, line: line)
}
