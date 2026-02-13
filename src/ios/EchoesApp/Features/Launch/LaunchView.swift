import SwiftUI

struct LaunchView: View {
    let onFinished: () -> Void

    var body: some View {
        ZStack {
            EchoesColor.bgPrimary.ignoresSafeArea()
            VStack(spacing: EchoesSpacing.lg) {
                ZStack {
                    ring(140, opacity: 0.15)
                    ring(100, opacity: 0.3)
                    ring(60, opacity: 0.8)
                }
                Text("E C H O E S")
                    .font(.system(size: 22, weight: .semibold))
                    .kerning(6)
                    .foregroundStyle(EchoesColor.goldSoft)
                Text("只有身临其境，才能听见回响")
                    .font(EchoesFont.subhead)
                    .foregroundStyle(EchoesColor.textSecondary)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1.3))
            onFinished()
        }
    }

    private func ring(_ size: CGFloat, opacity: Double) -> some View {
        Circle()
            .stroke(EchoesColor.gold.opacity(opacity), lineWidth: 1.5)
            .frame(width: size, height: size)
    }
}
