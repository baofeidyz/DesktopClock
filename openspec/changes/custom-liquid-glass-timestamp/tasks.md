## 1. Rendering Spike

- [ ] 1.1 Prototype a macOS Liquid Glass-backed renderer and verify whether system background sampling survives a glyph-shaped mask
- [ ] 1.2 Choose the runtime-availability and older-macOS fallback path based on the prototype result
- [x] 1.3 Confirm that system glass alone provides blur but not reliable glyph-level background displacement

## 2. Glyph-Level Glass Renderer

- [x] 2.1 Add a reusable timestamp glyph-mask renderer driven by the existing formatted string, font, and size
- [x] 2.2 Render translucent glass material only inside the glyph mask
- [x] 2.3 Add contour-aligned edge highlight and refraction layers without drawing an enclosing text-view border
- [x] 2.4 Reuse renderer state and update mask geometry only when the timestamp, format, or font size changes
- [x] 2.5 Replace the failed screen-capture renderer with the native SwiftUI Liquid Glass view

## 3. Accessibility and Integration

- [x] 3.1 Add adaptive contrast and Reduce Transparency/Increase Contrast fallbacks
- [x] 3.2 Preserve clock dragging, click-through, position locking, saved position, and all existing time formats
- [ ] 3.3 Verify small and large font sizes, long date formats, light/dark appearances, and visually complex desktop backgrounds
- [x] 3.4 Remove the failed screen-capture renderer and its permission dependency

## 4. Verification

- [x] 4.1 Build the macOS application with the current deployment target and the Liquid Glass-capable SDK
- [x] 4.2 Validate the OpenSpec change, review the renderer output paths, and run `git diff --check`
