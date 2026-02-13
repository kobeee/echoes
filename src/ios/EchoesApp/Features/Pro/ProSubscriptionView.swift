import SwiftUI

struct ProSubscriptionView: View {
    @EnvironmentObject private var store: AppStore

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
                Text("Echoes Pro")
                    .font(EchoesFont.headline)
                    .foregroundStyle(EchoesColor.gold)
                Spacer()
                Color.clear.frame(width: 20)
            }
            .padding(.top, EchoesSpacing.md)

            Spacer(minLength: 6)

            Image(systemName: "crown.fill")
                .font(.system(size: 32, weight: .regular))
                .foregroundStyle(EchoesColor.gold)

            Text("解锁完整的回响体验")
                .font(EchoesFont.title)
                .foregroundStyle(EchoesColor.gold)

            Text("¥12 / 月")
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .foregroundStyle(EchoesColor.textSecondary)

            feature("附近的秘密地图", "解锁大范围热力图，发现更多回响", "map.fill")
            feature("无限视频上传", "4K 视频和全景图片，不限次数", "camera.fill")
            feature("专属金色光点", "你的回响在地图上以黄金光芒标记", "sparkles")

            PrimaryButton(title: store.isPro ? "已订阅" : "立即订阅 Pro") {
                if !store.isPro { store.togglePro() }
            }
            .padding(.top, EchoesSpacing.sm)

            Button("恢复购买") {
                if !store.isPro { store.togglePro() }
            }
            .font(EchoesFont.subhead)
            .foregroundStyle(EchoesColor.textSecondary)

            Text("订阅将自动续费，可随时在设置中取消")
                .font(EchoesFont.caption)
                .foregroundStyle(EchoesColor.textMuted)

            Spacer()
        }
        .padding(EchoesSpacing.md)
        .background(EchoesColor.bgPrimary.ignoresSafeArea())
    }

    private func feature(_ title: String, _ desc: String, _ icon: String) -> some View {
        CardContainer {
            HStack(spacing: EchoesSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(EchoesColor.gold)
                    .frame(width: 32, height: 32)
                    .background(EchoesColor.gold.opacity(0.16))
                    .clipShape(RoundedRectangle(cornerRadius: EchoesRadius.sm, style: .continuous))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(EchoesFont.headline)
                        .foregroundStyle(EchoesColor.textPrimary)
                    Text(desc)
                        .font(EchoesFont.caption)
                        .foregroundStyle(EchoesColor.textSecondary)
                }
                Spacer()
            }
        }
    }
}
