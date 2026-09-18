## Why

The clock currently renders the timestamp as ordinary text with a shadow. The desired macOS 27 presentation is for the timestamp glyphs themselves to behave like transparent Liquid Glass: the desktop should remain visible through each digit while the digit edges provide subtle optical highlights and refraction.

## What Changes

- Replace the plain timestamp appearance with a custom glyph-level glass rendering treatment.
- Use a compact capsule-shaped native glass surface around the timestamp, with internal spacing so the digits do not touch the curved edge.
- Add adaptive contrast and accessibility fallbacks so the timestamp remains readable when transparency is reduced, contrast is increased, or the background is visually complex.
- Preserve the existing time formats, font-size setting, window dragging, click-through, position locking, and saved position behavior.

## Capabilities

### New Capabilities
- `custom-liquid-glass-timestamp`: Defines the transparent, refractive, glyph-level Liquid Glass appearance of the clock timestamp and its accessibility/degradation behavior.

### Modified Capabilities

None.

## Impact

- Affects the SwiftUI timestamp rendering in `ClockView.swift` and may add a custom rendering view or AppKit/SwiftUI bridge for glyph masking and edge highlights.
- Requires availability handling for macOS versions that do not provide the current Liquid Glass APIs.
- Uses the macOS 26+/27 native SwiftUI Liquid Glass renderer and does not require Screen Recording permission.
