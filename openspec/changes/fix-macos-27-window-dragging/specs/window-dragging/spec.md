## ADDED Requirements

### Requirement: Unlocked clock can be dragged
The application SHALL allow the user to reposition the clock by dragging anywhere on its visible content when position lock and mouse click-through are both disabled.

#### Scenario: Drag on macOS 27
- **WHEN** the user presses and drags the visible clock content on macOS 27 while dragging is enabled
- **THEN** the clock window SHALL follow the system window-drag behavior
- **AND** its resulting position SHALL be persisted

#### Scenario: Drag to a screen edge
- **WHEN** the user drags the clock to the top, bottom, left, or right screen edge
- **THEN** the application SHALL NOT force an additional inset between the clock and that edge

### Requirement: Disabled dragging remains disabled
The application MUST NOT begin a window drag when position lock is enabled or mouse click-through is enabled.

#### Scenario: Position is locked
- **WHEN** the user presses the clock content while position lock is enabled
- **THEN** the clock window SHALL remain at its current position

#### Scenario: Mouse click-through is enabled
- **WHEN** mouse click-through is enabled
- **THEN** pointer input SHALL pass through the clock without beginning a window drag
