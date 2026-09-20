#!/bin/bash

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
output_dir="$repo_root/build/Release"
timestamp="$(date '+%Y%m%d-%H%M%S')"
artifact_path="$output_dir/DesktopClock-macOS-$timestamp.zip"
work_dir="$(mktemp -d "${TMPDIR:-/tmp}/desktopclock-package.XXXXXX")"
derived_data="$work_dir/DerivedData"
build_log="$work_dir/xcodebuild.log"
zip_listing="$work_dir/zip-listing.txt"

cleanup() {
    rm -rf "$work_dir"
}
trap cleanup EXIT

mkdir -p "$output_dir"

if ! xcodebuild \
    -project "$repo_root/DesktopClock.xcodeproj" \
    -scheme DesktopClock \
    -configuration Release \
    -derivedDataPath "$derived_data" \
    CODE_SIGNING_ALLOWED=NO \
    build >"$build_log" 2>&1; then
    cat "$build_log" >&2
    exit 1
fi

app_path="$derived_data/Build/Products/Release/DesktopClock.app"
if [[ ! -d "$app_path" ]]; then
    echo "Expected build product not found: $app_path" >&2
    exit 1
fi

COPYFILE_DISABLE=1 ditto -c -k --keepParent "$app_path" "$artifact_path"

unzip -Z1 "$artifact_path" >"$zip_listing"
if ! grep -Fxq 'DesktopClock.app/Contents/MacOS/DesktopClock' "$zip_listing"; then
    echo "Packaged ZIP does not contain the DesktopClock executable: $artifact_path" >&2
    exit 1
fi

printf '%s\n' "$artifact_path"
