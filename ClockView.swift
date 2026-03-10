import SwiftUI

struct ClockView: View {
    @ObservedObject var settings: ClockSettings
    @State private var currentTime = Date()

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(formattedTime)
            .font(.system(size: 24, weight: .medium, design: .monospaced))
            .foregroundColor(settings.textColor)
            .shadow(color: .black.opacity(0.8), radius: 2, x: 1, y: 1)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .onReceive(timer) { time in
                currentTime = time
            }
    }

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = settings.validatedFormat()
        return formatter.string(from: currentTime)
    }
}
