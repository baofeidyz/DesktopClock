## Why

macOS缺少一个轻量级、可自定义的桌面时钟应用。用户需要在工作时随时查看时间，但不想被额外的窗口干扰。需要一个始终悬浮在所有窗口之上、支持鼠标穿透、可锁定位置且支持自定义时间格式的桌面时钟应用，基于macOS 15开发。

## What Changes

- 创建全新的macOS桌面时钟应用（SwiftUI + AppKit混合架构）
- 实现窗口始终置顶（Level above all windows）
- 实现鼠标事件穿透（ignoresMouseEvents）
- 实现窗口位置锁定/解锁
- 实现自定义时间格式（基于DateFormatter format string）
- 提供菜单栏图标进行设置控制（因为鼠标穿透时无法直接交互）
- 使用UserDefaults持久化用户偏好设置

## Capabilities

### New Capabilities
- `always-on-top-window`: 时钟窗口始终显示在所有窗口和应用之上，包括全屏应用
- `mouse-click-through`: 鼠标事件穿透时钟窗口，不干扰底层应用的操作
- `position-lock`: 锁定/解锁时钟窗口位置，锁定后无法拖动
- `custom-time-format`: 支持程序员常用的date format字符串自定义时间显示格式
- `menubar-control`: 通过菜单栏图标提供设置入口，控制所有功能开关和配置

### Modified Capabilities

（无，这是全新项目）

## Impact

- 新建Xcode项目，目标平台macOS 15+
- 使用SwiftUI构建UI，AppKit处理窗口行为（NSWindow/NSPanel）
- 依赖系统框架：SwiftUI、AppKit、Foundation
- 无第三方依赖
- 需要配置App Sandbox和相关entitlements
