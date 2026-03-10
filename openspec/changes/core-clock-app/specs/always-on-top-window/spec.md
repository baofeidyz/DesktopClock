## ADDED Requirements

### Requirement: Clock window stays above all other windows
The system SHALL display the clock window at a level above all other application windows, including Finder and system windows. The window SHALL use NSPanel with `.statusBar` level to ensure visibility.

#### Scenario: Clock visible over normal applications
- **WHEN** user opens any application window
- **THEN** the clock window SHALL remain visible above the application window

#### Scenario: Clock visible over full-screen applications
- **WHEN** user enters full-screen mode in any application
- **THEN** the clock window SHALL remain visible using `fullScreenAuxiliary` collection behavior

#### Scenario: Clock visible across all Spaces
- **WHEN** user switches between macOS Spaces (virtual desktops)
- **THEN** the clock window SHALL appear on every Space using `canJoinAllSpaces` collection behavior

#### Scenario: Clock window does not steal focus
- **WHEN** user is typing or interacting with another application
- **THEN** the clock window SHALL NOT activate or steal keyboard focus
