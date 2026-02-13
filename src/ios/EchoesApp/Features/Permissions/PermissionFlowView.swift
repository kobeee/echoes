import SwiftUI

struct PermissionFlowView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        let config = configForStep(store.permissionStep)
        VStack(spacing: EchoesSpacing.xl) {
            Spacer()
            Image(systemName: config.icon)
                .font(.system(size: 64, weight: .regular))
                .foregroundStyle(config.color)

            VStack(spacing: EchoesSpacing.sm) {
                Text(config.title)
                    .font(EchoesFont.title)
                    .foregroundStyle(EchoesColor.textPrimary)
                Text(config.description)
                    .font(EchoesFont.body)
                    .foregroundStyle(EchoesColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, EchoesSpacing.xl)
            }

            Spacer()
            VStack(spacing: EchoesSpacing.sm) {
                PrimaryButton(title: config.buttonTitle) {
                    store.grantCurrentPermission()
                }
                Button("稍后再说") {
                    store.skipPermissions()
                }
                .font(EchoesFont.subhead)
                .foregroundStyle(EchoesColor.textSecondary)
            }
            .padding(.horizontal, EchoesSpacing.md)
            .padding(.bottom, EchoesSpacing.xl)
        }
        .background(EchoesColor.bgPrimary.ignoresSafeArea())
    }

    private func configForStep(_ step: PermissionStep) -> (icon: String, title: String, description: String, buttonTitle: String, color: Color) {
        switch step {
        case .location:
            return (
                "location.north.fill",
                "发现身边的回响",
                "我们需要你的位置来发现附近的回响，并帮你埋藏新的回响。",
                "允许使用位置",
                EchoesColor.teal
            )
        case .microphone:
            return (
                "mic.fill",
                "录下当下的声音",
                "允许麦克风权限后，你可以创建语音回响和 SOS 录制。",
                "允许使用麦克风",
                EchoesColor.gold
            )
        case .notifications:
            return (
                "bell.fill",
                "不错过任何回响",
                "通知用于提醒你附近新发现的回响与时间锁到期。",
                "允许通知",
                EchoesColor.purple
            )
        }
    }
}
