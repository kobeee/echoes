import SwiftUI

struct TimeLockLockedView: View {
    @EnvironmentObject private var store: AppStore
    let echoID: UUID

    var body: some View {
        VStack(spacing: EchoesSpacing.md) {
            HStack {
                Button {
                    store.modalRoute = nil
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(EchoesColor.textPrimary)
                }
                Spacer()
                Text("发现回响")
                    .font(EchoesFont.headline)
                    .foregroundStyle(EchoesColor.textPrimary)
                Spacer()
                Color.clear.frame(width: 20)
            }
            .padding(.top, EchoesSpacing.md)
            .padding(.horizontal, EchoesSpacing.md)

            CardContainer {
                HStack(spacing: EchoesSpacing.sm) {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(EchoesColor.textPrimary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("加密时间胶囊")
                            .font(EchoesFont.headline)
                            .foregroundStyle(EchoesColor.textPrimary)
                        Text("来自匿名旅行者 · 2030年1月1日开锁")
                            .font(EchoesFont.caption)
                            .foregroundStyle(EchoesColor.textSecondary)
                    }
                }
            }
            .padding(.horizontal, EchoesSpacing.md)

            ZStack {
                Circle()
                    .fill(EchoesColor.gold.opacity(0.12))
                    .frame(width: 110, height: 110)
                Circle()
                    .stroke(EchoesColor.gold, lineWidth: 1)
                    .frame(width: 66, height: 66)
                Image(systemName: "lock.fill")
                    .foregroundStyle(EchoesColor.gold)
            }
            .padding(.top, EchoesSpacing.lg)

            Text("距离开启还有")
                .font(EchoesFont.subhead)
                .foregroundStyle(EchoesColor.textSecondary)

            Text("\(daysRemaining) 天")
                .font(.system(size: 54, weight: .regular, design: .rounded))
                .foregroundStyle(EchoesColor.gold)

            Text("将于 \(unlockDateText) 开启")
                .font(EchoesFont.subhead)
                .foregroundStyle(EchoesColor.textSecondary)

            PrimaryButton(title: "⚙ 设置提醒") {
                Haptics.success()
                store.modalRoute = nil
            }
            .padding(.horizontal, EchoesSpacing.md)
            .padding(.top, EchoesSpacing.md)

            Button("返回地图") {
                store.modalRoute = nil
            }
            .font(EchoesFont.footnote)
            .foregroundStyle(EchoesColor.textSecondary)

            Spacer()
        }
        .background(EchoesColor.bgPrimary.ignoresSafeArea())
    }

    private var echo: EchoItem? {
        store.echoes.first(where: { $0.id == echoID })
    }

    private var daysRemaining: Int {
        guard let target = echo?.timeLockDate else { return 0 }
        return max(0, Calendar.current.dateComponents([.day], from: .now, to: target).day ?? 0)
    }

    private var unlockDateText: String {
        guard let target = echo?.timeLockDate else { return "未知" }
        return target.formatted(
            Date.FormatStyle()
                .year()
                .month(.wide)
                .day()
                .hour(.twoDigits(amPM: .omitted))
                .minute(.twoDigits)
        )
    }
}
