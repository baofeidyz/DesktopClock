## 1. Project Setup

- [x] 1.1 Create Xcode project with SwiftUI App lifecycle, target macOS 15+, bundle ID and app name configured
- [x] 1.2 Configure Info.plist with LSUIElement = true (no Dock icon) and required app metadata
- [x] 1.3 Set up App Sandbox entitlements

## 2. Clock Window (NSPanel)

- [x] 2.1 Create FloatingPanel subclass of NSPanel with `.nonactivatingPanel` style mask, `.statusBar` level, and transparent background
- [x] 2.2 Configure panel collection behavior: `canJoinAllSpaces` and `fullScreenAuxiliary`
- [x] 2.3 Create NSHostingView bridge to embed SwiftUI clock view inside the panel
- [x] 2.4 Implement AppDelegate to create and manage the floating panel on app launch

## 3. Clock Display (SwiftUI)

- [x] 3.1 Create ClockView using SwiftUI Text with Timer-driven updates every second
- [x] 3.2 Create ClockSettings ObservableObject with @AppStorage for format string, position, lock state, and click-through state
- [x] 3.3 Wire ClockView to read format from ClockSettings and display formatted time using DateFormatter

## 4. Mouse Click-Through

- [x] 4.1 Implement `ignoresMouseEvents` toggle on the panel, controlled by ClockSettings
- [x] 4.2 Set click-through enabled by default on first launch
- [x] 4.3 Observe ClockSettings changes to update `ignoresMouseEvents` in real-time

## 5. Position Lock

- [x] 5.1 Implement window dragging via `isMovableByWindowBackground` toggle, controlled by lock state
- [x] 5.2 Persist window position (x, y) to UserDefaults when window is moved
- [x] 5.3 Restore saved position on launch, default to top-right corner of main screen if no saved position

## 6. Custom Time Format

- [x] 6.1 Implement DateFormatter with configurable format string from ClockSettings
- [x] 6.2 Add preset formats: `HH:mm:ss`, `HH:mm`, `hh:mm:ss a`, `yyyy-MM-dd HH:mm:ss`, `MM/dd HH:mm`
- [x] 6.3 Add fallback to default format `HH:mm:ss` for invalid format strings
- [x] 6.4 Persist selected format to UserDefaults via @AppStorage

## 7. Menubar Control (NSStatusItem)

- [x] 7.1 Create StatusBarController with NSStatusItem and clock system image icon
- [x] 7.2 Build dropdown menu with toggle items: click-through (with checkmark), position lock (with checkmark)
- [x] 7.3 Add time format submenu with preset options and custom input field
- [x] 7.4 Add separator and Quit item
- [x] 7.5 Wire all menu actions to update ClockSettings, which drives panel behavior updates

## 8. Integration and Polish

- [x] 8.1 Connect all components in AppDelegate: create panel, status bar controller, and clock settings
- [x] 8.2 Ensure state consistency: toggling click-through also considers position lock state for dragging
- [x] 8.3 Test window behavior across Spaces, full-screen apps, and multiple displays
