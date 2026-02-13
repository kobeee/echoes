import SwiftUI

struct SOSCompleteView: View {
    @EnvironmentObject private var store: AppStore
    let recoveryKey: String

    var body: some View {
        VStack(spacing: EchoesSpacing.md) {
            HStack {
                Spacer()
                Button {
                    store.modalRoute = nil
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(EchoesColor.textSecondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, EchoesSpacing.md)

            Spacer(minLength: 8)

            Circle()
                .fill(EchoesColor.teal)
                .frame(width: 84, height: 84)
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.system(size: 42, weight: .regular))
                        .foregroundStyle(EchoesColor.textPrimary)
                }

            Text("数据已安全保存")
                .font(EchoesFont.title)
                .foregroundStyle(EchoesColor.textPrimary)

            CardContainer {
                Text("◌ 已上传 30 秒录音")
                    .font(EchoesFont.footnote)
                    .foregroundStyle(EchoesColor.textSecondary)
                Text("◌ AES-256 端到端加密")
                    .font(EchoesFont.footnote)
                    .foregroundStyle(EchoesColor.textSecondary)
                Text("◌ GPS: 39.9042°N, 116.4074°E")
                    .font(EchoesFont.footnote)
                    .foregroundStyle(EchoesColor.textSecondary)
            }

            CardContainer {
                Text("⚠ 请妥善保管你的 Recovery Key")
                    .font(EchoesFont.headline)
                    .foregroundStyle(EchoesColor.gold)
                Text(maskedKey)
                    .font(.system(.body, design: .monospaced))
                    .foregroundStyle(EchoesColor.textSecondary)
                Text("这是找回原始数据的唯一方式")
                    .font(EchoesFont.footnote)
                    .foregroundStyle(EchoesColor.gold)
            }
            .overlay(
                RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous)
                    .stroke(EchoesColor.gold, lineWidth: 1)
            )

            PrimaryButton(title: "知道了") {
                store.modalRoute = nil
                store.selectedTab = .map
            }
            .padding(.top, EchoesSpacing.sm)

            Spacer()
        }
        .padding(EchoesSpacing.md)
        .background(Color.black.ignoresSafeArea())
    }

    private var maskedKey: String {
        let parts = recoveryKey.split(separator: "-")
        guard let first = parts.first else { return "****" }
        return "\(first)-****-****-****"
    }
}
