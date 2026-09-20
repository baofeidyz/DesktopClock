## Context

The clock currently renders a SwiftUI `Text` inside a transparent, borderless `NSPanel`. The requested appearance is glyph-level glass: desktop content remains visible through the timestamp strokes, while the strokes respond with translucent color, blur, highlights, and edge refraction. A normal SwiftUI `glassEffect` is shape-based and would create glass around the text bounds, so it cannot by itself satisfy the requirement.

The timestamp updates every second, supports user-selected date formats and font sizes, and must continue to work with the existing non-activating window, click-through mode, position lock, and native drag implementation.

## Goals / Non-Goals

**Goals:**

- Render the glass material only inside the timestamp glyph mask.
- Preserve visible background color and optical variation inside the glyphs.
- Add a restrained edge highlight/refraction treatment that follows the glyph contours.
- Use system Liquid Glass APIs when available and provide a graceful visual fallback on older macOS versions or when transparency is reduced.
- Keep text updates, format changes, font-size changes, dragging, and click-through behavior functional.

**Non-Goals:**

- Adding a large standalone panel or unrelated background behind the timestamp; the native capsule remains tightly fitted to the content.
- Replacing the existing clock window or interaction model.
- Capturing the desktop or introducing a third-party rendering dependency.

## Decisions

- **Use a glyph-mask rendering bridge.** Keep the timestamp as the source of truth for layout and accessibility, but render its glyph alpha into a mask used by a custom glass view. This is necessary because `glassEffect` accepts a geometric `Shape`, not an arbitrary text-glyph mask.
- **Prefer AppKit glass at the rendering boundary.** On Liquid Glass-capable macOS versions, embed the glass material in an AppKit-backed representable and apply the timestamp mask to the rendered content. AppKit is used here because the clock already crosses into AppKit through `NSHostingView` and `NSPanel`, and `NSGlassEffectView` exposes dynamic glass behavior on macOS.
- **Separate material and contour layers.** The masked material layer provides transparency, background color pickup, blur, and refraction; a separate glyph-contour layer supplies only a low-opacity edge highlight. No drop shadow is used, keeping the treatment aligned to the actual digit contours instead of the enclosing text rectangle.
- **Keep one rendered timestamp, not one glass view per character.** Render the complete formatted string into one mask so colons, spaces, and changing digits do not create excessive glass containers or unstable morphing. This also limits per-frame rendering cost.
- **Respect system accessibility settings.** When Reduce Transparency or Increase Contrast is active, use a more opaque, high-contrast fallback while preserving the same glyph geometry. Do not force transparency when the system asks for reduced effects.
- **Prefer the native Liquid Glass renderer.** On macOS 26+/27, use SwiftUI's `glassEffect` directly on the timestamp view so the system owns material thickness, lighting, and background response. Do not capture the desktop or synthesize a lens effect in application code.
- **Do not override system appearance.** Leave the native glass untinted and use the system primary foreground so Light/Dark/Automatic appearance and the user's Liquid Glass settings remain authoritative.
- **Keep the timestamp optically substantial.** Use a semibold monospaced font so the native glass material has enough interior area to remain visible.
- **Keep the timestamp optically substantial.** Use a semibold monospaced font so the glass and refractive displacement have enough interior area to remain visible.
- **Use the native numeric content transition.** Bind a short smooth animation to the formatted timestamp value and use an increasing `numericText` transition so changing digits roll without applying a global animation to window or settings state.

## Risks / Trade-offs

- [The AppKit glass view cannot be masked to glyph contours without losing its background sampling] -> Keep the AppKit glass view unmasked inside a glyph-masked container so the glass renderer retains its sampling pass while the container clips output to the glyph shape.
- [Per-second text changes cause mask and glass re-rendering] -> Reuse the rendering view, update only the text mask when the formatted string or font changes, and avoid per-character glass containers.
- [Clear glass reduces timestamp readability over bright or detailed desktops] -> Default to a restrained regular-like treatment, add adaptive contrast, and honor Increase Contrast/Reduce Transparency settings.
- [The native glass API is unavailable] -> Keep the same timestamp layout and use ordinary semibold text without screen-capture dependencies.
- [The custom view could interfere with the existing mouse-drag host view] -> Keep the glass renderer non-interactive and preserve the outer `DraggableHostingView` as the event owner.

## Migration Plan

1. Add the new timestamp renderer behind the existing `ClockView` API without changing settings storage or window position data.
2. Prototype the glyph mask and glass sampling on the target macOS version.
3. Add the fallback and accessibility branches, then compare text-format and font-size changes.
4. Verify drag, click-through, position lock, and timestamp readability before enabling the new renderer as the default.
5. Roll back by selecting the existing plain `Text` rendering path; no persisted-data migration is required.

## Open Questions

- Does the target macOS SDK expose enough control for `NSGlassEffectView` to preserve true background sampling after a non-rectangular glyph mask?
- Should the edge highlight be fully system-provided, or should the fallback contour layer remain visible on all systems for consistent readability?
- What is the minimum font size at which the refractive edge remains legible instead of making the digits look blurry?
