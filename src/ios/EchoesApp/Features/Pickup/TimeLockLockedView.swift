import SwiftUI

struct TimeLockLockedView: View {
    @EnvironmentObject private var store: AppStore
    let echoID: UUID
    let onClose: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: EchoesSpacing.md) {
                headerBar
                
                if let echo {
                    lockInfoCard(echo)
                    lockIconView
                    countdownSection
                    actionButtons
                }
            }
            .padding(EchoesSpacing.md)
        }
        .scrollIndicators(.hidden)
        .background(EchoesColor.bgPrimary)
    }
    
    private var headerBar: some View {
        HStack {
            Button {
                onClose()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(EchoesColor.textPrimary)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Text("发现回响")
                .font(EchoesFont.headline)
                .foregroundStyle(EchoesColor.textPrimary)
            
            Spacer()
            
            Color.clear.frame(width: 20)
        }
    }
    
    private func lockInfoCard(_ echo: EchoItem) -> some View {
        CardContainer {
            HStack(spacing: EchoesSpacing.sm) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(EchoesColor.textPrimary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(echo.title)
                        .font(EchoesFont.headline)
                        .foregroundStyle(EchoesColor.textPrimary)
                    Text("来自匿名旅行者 · \(unlockDateText)开锁")
                        .font(EchoesFont.caption)
                        .foregroundStyle(EchoesColor.textSecondary)
                }
            }
        }
    }
    
    private var lockIconView: some View {
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
    }
    
    private var countdownSection: some View {
        VStack(spacing: EchoesSpacing.sm) {
            Text("距离开启还有")
                .font(EchoesFont.subhead)
                .foregroundStyle(EchoesColor.textSecondary)
            
            Text("\(daysRemaining) 天")
                .font(.system(size: 54, weight: .regular, design: .rounded))
                .foregroundStyle(EchoesColor.gold)
            
            Text("将于 \(unlockDateText) 开启")
                .font(EchoesFont.subhead)
                .foregroundStyle(EchoesColor.textSecondary)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: EchoesSpacing.md) {
            PrimaryButton(title: "⚙ 设置提醒") {
                Haptics.success()
                onClose()
            }
            
            Button("返回地图") {
                onClose()
            }
            .font(EchoesFont.footnote)
            .foregroundStyle(EchoesColor.textSecondary)
        }
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
