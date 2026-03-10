## Context

这是一个全新的macOS桌面时钟应用。当前没有现有代码，需要从零开始构建。目标平台为macOS 15+，使用SwiftUI构建UI层，AppKit处理窗口级别行为。

核心挑战在于：SwiftUI本身不直接提供窗口级别控制（如置顶、鼠标穿透），需要通过AppKit的NSWindow/NSPanel桥接来实现。同时，鼠标穿透模式下用户无法直接与时钟窗口交互，因此需要菜单栏图标作为控制入口。

## Goals / Non-Goals

**Goals:**
- 提供一个始终可见的悬浮时钟窗口
- 时钟不干扰用户对其他应用的操作（鼠标穿透）
- 用户可自定义时间显示格式
- 用户可锁定时钟位置防止意外拖动
- 通过菜单栏提供所有设置和控制
- 使用UserDefaults持久化设置

**Non-Goals:**
- 不支持多时钟实例
- 不支持闹钟/计时器功能
- 不支持跨显示器同步
- 不支持macOS 15以下版本
- 不支持App Store分发（初期）

## Decisions

### 1. 使用NSPanel替代NSWindow

**选择**: 使用NSPanel（FloatingPanel）作为时钟窗口容器

**原因**: NSPanel是NSWindow的子类，原生支持`.nonactivatingPanel` style mask，不会在切换时夺取焦点。设置`panel.level = .statusBar`即可实现置顶，且比NSWindow更适合工具类悬浮窗口。

**替代方案**: 直接使用NSWindow + `.floating` level。缺点是需要额外处理焦点问题，NSPanel已内建这些行为。

### 2. SwiftUI + NSHostingView混合架构

**选择**: 使用SwiftUI编写时钟UI和设置界面，通过NSHostingView嵌入NSPanel

**原因**: SwiftUI提供声明式UI和响应式数据绑定（@AppStorage），非常适合时钟显示和设置界面。但窗口行为（置顶、穿透、拖动）需要AppKit级别控制。

**替代方案**: 纯AppKit。缺点是UI编写繁琐，数据绑定需要大量样板代码。

### 3. 鼠标穿透与交互模式切换

**选择**: 通过`window.ignoresMouseEvents`控制穿透，菜单栏提供开关

**原因**: `ignoresMouseEvents = true`时所有鼠标事件直接传递给底层窗口，实现完全穿透。用户通过菜单栏切换此状态来进行位置调整。

**替代方案**: 使用透明overlay + hitTest重写。更复杂且不够可靠。

### 4. 菜单栏控制中心（NSStatusItem）

**选择**: 使用NSStatusItem在菜单栏显示图标，提供下拉菜单控制所有功能

**原因**: 鼠标穿透模式下无法直接点击时钟窗口，菜单栏是macOS原生且最自然的控制入口。

### 5. 持久化方案使用@AppStorage

**选择**: 使用SwiftUI的@AppStorage（底层为UserDefaults）存储设置

**原因**: 设置项少且简单（格式字符串、位置坐标、开关状态），无需Core Data或文件存储。@AppStorage与SwiftUI天然集成，变化自动驱动UI更新。

## Risks / Trade-offs

- **[鼠标穿透时无法拖动]** → 用户需通过菜单栏先关闭穿透，拖动后再开启。菜单栏提供清晰的切换入口。
- **[NSPanel在全屏应用上的表现]** → `.statusBar` level可能在某些全屏模式下不可见。可通过设置`panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]`解决。
- **[自定义格式字符串输入错误]** → 提供几个预设格式供选择，同时允许自定义输入。实时预览格式效果。
- **[App Sandbox限制]** → 此应用不需要特殊权限（网络、文件系统），Sandbox不会造成限制。
