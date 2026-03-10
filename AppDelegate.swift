import AppKit
import SwiftUI
import Combine

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var panel: FloatingPanel!
    private var statusBarController: StatusBarController!
    private let settings = ClockSettings.shared
    private var cancellables = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ notification: Notification) {
        let clockView = ClockView(settings: settings)
        let hostingView = NSHostingView(rootView: clockView)
        hostingView.frame = NSRect(x: 0, y: 0, width: 200, height: 50)

        let panelRect = NSRect(x: 0, y: 0, width: 200, height: 50)
        panel = FloatingPanel(contentRect: panelRect)
        panel.contentView = hostingView

        // Size to fit content
        hostingView.setFrameSize(hostingView.fittingSize)
        panel.setContentSize(hostingView.fittingSize)

        // Restore or set default position
        restoreWindowPosition()

        // Apply initial states
        applyClickThrough()
        applyPositionLock()

        // Observe settings changes
        settings.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.applyClickThrough()
                    self?.applyPositionLock()
                    self?.resizeToFit()
                }
            }
            .store(in: &cancellables)

        // Observe window move to persist position
        NotificationCenter.default.publisher(for: NSWindow.didMoveNotification, object: panel)
            .sink { [weak self] _ in
                self?.saveWindowPosition()
            }
            .store(in: &cancellables)

        panel.orderFrontRegardless()

        statusBarController = StatusBarController(settings: settings)
    }

    private func restoreWindowPosition() {
        if settings.windowPositionX >= 0, settings.windowPositionY >= 0 {
            panel.setFrameOrigin(NSPoint(x: settings.windowPositionX, y: settings.windowPositionY))
        } else {
            // Default to top-right corner of main screen
            if let screen = NSScreen.main {
                let screenFrame = screen.visibleFrame
                let panelSize = panel.frame.size
                let x = screenFrame.maxX - panelSize.width - 20
                let y = screenFrame.maxY - panelSize.height - 20
                panel.setFrameOrigin(NSPoint(x: x, y: y))
            }
        }
    }

    private func saveWindowPosition() {
        settings.windowPositionX = Double(panel.frame.origin.x)
        settings.windowPositionY = Double(panel.frame.origin.y)
    }

    private func applyClickThrough() {
        panel.ignoresMouseEvents = settings.isClickThroughEnabled
    }

    private func applyPositionLock() {
        // Window is movable only when: not locked AND not click-through
        panel.isMovableByWindowBackground = !settings.isPositionLocked && !settings.isClickThroughEnabled
    }

    private func resizeToFit() {
        if let hostingView = panel.contentView as? NSHostingView<ClockView> {
            let fittingSize = hostingView.fittingSize
            panel.setContentSize(fittingSize)
        }
    }
}
