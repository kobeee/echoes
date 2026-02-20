import SwiftUI

struct PickupView: View {
    @EnvironmentObject private var store: AppStore
    @State private var selectedID: UUID?
    
    let onOpenEchoContent: (UUID) -> Void
    let onOpenPasscode: (UUID) -> Void
    let onOpenTimeLock: (UUID) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: EchoesSpacing.md) {
                headerSection
                
                if let echo = selectedEcho {
                    contentSection(echo: echo)
                } else {
                    emptyState
                }
            }
            .padding(.horizontal, EchoesSpacing.md)
            .padding(.bottom, 120)
        }
        .contentMargins(.top, EchoesSpacing.md, for: .scrollContent)
        .scrollIndicators(.hidden)
        .background(EchoesColor.bgPrimary)
        .onAppear {
            if selectedID == nil {
                selectedID = store.nearbyEchoes.first?.id
            }
            if let echo = selectedEcho {
                store.startTracking(echo)
                store.updateTracking(distance: echo.distanceMeters, title: echo.title)
            }
        }
        .onDisappear {
            store.stopTracking()
        }
    }
    
    private var headerSection: some View {
        Text("发现回响")
            .font(EchoesFont.headline)
            .foregroundStyle(EchoesColor.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.bottom, EchoesSpacing.sm)
    }
    
    @ViewBuilder
    private func contentSection(echo: EchoItem) -> some View {
        targetCard(echo)
        
        RadarView(
            showsEchoes: false,
            size: 220,
            centerSymbol: "location.north.fill"
        )
        .padding(.vertical, EchoesSpacing.md)
        
        VStack(spacing: 4) {
            Text("距离")
                .font(EchoesFont.caption)
                .foregroundStyle(EchoesColor.textSecondary)
            Text("\(echo.distanceMeters)米")
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .foregroundStyle(EchoesColor.textPrimary)
        }
        
        SignalBarsView(level: signalLevel(for: echo.distanceMeters))
            .padding(.bottom, EchoesSpacing.md)
        
        PrimaryButton(title: "解锁内容") {
            store.updateTracking(distance: echo.distanceMeters, title: echo.title)
            if echo.isTimeLocked {
                onOpenTimeLock(echo.id)
            } else if echo.visibility == .private {
                onOpenPasscode(echo.id)
            } else {
                onOpenEchoContent(echo.id)
            }
        }
        
        if store.nearbyEchoes.count > 1 {
            nextTargetButton
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: EchoesSpacing.md) {
            Spacer()
            Text("附近暂无可拾取回响")
                .font(EchoesFont.body)
                .foregroundStyle(EchoesColor.textSecondary)
            Spacer()
        }
    }

    private func targetCard(_ echo: EchoItem) -> some View {
        CardContainer {
            HStack(spacing: EchoesSpacing.sm) {
                Image(systemName: "waveform")
                    .foregroundStyle(EchoesColor.textPrimary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(echo.title)
                        .font(EchoesFont.headline)
                        .foregroundStyle(EchoesColor.textPrimary)
                    Text("\(echo.locationName) · 3天前")
                        .font(EchoesFont.caption)
                        .foregroundStyle(EchoesColor.textSecondary)
                }
                Spacer()
            }
        }
    }

    private var nextTargetButton: some View {
        Button("切换目标") {
            guard !store.nearbyEchoes.isEmpty else { return }
            let ids = store.nearbyEchoes.map(\.id)
            guard let current = selectedID, let index = ids.firstIndex(of: current) else {
                selectedID = ids.first
                return
            }
            let nextIndex = (index + 1) % ids.count
            selectedID = ids[nextIndex]
            if let echo = selectedEcho {
                store.startTracking(echo)
                store.updateTracking(distance: echo.distanceMeters, title: echo.title)
            }
        }
        .font(EchoesFont.footnote)
        .foregroundStyle(EchoesColor.textSecondary)
        .padding(.top, EchoesSpacing.sm)
    }

    private var selectedEcho: EchoItem? {
        guard let selectedID else { return store.nearbyEchoes.first }
        return store.nearbyEchoes.first(where: { $0.id == selectedID })
    }

    private func signalLevel(for distance: Int) -> Int {
        max(1, min(5, 6 - distance / 100))
    }
}
