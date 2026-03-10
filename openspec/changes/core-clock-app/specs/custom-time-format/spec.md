## ADDED Requirements

### Requirement: Custom time display format
The system SHALL allow users to customize the time display format using standard DateFormatter format strings (Unicode Technical Standard #35).

#### Scenario: Default time format
- **WHEN** the application launches for the first time
- **THEN** the clock SHALL display time using the default format `HH:mm:ss`

#### Scenario: User sets custom format
- **WHEN** user enters a custom format string (e.g., `yyyy-MM-dd HH:mm:ss`) via the menubar settings
- **THEN** the clock SHALL immediately display time using the new format

#### Scenario: Preset format options
- **WHEN** user opens the format settings in the menubar
- **THEN** the system SHALL provide preset format options including:
  - `HH:mm:ss` (24-hour with seconds)
  - `HH:mm` (24-hour without seconds)
  - `hh:mm:ss a` (12-hour with AM/PM)
  - `yyyy-MM-dd HH:mm:ss` (full date and time)
  - `MM/dd HH:mm` (month/day with time)

#### Scenario: Invalid format string
- **WHEN** user enters an invalid or empty format string
- **THEN** the system SHALL fall back to the default format `HH:mm:ss`

#### Scenario: Format persisted across launches
- **WHEN** user sets a custom format
- **AND** restarts the application
- **THEN** the clock SHALL display using the previously set custom format
