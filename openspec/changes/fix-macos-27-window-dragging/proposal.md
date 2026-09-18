## Why

After upgrading to macOS 27, relying only on `NSWindow.isMovableByWindowBackground` no longer makes the borderless SwiftUI clock reliably draggable. Users need to be able to reposition the clock whenever position lock and mouse click-through are disabled.

## What Changes

- Add an explicit AppKit mouse-drag path for the SwiftUI-hosted clock content.
- Preserve the existing position-lock and click-through behavior.
- Keep saving the window position after a successful drag.

## Capabilities

### New Capabilities
- `window-dragging`: Defines reliable pointer dragging of the borderless clock window on supported macOS versions, including macOS 27.

### Modified Capabilities

None.

## Impact

- Affects the AppKit/SwiftUI hosting boundary and window construction in `AppDelegate.swift`.
- Adds a small hosting-view type; no new external dependencies or data migrations.
