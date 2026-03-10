## ADDED Requirements

### Requirement: Menubar icon and control menu
The system SHALL provide a menubar status item (NSStatusItem) with a clock icon that serves as the primary control interface for all clock settings.

#### Scenario: Menubar icon displayed on launch
- **WHEN** the application launches
- **THEN** a clock icon SHALL appear in the macOS menubar

#### Scenario: Menubar menu shows all controls
- **WHEN** user clicks the menubar icon
- **THEN** a dropdown menu SHALL appear with the following items:
  - Toggle mouse click-through (with current state indicator)
  - Toggle position lock (with current state indicator)
  - Time format submenu (presets + custom input)
  - Separator
  - Quit application

#### Scenario: Toggle click-through from menu
- **WHEN** user clicks the mouse click-through toggle in the menu
- **THEN** the click-through state SHALL be toggled immediately
- **AND** the menu item SHALL reflect the new state

#### Scenario: Toggle position lock from menu
- **WHEN** user clicks the position lock toggle in the menu
- **THEN** the position lock state SHALL be toggled immediately
- **AND** the menu item SHALL reflect the new state

#### Scenario: Application has no Dock icon
- **WHEN** the application is running
- **THEN** the application SHALL NOT show an icon in the Dock (LSUIElement = true)
