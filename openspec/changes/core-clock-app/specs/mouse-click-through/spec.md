## ADDED Requirements

### Requirement: Mouse events pass through clock window
The system SHALL support a mouse click-through mode where all mouse events (clicks, scrolls, drags) pass through the clock window to the underlying application.

#### Scenario: Click-through enabled by default
- **WHEN** the application launches for the first time
- **THEN** mouse click-through SHALL be enabled by default

#### Scenario: Mouse clicks pass through to underlying window
- **WHEN** mouse click-through is enabled
- **AND** user clicks on the area covered by the clock window
- **THEN** the click event SHALL be received by the application window beneath the clock

#### Scenario: Mouse scroll passes through
- **WHEN** mouse click-through is enabled
- **AND** user scrolls on the area covered by the clock window
- **THEN** the scroll event SHALL be received by the application window beneath the clock

#### Scenario: Disable click-through for interaction
- **WHEN** user disables mouse click-through via the menubar control
- **THEN** the clock window SHALL receive mouse events normally, allowing dragging and interaction
