---
name: desktopclock-package
description: Build and package the DesktopClock macOS app from this repository. Use when the user asks to package, build a distributable artifact, produce a Release ZIP, or locate the newly built DesktopClock artifact. Do not use for signing or notarization unless the user explicitly requests those operations.
---

# Package DesktopClock

Run the repository-local packaging script from the repository root:

```bash
.codex/skills/desktopclock-package/scripts/package.sh
```

The script performs a Release build without requiring a signing identity, creates a timestamped ZIP under `build/Release`, verifies that the ZIP contains `DesktopClock.app`, and prints the ZIP's absolute path as its final stdout line.

## Required behavior

- Treat the path printed by the script as the authoritative artifact path. Do not report an older ZIP already present in `build/Release`.
- If sandboxing prevents Xcode's Swift macro or plugin processes from running, rerun the same script with the environment's normal approval mechanism instead of changing the build command.
- On success, finish by printing the exact artifact path clearly. Keep any additional summary short.
- On failure, report the first actionable build or packaging error. Do not claim that an artifact was produced.
- Preserve existing build artifacts and source changes. The script creates a timestamped ZIP and uses temporary build state, so it does not need to delete prior packages.
- Do not sign with Developer ID, submit to Apple, staple a ticket, upload, publish, or create a release unless the user explicitly requests that additional action. For notarized distribution, follow `RELEASE_NOTARIZATION.md` and obtain any required authorization or credentials at the point of use.
