import SwiftUI

@available(watchOS 6.0, *)
@available(tvOS 13.0, *)
@available(iOS 13.0, *)
@available(macOS 10.15, *)
public class UndoStack: ObservableObject {
    @Published public var canUndo = false
    @Published public var canRedo = false
    
    public init() {
    }
    
    private var undoActions: [Action] = [] {
        didSet {
            self.canUndo = !self.undoActions.isEmpty
        }
    }
    
    private var redoActions: [Action] = [] {
        didSet {
            self.canRedo = !self.redoActions.isEmpty
        }
    }
    
    public func perform(_ action: @Sendable @escaping () -> Void, undo: @Sendable @escaping () -> Void) {
        redoActions.removeAll()
        action()
        undoActions.append(Action(undo: undo, redo: action))
    }
    
    public func push(_ action: @Sendable @escaping () -> Void, undo: @Sendable @escaping () -> Void) {
        redoActions.removeAll()
        undoActions.append(Action(undo: undo, redo: action))
    }

    public func undo() {
        guard let item = undoActions.popLast() else {
            return
        }

        DispatchQueue.main.async {
            item.undo()
        }
        
        redoActions.append(item)
    }
    
    public func redo() {
        guard let item = redoActions.popLast() else {
            return
        }
        
        DispatchQueue.main.async {
            item.redo()
        }
        
        undoActions.append(item)
    }
    
    public func invalidate() {
        undoActions.removeAll()
        redoActions.removeAll()
    }

    public struct Action : Sendable {
        let undo: @Sendable () -> Void
        let redo: @Sendable () -> Void
        
        public init(undo: @Sendable @escaping () -> Void, redo: @Sendable @escaping () -> Void) {
            self.undo = undo
            self.redo = redo
        }
    }
}
