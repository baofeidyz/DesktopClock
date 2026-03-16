## Why

当前应用缺少“开机自启”的能力，用户希望在系统启动后自动打开时钟应用，省去每次手动启动的步骤。

## What Changes

- 在设置中新增“开机自启动”选项（勾选启用，取消勾选关闭）。
- 在应用启动/设置变更时，同步系统登录项（Login Items）以实现自启。
- 允许用户随时开关该选项，且状态在重启后保持一致。

## Capabilities

### New Capabilities
- `auto-launch-on-startup`: 提供开机自启动的开关，并与系统登录项保持一致。

### Modified Capabilities
- 

## Impact

- 影响设置管理与应用启动流程。
- 可能涉及 macOS 登录项/后台启动权限相关的系统 API。
- 需要更新 UI 设置页与持久化配置。
