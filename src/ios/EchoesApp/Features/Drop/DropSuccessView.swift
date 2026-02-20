import SwiftUI

struct DropSuccessView: View {
    let title: String
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: EchoesSpacing.lg) {
            Spacer(minLength: 16)

            ZStack {
                ForEach([140.0, 100.0, 60.0], id: \.self) { size in
                    Circle()
                        .stroke(EchoesColor.gold.opacity(size == 60 ? 0.25 : 0.45), lineWidth: 1)
                        .frame(width: size, height: size)
                }

                Circle()
                    .fill(EchoesColor.gold)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.black.opacity(0.9))
                    }
            }

            Text("回响已埋下")
                .font(EchoesFont.title)
                .foregroundStyle(EchoesColor.textPrimary)

            VStack(spacing: 2) {
                Text("📍 \(title)")
                    .font(EchoesFont.body)
                    .foregroundStyle(EchoesColor.textSecondary)
                Text("🔒 公开 · 语音 23秒")
                    .font(EchoesFont.footnote)
                    .foregroundStyle(EchoesColor.textSecondary)
            }

            SecondaryButton(title: "分享给朋友来寻宝") {
                onClose()
            }

            PrimaryButton(title: "返回地图") {
                onClose()
            }

            Spacer()
        }
        .padding(EchoesSpacing.md)
        .background(EchoesColor.bgPrimary)
    }
}
