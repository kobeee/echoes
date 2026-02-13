import SwiftUI

struct EchoContentView: View {
    @EnvironmentObject private var store: AppStore
    let echoID: UUID

    var body: some View {
        VStack(alignment: .leading, spacing: EchoesSpacing.md) {
            header

            if let echo {
                CardContainer {
                    HStack(spacing: EchoesSpacing.sm) {
                        Image(systemName: "waveform")
                            .foregroundStyle(EchoesColor.textPrimary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("语音回响")
                                .font(EchoesFont.headline)
                                .foregroundStyle(EchoesColor.textPrimary)
                            Text("\(echo.locationName) · 3天前")
                                .font(EchoesFont.caption)
                                .foregroundStyle(EchoesColor.textSecondary)
                        }
                    }
                }

                CardContainer {
                    waveform
                    Rectangle()
                        .fill(EchoesColor.border)
                        .frame(height: 2)
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .fill(EchoesColor.gold)
                                .frame(width: 70, height: 2)
                        }
                    HStack {
                        Image(systemName: "play.fill")
                        Text("00:23 / 01:00")
                            .font(.system(.footnote, design: .monospaced))
                    }
                    .foregroundStyle(EchoesColor.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                CardContainer {
                    Text("距离这个回响被埋下，已经过去")
                        .font(EchoesFont.footnote)
                        .foregroundStyle(EchoesColor.textSecondary)
                    Text(ageText(from: echo.createdAt))
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(EchoesColor.gold)
                }

                PrimaryButton(title: "✓ 标记为已阅") {
                    store.markWitnessed(echoID)
                    store.modalRoute = nil
                }
            }

            Spacer()
        }
        .padding(EchoesSpacing.md)
        .background(EchoesColor.bgPrimary.ignoresSafeArea())
    }

    private var header: some View {
        HStack {
            Button {
                store.modalRoute = nil
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundStyle(EchoesColor.textPrimary)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("语音回响")
                .font(EchoesFont.headline)
                .foregroundStyle(EchoesColor.textPrimary)

            Spacer()

            Color.clear.frame(width: 20)
        }
    }

    private var waveform: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(0..<16, id: \.self) { index in
                RoundedRectangle(cornerRadius: EchoesRadius.xs)
                    .fill(EchoesColor.gold.opacity(index.isMultiple(of: 2) ? 1 : 0.55))
                    .frame(width: 5, height: CGFloat(12 + abs(8 - index) * 4))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, EchoesSpacing.sm)
    }

    private func ageText(from createdAt: Date) -> String {
        let duration = Date.now.timeIntervalSince(createdAt)
        let days = Int(duration / 86_400)
        let hours = Int((duration.truncatingRemainder(dividingBy: 86_400)) / 3600)
        return "\(days)天 \(hours)小时"
    }

    private var echo: EchoItem? {
        store.echoes.first(where: { $0.id == echoID })
    }
}
