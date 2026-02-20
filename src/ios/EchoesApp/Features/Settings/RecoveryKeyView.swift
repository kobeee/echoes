import SwiftUI
import UIKit

struct RecoveryKeyView: View {
    @State private var copied = false
    let onClose: () -> Void

    private let key = "A7K2-M9X4-P3L8-W6N1"

    var body: some View {
        VStack(spacing: EchoesSpacing.md) {
            HStack {
                Button {
                    onClose()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(EchoesColor.textPrimary)
                }
                Spacer()
                Text("Recovery Key")
                    .font(EchoesFont.headline)
                    .foregroundStyle(EchoesColor.textPrimary)
                Spacer()
                Color.clear.frame(width: 20)
            }
            .padding(.top, EchoesSpacing.md)

            Spacer(minLength: 8)

            Image(systemName: "key.fill")
                .font(.system(size: 44, weight: .regular))
                .foregroundStyle(EchoesColor.teal)

            Text("这是找回 SOS 数据的唯一凭证\n请妥善保管，丢失后无法恢复")
                .font(EchoesFont.subhead)
                .foregroundStyle(EchoesColor.textSecondary)
                .multilineTextAlignment(.center)

            CardContainer {
                Text("你的 Recovery Key")
                    .font(EchoesFont.footnote)
                    .foregroundStyle(EchoesColor.textSecondary)
                Text(key)
                    .font(.system(size: 32, weight: .semibold, design: .monospaced))
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(EchoesColor.textPrimary)
                Text("点击上方密钥可复制到剪贴板")
                    .font(EchoesFont.caption)
                    .foregroundStyle(EchoesColor.textMuted)
            }

            CardContainer {
                Text("安全提醒")
                    .font(EchoesFont.headline)
                    .foregroundStyle(EchoesColor.red)
                Text("Recovery Key 不会存储在服务器上。\n如果丢失，SOS 数据将永远无法找回。")
                    .font(EchoesFont.footnote)
                    .foregroundStyle(EchoesColor.red)
            }
            .overlay(
                RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous)
                    .stroke(EchoesColor.red, lineWidth: 1)
            )

            PrimaryButton(title: copied ? "已复制" : "复制 Key", color: EchoesColor.teal) {
                UIPasteboard.general.string = key
                copied = true
                Haptics.success()
            }

            SecondaryButton(title: "我已安全备份") {
                onClose()
            }

            Spacer()
        }
        .padding(EchoesSpacing.md)
        .background(EchoesColor.bgPrimary)
    }
}
