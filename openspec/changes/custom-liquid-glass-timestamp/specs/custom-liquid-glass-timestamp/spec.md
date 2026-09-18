## ADDED Requirements

### Requirement: Timestamp glyphs render as transparent glass
The timestamp SHALL render as a compact, transparent native Liquid Glass capsule sized to the formatted timestamp. The desktop behind the window SHALL remain visible through the clear glass surface.

#### Scenario: Glass is confined to glyphs
- **WHEN** the clock is displayed with any supported time format
- **THEN** glass translucency SHALL be visible inside the digit and separator strokes
- **AND** the capsule SHALL remain tightly fitted to the timestamp rather than becoming a large independent panel

#### Scenario: Background colors influence the glyphs
- **WHEN** a colorful or high-contrast desktop region is positioned behind the timestamp
- **THEN** the visible colors inside the glyphs SHALL respond to that background through the glass material

### Requirement: Glyph edges provide optical depth
The timestamp SHALL provide a restrained contour highlight and refraction treatment that follows the actual glyph boundaries, rather than the bounds of the text view.

#### Scenario: Edge highlight follows digit contours
- **WHEN** the timestamp is rendered at a supported font size
- **THEN** highlights and darker refraction edges SHALL align with the outlines of the digits and separators
- **AND** the effect SHALL NOT draw an additional border inside or outside the native capsule

### Requirement: Appearance updates with the timestamp
The glass mask and contour layers SHALL remain synchronized with the current formatted timestamp, selected format, and configured font size.

#### Scenario: Seconds change
- **WHEN** the displayed second changes
- **THEN** the glyph mask and glass rendering SHALL update to the new characters without leaving stale glass pixels

#### Scenario: Format or font size changes
- **WHEN** the user changes the time format or font size
- **THEN** the renderer SHALL rebuild its glyph geometry and preserve the glass-only-inside-glyphs rule

### Requirement: Glass remains readable and accessible
The timestamp SHALL remain legible over ordinary desktop backgrounds and SHALL respect system settings that reduce transparency or increase contrast.

#### Scenario: Complex or bright background
- **WHEN** the desktop behind the timestamp is bright, detailed, or similar in color to the glass highlights
- **THEN** the renderer SHALL apply enough adaptive contrast or opacity for the timestamp to remain readable

#### Scenario: Reduced transparency or increased contrast
- **WHEN** the system enables Reduce Transparency or Increase Contrast
- **THEN** the timestamp SHALL use the supported opaque/high-contrast fallback while keeping the same glyph layout and time content

### Requirement: Renderer degrades on unsupported systems
The application SHALL use a deterministic clipped-material fallback when the target system does not expose the required Liquid Glass APIs.

#### Scenario: Older macOS runtime
- **WHEN** the application runs on a macOS version without the required Liquid Glass rendering API
- **THEN** the timestamp SHALL remain visible using a standard material, gradient, or contour treatment clipped to the glyph mask
- **AND** the application SHALL not crash or display a glass background outside the glyphs

### Requirement: Native Liquid Glass is preferred
On macOS versions that expose SwiftUI Liquid Glass, the timestamp SHALL use the native `glassEffect` renderer and SHALL NOT request or depend on Screen Recording permission.

#### Scenario: Native renderer is available
- **WHEN** the timestamp runs on macOS 26 or newer
- **THEN** the system SHALL own the glass material, lighting, thickness, and background response
- **AND** the timestamp update SHALL not recreate or recapture the desktop

#### Scenario: Native renderer is unavailable
- **WHEN** the timestamp runs on an older macOS version
- **THEN** the timestamp SHALL remain visible using semibold text and the existing layout and interaction behavior

### Requirement: Rendering stays bounded
The timestamp renderer SHALL reuse its rendering view and update only the geometry and mask data needed for changed text, format, or font size.

#### Scenario: Continuous clock updates
- **WHEN** the clock runs continuously for at least one minute
- **THEN** rendering work SHALL remain bounded to the current timestamp and SHALL NOT create a new glass container for every character or second
