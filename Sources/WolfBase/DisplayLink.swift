#if canImport(UIKit)
import UIKit

#if !os(watchOS)
public class DisplayLink {
    private var displayLink: CADisplayLink!
    private let onFrame: (DisplayLink) -> Void
    
    public var firstTimestamp: CFTimeInterval!
    public var timestamp: CFTimeInterval { displayLink.timestamp }
    public var duration: CFTimeInterval { displayLink.duration }
    public var elapsedTime: CFTimeInterval { timestamp - firstTimestamp }
    public var targetTimestamp: CFTimeInterval { displayLink.targetTimestamp }

    public init(preferredFramesPerSecond: Int = 60, onFrame: @escaping (DisplayLink) -> Void) {
        self.onFrame = onFrame
        self.displayLink = CADisplayLink(target: self, selector: #selector(displayLinkFired))
        displayLink.preferredFramesPerSecond = preferredFramesPerSecond
        displayLink.add(to: RunLoop.main, forMode: .common)
    }

    deinit {
        displayLink.invalidate()
    }

    @objc private func displayLinkFired(displayLink: CADisplayLink) {
        if firstTimestamp == nil {
            firstTimestamp = timestamp
        }
        onFrame(self)
    }

    public func invalidate() { displayLink.invalidate() }

    public var isPaused: Bool {
        get { displayLink.isPaused }
        set { displayLink.isPaused = newValue }
    }

    public var preferredFramesPerSecond: Int {
        get { displayLink.preferredFramesPerSecond }
        set { displayLink.preferredFramesPerSecond = newValue }
    }
}
#endif

#endif
