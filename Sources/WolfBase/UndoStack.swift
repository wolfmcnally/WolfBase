import SwiftUI
import Observation

@available(watchOS 10.0, *)
@available(tvOS 17.0, *)
@available(iOS 17.0, *)
@available(macOS 14.0, *)
@Observable @MainActor
public class UndoStack {
    public var canUndo = false
    public var canRedo = false
    
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
    
    public func perform(_ action: @escaping () -> Void, undo: @escaping () -> Void) {
        redoActions.removeAll()
        action()
        undoActions.append(Action(undo: undo, redo: action))
    }
    
    public func push(_ action: @escaping () -> Void, undo: @escaping () -> Void) {
        redoActions.removeAll()
        undoActions.append(Action(undo: undo, redo: action))
    }

    public func undo() {
        guard let item = undoActions.popLast() else {
            return
        }

        item.undo()
        
        redoActions.append(item)
    }
    
    public func redo() {
        guard let item = redoActions.popLast() else {
            return
        }
        
        item.redo()
        
        undoActions.append(item)
    }
    
    public func invalidate() {
        undoActions.removeAll()
        redoActions.removeAll()
    }

    public struct Action {
        let undo: () -> Void
        let redo: () -> Void
        
        public init(undo: @escaping () -> Void, redo: @escaping () -> Void) {
            self.undo = undo
            self.redo = redo
        }
    }
}
