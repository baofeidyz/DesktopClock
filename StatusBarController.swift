import AppKit
import SwiftUI

@MainActor
final class StatusBarController: NSObject {
    private var statusItem: NSStatusItem
    private let settings: ClockSettings

    init(settings: ClockSettings) {
        self.settings = settings
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        super.init()

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "clock", accessibilityDescription: "Desktop Clock")
        }

        buildMenu()
    }

    private func buildMenu() {
        let menu = NSMenu()

        // Click-through toggle
        let clickThroughItem = NSMenuItem(
            title: "鼠标穿透",
            action: #selector(toggleClickThrough),
            keyEquivalent: ""
        )
        clickThroughItem.target = self
        clickThroughItem.state = settings.isClickThroughEnabled ? .on : .off
        menu.addItem(clickThroughItem)

        // Position lock toggle
        let lockItem = NSMenuItem(
            title: "锁定位置",
            action: #selector(togglePositionLock),
            keyEquivalent: ""
        )
        lockItem.target = self
        lockItem.state = settings.isPositionLocked ? .on : .off
        menu.addItem(lockItem)

        menu.addItem(NSMenuItem.separator())

        // Time format submenu
        let formatSubmenu = NSMenu()
        for preset in ClockSettings.presetFormats {
            let item = NSMenuItem(
                title: "\(preset.label)  (\(preset.format))",
                action: #selector(selectPresetFormat(_:)),
                keyEquivalent: ""
            )
            item.target = self
            item.representedObject = preset.format
            if settings.timeFormat == preset.format {
                item.state = .on
            }
            formatSubmenu.addItem(item)
        }

        formatSubmenu.addItem(NSMenuItem.separator())

        let customItem = NSMenuItem(
            title: "自定义格式...",
            action: #selector(showCustomFormatInput),
            keyEquivalent: ""
        )
        customItem.target = self
        formatSubmenu.addItem(customItem)

        let formatMenuItem = NSMenuItem(title: "时间格式", action: nil, keyEquivalent: "")
        formatMenuItem.submenu = formatSubmenu
        menu.addItem(formatMenuItem)

        // Text color
        let colorItem = NSMenuItem(
            title: "文字颜色...",
            action: #selector(showColorPicker),
            keyEquivalent: ""
        )
        colorItem.target = self
        menu.addItem(colorItem)

        menu.addItem(NSMenuItem.separator())

        // Quit
        let quitItem = NSMenuItem(
            title: "退出",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    @objc private func toggleClickThrough() {
        settings.isClickThroughEnabled.toggle()
        buildMenu()
    }

    @objc private func togglePositionLock() {
        settings.isPositionLocked.toggle()
        buildMenu()
    }

    @objc private func selectPresetFormat(_ sender: NSMenuItem) {
        if let format = sender.representedObject as? String {
            settings.timeFormat = format
            buildMenu()
        }
    }

    @objc private func showCustomFormatInput() {
        let alert = NSAlert()
        alert.messageText = "自定义时间格式"
        alert.informativeText = "输入DateFormatter格式字符串，例如：yyyy-MM-dd HH:mm:ss"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "确定")
        alert.addButton(withTitle: "取消")

        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        textField.stringValue = settings.timeFormat
        textField.placeholderString = "HH:mm:ss"
        alert.accessoryView = textField

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            let input = textField.stringValue.trimmingCharacters(in: .whitespaces)
            if input.isEmpty {
                settings.timeFormat = ClockSettings.defaultFormat
            } else {
                settings.timeFormat = input
            }
            buildMenu()
        }
    }

    @objc private func showColorPicker() {
        NSApp.activate(ignoringOtherApps: true)

        let colorPanel = NSColorPanel.shared
        colorPanel.color = settings.nsTextColor
        colorPanel.mode = .wheel
        colorPanel.showsAlpha = false
        colorPanel.setTarget(self)
        colorPanel.setAction(#selector(colorDidChange(_:)))

        // Add RGB input accessory view
        let accessory = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 30))

        let rLabel = NSTextField(labelWithString: "R:")
        rLabel.frame = NSRect(x: 0, y: 4, width: 16, height: 22)
        let rField = NSTextField(frame: NSRect(x: 16, y: 2, width: 45, height: 22))
        rField.intValue = Int32(settings.textColorRed * 255)
        rField.tag = 1

        let gLabel = NSTextField(labelWithString: "G:")
        gLabel.frame = NSRect(x: 68, y: 4, width: 16, height: 22)
        let gField = NSTextField(frame: NSRect(x: 84, y: 2, width: 45, height: 22))
        gField.intValue = Int32(settings.textColorGreen * 255)
        gField.tag = 2

        let bLabel = NSTextField(labelWithString: "B:")
        bLabel.frame = NSRect(x: 136, y: 4, width: 16, height: 22)
        let bField = NSTextField(frame: NSRect(x: 152, y: 2, width: 45, height: 22))
        bField.intValue = Int32(settings.textColorBlue * 255)
        bField.tag = 3

        for field in [rField, gField, bField] {
            field.delegate = self
            field.placeholderString = "0-255"
        }

        accessory.addSubview(rLabel)
        accessory.addSubview(rField)
        accessory.addSubview(gLabel)
        accessory.addSubview(gField)
        accessory.addSubview(bLabel)
        accessory.addSubview(bField)

        colorPanel.accessoryView = accessory
        colorPanel.makeKeyAndOrderFront(nil)
    }

    @objc private func colorDidChange(_ sender: NSColorPanel) {
        guard let rgb = sender.color.usingColorSpace(.sRGB) else { return }
        settings.setTextColor(
            red: Double(rgb.redComponent),
            green: Double(rgb.greenComponent),
            blue: Double(rgb.blueComponent)
        )
        // Update RGB fields in accessory
        if let accessory = sender.accessoryView {
            for subview in accessory.subviews {
                if let field = subview as? NSTextField {
                    switch field.tag {
                    case 1: field.intValue = Int32(rgb.redComponent * 255)
                    case 2: field.intValue = Int32(rgb.greenComponent * 255)
                    case 3: field.intValue = Int32(rgb.blueComponent * 255)
                    default: break
                    }
                }
            }
        }
    }
}

extension StatusBarController: NSTextFieldDelegate {
    func controlTextDidEndEditing(_ obj: Notification) {
        guard let field = obj.object as? NSTextField, field.tag >= 1, field.tag <= 3 else { return }
        let value = max(0, min(255, field.integerValue))
        field.intValue = Int32(value)
        let component = Double(value) / 255.0
        switch field.tag {
        case 1: settings.textColorRed = component
        case 2: settings.textColorGreen = component
        case 3: settings.textColorBlue = component
        default: break
        }
        // Sync the color panel
        NSColorPanel.shared.color = settings.nsTextColor
    }
}
