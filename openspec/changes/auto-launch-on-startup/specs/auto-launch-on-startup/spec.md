## ADDED Requirements

### Requirement: User can enable or disable launch at login
The system SHALL provide a user-facing setting to enable or disable launching the app at login, and the setting SHALL persist across app restarts and system reboots.

#### Scenario: Enable launch at login
- **WHEN** the user turns on the launch-at-login setting
- **THEN** the system enables the app in macOS Login Items

#### Scenario: Disable launch at login
- **WHEN** the user turns off the launch-at-login setting
- **THEN** the system removes the app from macOS Login Items

### Requirement: Setting reflects actual system login item state
The system SHALL ensure the launch-at-login setting reflects the current macOS Login Items state on app startup and after any failed enable/disable attempt.

#### Scenario: App startup sync
- **WHEN** the app starts
- **THEN** the launch-at-login setting matches the current macOS Login Items state for the app

#### Scenario: Failure to update login items
- **WHEN** enabling or disabling the login item fails
- **THEN** the setting reverts to the actual macOS Login Items state
