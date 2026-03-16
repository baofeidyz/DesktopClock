import AppKit
import ServiceManagement

enum LoginItemManager {
    enum LoginItemError: LocalizedError {
        case unsupported

        var errorDescription: String? {
            "当前系统不支持开机自启动设置（需要 macOS 13 或更高）。"
        }
    }

    static var isSupported: Bool {
        if #available(macOS 13.0, *) {
            return true
        }
        return false
    }

    @MainActor
    static func currentStatus() -> Bool {
        guard isSupported else { return false }
        if #available(macOS 13.0, *) {
            return SMAppService.mainApp.status == .enabled
        }
        return false
    }

    @MainActor
    static func setEnabled(_ enabled: Bool) throws {
        guard isSupported else { throw LoginItemError.unsupported }
        if #available(macOS 13.0, *) {
            let service = SMAppService.mainApp
            if enabled {
                if service.status != .enabled {
                    try service.register()
                }
            } else {
                if service.status == .enabled {
                    try service.unregister()
                }
            }
        }
    }
}
