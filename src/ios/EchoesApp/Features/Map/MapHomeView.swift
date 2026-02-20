import SwiftUI

struct MapHomeView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        ZStack {
            // 背景 - 填满整个屏幕
            EchoesColor.bgPrimary
                .ignoresSafeArea()
            
            // 雷达区域 - 居中显示
            RadarView(
                showsEchoes: !store.nearbyEchoes.isEmpty,
                echoes: store.nearbyEchoes,
                size: 300
            )
            
            // 顶部栏
            VStack {
                topBar
                    .padding(.horizontal, EchoesSpacing.md)
                    .padding(.top, 8)
                
                Spacer()
                
                // 底部内容
                bottomContent
                    .padding(.horizontal, EchoesSpacing.md)
                    .padding(.bottom, 100) // 为 TabBar 留出空间
            }
        }
    }

    @ViewBuilder
    private var bottomContent: some View {
        if store.nearbyEchoes.isEmpty {
            emptyState
                .padding(.horizontal, EchoesSpacing.md)
        } else {
            VStack(spacing: EchoesSpacing.md) {
                locationBadge
                discoveryCard
            }
        }
    }

    private var topBar: some View {
        HStack {
            Label(scanLabel, systemImage: "circle.fill")
                .font(EchoesFont.footnote)
                .foregroundStyle(EchoesColor.teal)
                .symbolRenderingMode(.monochrome)

            Spacer()

            Button {
                store.startSOS()
            } label: {
                Circle()
                    .fill(EchoesColor.red.opacity(0.25))
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(EchoesColor.red)
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("紧急模式")
        }
    }

    private var scanLabel: String {
        if store.nearbyEchoes.isEmpty {
            return "未发现信号"
        }
        return "正在扫描   \(store.nearbyEchoes.count) 个信号"
    }

    private var locationBadge: some View {
        Text("北京市朝阳区 · GPS ±5m")
            .font(EchoesFont.caption)
            .foregroundStyle(EchoesColor.textSecondary)
            .padding(.horizontal, 20)
            .padding(.vertical, 6)
            .background(EchoesColor.bgSecondary.opacity(0.9))
            .clipShape(Capsule())
    }

    private var discoveryCard: some View {
        Button {
            store.selectedTab = .pickup
        } label: {
            HStack(spacing: EchoesSpacing.sm) {
                Text("♪")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(EchoesColor.gold)

                VStack(alignment: .leading, spacing: 2) {
                    Text("发现附近的回响")
                        .font(EchoesFont.headline)
                        .foregroundStyle(EchoesColor.textPrimary)
                    Text("50秒外 · 语音回响 · 点击查看")
                        .font(EchoesFont.caption)
                        .foregroundStyle(EchoesColor.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(EchoesColor.gold)
            }
            .padding(EchoesSpacing.md)
            .frame(maxWidth: .infinity)
            .background(EchoesColor.bgSecondary)
            .overlay(
                RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous)
                    .stroke(EchoesColor.gold, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: EchoesSpacing.sm) {
            Text("这里还没有回响")
                .font(EchoesFont.title)
                .foregroundStyle(EchoesColor.textPrimary)

            Text("成为第一个在这里留下声音的人")
                .font(EchoesFont.body)
                .foregroundStyle(EchoesColor.textSecondary)

            Button {
                store.selectedTab = .drop
            } label: {
                Label("留下第一个回响", systemImage: "mic.fill")
                    .font(EchoesFont.headline)
                    .foregroundStyle(Color.black.opacity(0.85))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(EchoesColor.gold)
                    .clipShape(RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.top, EchoesSpacing.sm)
        }
        .padding(.horizontal, EchoesSpacing.md)
    }
}
