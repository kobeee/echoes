import SwiftUI

enum SheetDestination: Identifiable {
    case dropSuccess(String)
    case echoContent(UUID)
    case passcode(UUID)
    case timeLock(UUID)
    case sosComplete(String)
    case recoveryKey
    case proSubscription
    
    var id: String {
        switch self {
        case .dropSuccess(let title): return "dropSuccess-\(title)"
        case .echoContent(let id): return "echo-\(id.uuidString)"
        case .passcode(let id): return "passcode-\(id.uuidString)"
        case .timeLock(let id): return "timeLock-\(id.uuidString)"
        case .sosComplete(let key): return "sos-\(key)"
        case .recoveryKey: return "recoveryKey"
        case .proSubscription: return "pro"
        }
    }
}

struct RootView: View {
    @EnvironmentObject private var store: AppStore
    @State private var sheetDestination: SheetDestination?

    var body: some View {
        ZStack {
            EchoesColor.bgPrimary
                .ignoresSafeArea()
            
            switch store.phase {
            case .launch:
                LaunchView {
                    store.onLaunchFinished()
                }
            case .permissions:
                PermissionFlowView()
            case .main:
                MainShellView(
                    onOpenDropSuccess: { title in
                        sheetDestination = .dropSuccess(title)
                    },
                    onOpenEchoContent: { id in
                        sheetDestination = .echoContent(id)
                    },
                    onOpenPasscode: { id in
                        sheetDestination = .passcode(id)
                    },
                    onOpenTimeLock: { id in
                        sheetDestination = .timeLock(id)
                    },
                    onOpenSOSComplete: { key in
                        sheetDestination = .sosComplete(key)
                    },
                    onOpenRecoveryKey: {
                        sheetDestination = .recoveryKey
                    },
                    onOpenProSubscription: {
                        sheetDestination = .proSubscription
                    }
                )
            }
        }
        .fullScreenCover(item: $store.fullScreenRoute) { route in
            if route == .blackBox {
                BlackBoxView()
            }
        }
        .sheet(item: $sheetDestination) { destination in
            sheetContent(for: destination)
                .presentationDragIndicator(.visible)
                .presentationBackground(EchoesColor.bgPrimary)
        }
        .onChange(of: store.sosCompletionKey) { _, newValue in
            if let key = newValue {
                sheetDestination = .sosComplete(key)
                store.sosCompletionKey = nil
            }
        }
    }
    
    @ViewBuilder
    private func sheetContent(for destination: SheetDestination) -> some View {
        switch destination {
        case .dropSuccess(let title):
            DropSuccessView(title: title) {
                sheetDestination = nil
                store.selectedTab = .map
            }
        case .echoContent(let id):
            EchoContentView(echoID: id) {
                sheetDestination = nil
            }
        case .passcode(let id):
            PasscodeSheet(echoID: id) { success in
                if success {
                    sheetDestination = .echoContent(id)
                } else {
                    sheetDestination = nil
                }
            }
        case .timeLock(let id):
            TimeLockLockedView(echoID: id) {
                sheetDestination = nil
            }
        case .sosComplete(let key):
            SOSCompleteView(recoveryKey: key) {
                sheetDestination = nil
            }
        case .recoveryKey:
            RecoveryKeyView {
                sheetDestination = nil
            }
        case .proSubscription:
            ProSubscriptionView {
                sheetDestination = nil
            }
        }
    }
}

private struct MainShellView: View {
    @EnvironmentObject private var store: AppStore
    
    let onOpenDropSuccess: (String) -> Void
    let onOpenEchoContent: (UUID) -> Void
    let onOpenPasscode: (UUID) -> Void
    let onOpenTimeLock: (UUID) -> Void
    let onOpenSOSComplete: (String) -> Void
    let onOpenRecoveryKey: () -> Void
    let onOpenProSubscription: () -> Void
    
    var body: some View {
        TabView(selection: $store.selectedTab) {
            Tab(AppTab.map.title, systemImage: "house", value: AppTab.map) {
                MapHomeView()
            }
            
            Tab(AppTab.pickup.title, systemImage: "map", value: AppTab.pickup) {
                PickupView(
                    onOpenEchoContent: onOpenEchoContent,
                    onOpenPasscode: onOpenPasscode,
                    onOpenTimeLock: onOpenTimeLock
                )
            }
            
            Tab(AppTab.drop.title, systemImage: "plus.circle.fill", value: AppTab.drop) {
                DropView(onSuccess: onOpenDropSuccess)
            }
            
            Tab(AppTab.footprints.title, systemImage: "figure.walk", value: AppTab.footprints) {
                FootprintsView()
            }
            
            Tab(AppTab.settings.title, systemImage: "gearshape", value: AppTab.settings) {
                SettingsView(
                    onOpenRecoveryKey: onOpenRecoveryKey,
                    onOpenProSubscription: onOpenProSubscription
                )
            }
        }
        .tint(EchoesColor.gold)
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}
