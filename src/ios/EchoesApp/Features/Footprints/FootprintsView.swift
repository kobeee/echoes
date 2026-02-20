import SwiftUI

struct FootprintsView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: EchoesSpacing.md) {
                Text("我的足迹")
                    .font(EchoesFont.largeTitle)
                    .foregroundStyle(EchoesColor.textPrimary)

                statsCard

                if store.footprints.isEmpty {
                    emptyState
                } else {
                    timeline
                }
            }
            .padding(EchoesSpacing.md)
            .padding(.bottom, 120)
        }
        .contentMargins(.top, EchoesSpacing.md, for: .scrollContent)
        .scrollIndicators(.hidden)
        .background(EchoesColor.bgPrimary)
    }

    private var statsCard: some View {
        CardContainer {
            HStack {
                stat("已埋藏", "\(store.echoes.count)", EchoesColor.gold)
                Spacer()
                stat("已拾取", "\(store.footprints.count)", EchoesColor.teal)
                Spacer()
                stat("探索距离 km", "256", EchoesColor.textPrimary)
            }
        }
    }

    private var timeline: some View {
        VStack(alignment: .leading, spacing: EchoesSpacing.sm) {
            Text("今天")
                .font(EchoesFont.caption)
                .foregroundStyle(EchoesColor.textSecondary)
            footprintCard(title: "语音回响", subtitle: "故宫午门 · 今天 14:30", icon: "waveform")

            Text("昨天")
                .font(EchoesFont.caption)
                .foregroundStyle(EchoesColor.textSecondary)
                .padding(.top, 4)
            footprintCard(title: "文字便签", subtitle: "三里屯 · 昨天 15:20", icon: "note.text")
        }
    }

    private func footprintCard(title: String, subtitle: String, icon: String) -> some View {
        CardContainer {
            HStack(spacing: EchoesSpacing.sm) {
                Circle()
                    .fill(EchoesColor.bgTertiary)
                    .frame(width: 32, height: 32)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(EchoesColor.gold)
                    }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(EchoesFont.headline)
                        .foregroundStyle(EchoesColor.textPrimary)
                    Text(subtitle)
                        .font(EchoesFont.caption)
                        .foregroundStyle(EchoesColor.textSecondary)
                }
                Spacer()
            }
        }
    }

    private var emptyState: some View {
        CardContainer {
            VStack(spacing: EchoesSpacing.md) {
                Text("还没有足迹记录")
                    .font(EchoesFont.title)
                    .foregroundStyle(EchoesColor.textPrimary)
                Text("去探索世界，留下你的第一个回响")
                    .font(EchoesFont.body)
                    .foregroundStyle(EchoesColor.textSecondary)
                    .multilineTextAlignment(.center)
                PrimaryButton(title: "开始探索") {
                    store.selectedTab = .map
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func stat(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            Text(title)
                .font(EchoesFont.caption)
                .foregroundStyle(EchoesColor.textSecondary)
        }
    }
}