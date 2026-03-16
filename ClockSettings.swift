import SwiftUI

@MainActor
final class ClockSettings: ObservableObject {
    static let shared = ClockSettings()

    @AppStorage("timeFormat") var timeFormat: String = "HH:mm:ss"
    @AppStorage("windowPositionX") var windowPositionX: Double = -1
    @AppStorage("windowPositionY") var windowPositionY: Double = -1
    @AppStorage("isPositionLocked") var isPositionLocked: Bool = false
    @AppStorage("isClickThroughEnabled") var isClickThroughEnabled: Bool = true
    @AppStorage("launchAtLogin") var launchAtLogin: Bool = false
    @AppStorage("fontSize") var fontSize: Double = 24

    @AppStorage("textColorRed") var textColorRed: Double = 1.0
    @AppStorage("textColorGreen") var textColorGreen: Double = 1.0
    @AppStorage("textColorBlue") var textColorBlue: Double = 1.0

    var textColor: Color {
        Color(red: textColorRed, green: textColorGreen, blue: textColorBlue)
    }

    var nsTextColor: NSColor {
        NSColor(red: textColorRed, green: textColorGreen, blue: textColorBlue, alpha: 1.0)
    }

    func setTextColor(red: Double, green: Double, blue: Double) {
        textColorRed = max(0, min(1, red))
        textColorGreen = max(0, min(1, green))
        textColorBlue = max(0, min(1, blue))
    }

    static let presetFormats: [(label: String, format: String)] = [
        ("24小时（含秒）", "HH:mm:ss"),
        ("24小时", "HH:mm"),
        ("12小时（含秒）", "hh:mm:ss a"),
        ("完整日期时间", "yyyy-MM-dd HH:mm:ss"),
        ("月/日 时间", "MM/dd HH:mm"),
    ]

    static let defaultFormat = "HH:mm:ss"

    func validatedFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = timeFormat
        let result = formatter.string(from: Date())
        if result.isEmpty || timeFormat.trimmingCharacters(in: .whitespaces).isEmpty {
            return ClockSettings.defaultFormat
        }
        return timeFormat
    }
}
