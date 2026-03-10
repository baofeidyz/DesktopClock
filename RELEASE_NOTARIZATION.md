# 解决“Apple无法验证 DesktopClock 是否包含恶意软件”

该提示通常出现在 **应用未经过 Apple 公证（Notarization）**，或分发包在签名/公证后被修改。

本项目已在 `Release` 构建中启用 Hardened Runtime（公证要求）。

## 一次性准备

1. Apple Developer 账号（已加入付费开发者计划）
2. Xcode 中可用的 **Developer ID Application** 证书
3. 建议在钥匙串中配置 notarytool profile：

```bash
xcrun notarytool store-credentials "AC_NOTARY" \
  --apple-id "<APPLE_ID>" \
  --team-id "<TEAM_ID>" \
  --password "<APP_SPECIFIC_PASSWORD>"
```

## 构建与签名（Release）

在 Xcode 中 Archive，或使用命令行（示例）：

```bash
xcodebuild \
  -project DesktopClock.xcodeproj \
  -scheme DesktopClock \
  -configuration Release \
  -archivePath build/DesktopClock.xcarchive \
  archive
```

导出 `.app` 后，确认签名：

```bash
codesign --verify --deep --strict --verbose=2 "DesktopClock.app"
spctl --assess --type execute --verbose "DesktopClock.app"
```

## 提交公证

打包并提交：

```bash
ditto -c -k --keepParent "DesktopClock.app" "DesktopClock.zip"
xcrun notarytool submit "DesktopClock.zip" \
  --keychain-profile "AC_NOTARY" \
  --wait
```

## Staple 票据（关键）

```bash
xcrun stapler staple "DesktopClock.app"
spctl --assess --type execute --verbose "DesktopClock.app"
```

## 分发注意事项

- 只能分发 **已公证并 staple 后** 的产物。
- 公证完成后不要再改包内容（改动会破坏签名）。
- 若通过 DMG 分发，也建议对 DMG 做签名并在分发前验证。

完成上述流程后，用户双击打开时一般不会再出现“Apple无法验证”拦截提示。
