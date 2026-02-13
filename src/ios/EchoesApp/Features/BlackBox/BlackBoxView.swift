import SwiftUI

struct BlackBoxView: View {
    @EnvironmentObject private var store: AppStore
    @State private var seconds = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.opacity(0.98).ignoresSafeArea()

            VStack(spacing: EchoesSpacing.md) {
                header

                Spacer(minLength: 8)

                ZStack {
                    Circle()
                        .fill(EchoesColor.red.opacity(0.14))
                        .frame(width: 120, height: 120)
                    Circle()
                        .fill(EchoesColor.red.opacity(0.38))
                        .frame(width: 48, height: 48)
                }

                Text(String(format: "%02d:%02d", seconds / 60, seconds % 60))
                    .font(EchoesFont.timer)
                    .foregroundStyle(EchoesColor.textPrimary)

                Text("/ 00:30")
                    .font(EchoesFont.subhead)
                    .foregroundStyle(EchoesColor.textSecondary)

                Text("正在上传至端到端 SOS 服务器...")
                    .font(EchoesFont.footnote)
                    .foregroundStyle(EchoesColor.red)

                uploadBars

                Text("\(seconds)/30 秒已安全上传至云端")
                    .font(EchoesFont.caption)
                    .foregroundStyle(EchoesColor.red)

                CardContainer {
                    HStack(spacing: EchoesSpacing.sm) {
                        Image(systemName: "shield.fill")
                            .foregroundStyle(EchoesColor.red)
                        Text("数据已加密上传，只能通过 Recovery Key 找回")
                            .font(EchoesFont.footnote)
                            .foregroundStyle(EchoesColor.red)
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous)
                        .stroke(EchoesColor.red.opacity(0.7), lineWidth: 1)
                )

                PrimaryButton(title: "停止并保存", color: EchoesColor.red) {
                    store.completeSOS()
                }
                .padding(.top, EchoesSpacing.md)

                Spacer()
            }
            .padding(EchoesSpacing.md)
        }
        .onReceive(timer) { _ in
            guard seconds < 30 else {
                store.completeSOS()
                return
            }
            seconds += 1
            store.updateSOS(seconds: seconds)
        }
        .onAppear {
            seconds = 0
            store.updateSOS(seconds: 0)
        }
    }

    private var header: some View {
        HStack {
            Text("⚠︎ 紧急模式")
                .font(EchoesFont.title)
                .foregroundStyle(EchoesColor.red)
            Spacer()
            Button {
                store.completeSOS()
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(EchoesColor.textSecondary)
            }
            .buttonStyle(.plain)
        }
    }

    private var uploadBars: some View {
        HStack(spacing: 3) {
            ForEach(0..<30, id: \.self) { idx in
                RoundedRectangle(cornerRadius: 1)
                    .fill(idx < seconds ? EchoesColor.red : EchoesColor.red.opacity(0.2))
                    .frame(width: 6, height: 14)
            }
        }
    }
}
