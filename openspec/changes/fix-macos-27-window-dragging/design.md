## Context

The clock is displayed in a borderless, non-activating `NSPanel` whose content is an `NSHostingView`. Dragging currently depends on `isMovableByWindowBackground`. On macOS 27, mouse events handled by the SwiftUI hosting hierarchy no longer reliably reach that implicit AppKit background-drag behavior.

## Goals / Non-Goals

**Goals:**
- Make dragging explicit at the AppKit hosting boundary.
- Use the system window-drag implementation so movement retains native behavior.
- Respect position lock and click-through settings.
- Do not impose an artificial inset on the user's chosen window position.

**Non-Goals:**
- Changing the clock appearance, saved-position format, or menu controls.
- Implementing custom coordinate calculations or gesture tracking.

## Decisions

- Subclass `NSHostingView<ClockView>` and override `mouseDown(with:)`. When dragging is enabled, call `NSWindow.performDrag(with:)`; otherwise pass the event through normally. This avoids depending solely on background hit-testing while retaining AppKit's native drag loop.
- Supply a closure from `AppDelegate` that evaluates the live lock and click-through settings. This keeps policy in the existing settings layer and avoids duplicated state.
- Retain `isMovableByWindowBackground` as a compatibility fallback for older macOS versions.
- Do not clamp the panel origin after launch or content resizing. The system drag operation determines how close the window can be placed to a screen edge.

## Risks / Trade-offs

- [A future SwiftUI control is added to the clock surface] -> Forward mouse-down events normally when dragging is disabled; revisit hit-testing if interactive clock content is introduced.
- [The explicit path and background fallback both react] -> `performDrag(with:)` consumes the native drag loop from the original mouse-down event, so no manual movement is layered on top.
