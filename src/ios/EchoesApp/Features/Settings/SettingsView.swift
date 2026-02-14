import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: AppStore
    @State private var locationSharing = true
    @State private var backgroundLocation = true
    @State private var localReview = false
    @State private var nearbyNotify = true
    @State private var vibration = true

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: EchoesSpacing.md) {
                    header
                        .padding(.top, geometry.safeAreaInsets.top)
                    profileCard
                    proCard
                    sectionTitle("隐私")
                    privacySection
                    sectionTitle("通知")
                    notificationSection
                    sectionTitle("关于")
                    aboutSection
                    
                    // 为 TabBar 预留空间
                    Spacer()
                        .frame(height: geometry.safeAreaInsets.bottom + 100)
                }
                .padding(EchoesSpacing.md)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(EchoesColor.bgPrimary.ignoresSafeArea())
    }

    private var header: some View {
        HStack {
            Text("设置")
                .font(EchoesFont.headline)
                .foregroundStyle(EchoesColor.textPrimary)
            Spacer()
        }
    }

    private var profileCard: some View {
        CardContainer {
            HStack(spacing: EchoesSpacing.md) {
                Circle()
                    .fill(EchoesColor.bgTertiary)
                    .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Device ID: ****8273")
                        .font(EchoesFont.headline)
                        .foregroundStyle(EchoesColor.textPrimary)
                    Text("Recovery Key available")
                        .font(EchoesFont.caption)
                        .foregroundStyle(EchoesColor.teal)
                }
                Spacer()
            }
            .onTapGesture {
                store.modalRoute = .recoveryKey
            }
        }
    }

    private var proCard: some View {
        CardContainer {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Echoes Pro")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(EchoesColor.gold)
                    Text("解锁附近秘境地图 | 专属金色光点")
                        .font(EchoesFont.caption)
                        .foregroundStyle(EchoesColor.goldSoft)
                    Text("了解更多 >")
                        .font(EchoesFont.footnote)
                        .foregroundStyle(EchoesColor.gold)
                }
                Spacer()
                Text("¥12/月")
                    .font(EchoesFont.headline)
                    .foregroundStyle(EchoesColor.gold)
            }
            .onTapGesture {
                store.modalRoute = .proSubscription
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous)
                .stroke(EchoesColor.gold, lineWidth: 1)
        )
    }

    private var privacySection: some View {
        CardContainer {
            toggleRow("精确位置共享", $locationSharing)
            divider
            toggleRow("后台定位权限", $backgroundLocation)
            divider
            toggleRow("本地内容审核", $localReview)
        }
    }

    private var notificationSection: some View {
        CardContainer {
            toggleRow("附近回响通知", $nearbyNotify)
            divider
            toggleRow("震动反馈", $vibration)
        }
    }

    private var aboutSection: some View {
        CardContainer {
            row("版本", detail: "1.0.0")
            divider
            row("隐私政策", detail: "")
            divider
            row("联系我们", detail: "")
            divider
            row("给我们评分", detail: "")
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(EchoesFont.caption)
            .foregroundStyle(EchoesColor.textMuted)
            .padding(.horizontal, EchoesSpacing.xs)
    }

    private func row(_ title: String, detail: String) -> some View {
        HStack {
            Text(title)
                .font(EchoesFont.body)
                .foregroundStyle(EchoesColor.textPrimary)
            Spacer()
            if detail.isEmpty {
                Image(systemName: "chevron.right")
                    .foregroundStyle(EchoesColor.textSecondary)
            } else {
                Text(detail)
                    .font(EchoesFont.footnote)
                    .foregroundStyle(EchoesColor.textSecondary)
            }
        }
        .frame(height: 44)
    }

    private func toggleRow(_ title: String, _ value: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .font(EchoesFont.body)
                .foregroundStyle(EchoesColor.textPrimary)
            Spacer()
            Toggle("", isOn: value)
                .labelsHidden()
                .tint(EchoesColor.teal)
        }
        .frame(height: 44)
    }

    private var divider: some View {
        Rectangle()
            .fill(EchoesColor.border)
            .frame(height: 1)
            .padding(.leading, EchoesSpacing.md)
    }
}