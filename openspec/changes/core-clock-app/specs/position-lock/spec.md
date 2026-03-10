## ADDED Requirements

### Requirement: Lock and unlock window position
The system SHALL allow users to lock the clock window position, preventing any dragging or repositioning while locked.

#### Scenario: Lock position
- **WHEN** user enables position lock via the menubar control
- **THEN** the clock window SHALL NOT be movable by dragging
- **AND** the window position SHALL be persisted to UserDefaults

#### Scenario: Unlock position
- **WHEN** user disables position lock via the menubar control
- **THEN** the clock window SHALL be movable by dragging (if mouse click-through is also disabled)

#### Scenario: Position restored on app launch
- **WHEN** the application launches
- **AND** a saved window position exists in UserDefaults
- **THEN** the clock window SHALL be placed at the previously saved position

#### Scenario: Default position on first launch
- **WHEN** the application launches for the first time
- **AND** no saved position exists
- **THEN** the clock window SHALL be placed at the top-right corner of the main screen
