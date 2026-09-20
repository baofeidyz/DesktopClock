import Combine
import SwiftUI

struct ClockView: View {
    @ObservedObject var settings: ClockSettings
    @State private var currentTime = Date()

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        timestampView
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .onReceive(timer) { time in
                currentTime = time
            }
    }

    @ViewBuilder
    private var timestampView: some View {
        if #available(macOS 26.0, *) {
            if settings.isLiquidGlassEnabled {
                Text(formattedTime)
                    .font(.system(size: CGFloat(settings.fontSize), weight: .semibold, design: .monospaced))
                    .foregroundStyle(settings.textColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .allowsTightening(true)
                    // Keep the text optically centered inside the bezel. Apple recommends
                    // about 12 points of padding around bezel-style controls.
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .glassEffect(.regular.interactive(), in: .capsule)
                    .contentTransition(.numericText(countsDown: false))
                    .animation(.smooth(duration: 0.35), value: formattedTime)
            } else {
                Text(formattedTime)
                    .font(.system(size: CGFloat(settings.fontSize), weight: .semibold, design: .monospaced))
                    .foregroundStyle(settings.textColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .allowsTightening(true)
                    .contentTransition(.numericText(countsDown: false))
                    .animation(.smooth(duration: 0.35), value: formattedTime)
            }
        } else {
            Text(formattedTime)
                .font(.system(size: CGFloat(settings.fontSize), weight: .semibold, design: .monospaced))
                .foregroundStyle(settings.textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .allowsTightening(true)
        }
    }

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = settings.validatedFormat()
        return formatter.string(from: currentTime)
    }
}
