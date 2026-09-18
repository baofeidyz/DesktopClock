import AppKit
import SwiftUI

@MainActor
final class DraggableHostingView<Content: View>: NSHostingView<Content> {
    var isWindowDraggingEnabled: () -> Bool = { true }

    override func mouseDown(with event: NSEvent) {
        guard isWindowDraggingEnabled(), let window else {
            super.mouseDown(with: event)
            return
        }

        window.performDrag(with: event)
    }
}

final class FloatingPanel: NSPanel {
    init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        level = .statusBar
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        isOpaque = false
        backgroundColor = .clear
        hasShadow = false
        isMovableByWindowBackground = true
        hidesOnDeactivate = false
    }

    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}
