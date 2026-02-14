import SwiftUI

struct RootView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        Group {
            switch store.phase {
            case .launch:
                LaunchView {
                    store.onLaunchFinished()
                }
            case .permissions:
                PermissionFlowView()
            case .main:
                MainShellView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(EchoesColor.bgPrimary.ignoresSafeArea())
        .sheet(item: $store.modalRoute) { route in
            modalView(route)
                .presentationDragIndicator(.visible)
                .presentationBackground(EchoesColor.bgPrimary)
        }
        .fullScreenCover(item: $store.fullScreenRoute) { route in
            if route == .blackBox { BlackBoxView() }
        }
    }

    @ViewBuilder
    private func modalView(_ route: AppStore.ModalRoute) -> some View {
        switch route {
        case .dropSuccess(let title):
            DropSuccessView(title: title)
        case .echoContent(let id):
            EchoContentView(echoID: id)
        case .passcode(let id):
            PasscodeSheet(echoID: id)
        case .timeLock(let id):
            TimeLockLockedView(echoID: id)
        case .sosComplete(let key):
            SOSCompleteView(recoveryKey: key)
        case .recoveryKey:
            RecoveryKeyView()
        case .proSubscription:
            ProSubscriptionView()
        }
    }
}

private struct MainShellView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        // 原生 TabView - iOS 26 自动获得悬浮椭圆形 Liquid Glass TabBar
        // 不使用任何容器包裹，让 TabView 自己处理全屏布局
        TabView(selection: $store.selectedTab) {
            Tab(AppTab.map.title, systemImage: "house", value: AppTab.map) {
                MapHomeView()
            }
            
            Tab(AppTab.pickup.title, systemImage: "map", value: AppTab.pickup) {
                PickupView()
            }
            
            Tab(AppTab.drop.title, systemImage: "plus.circle.fill", value: AppTab.drop) {
                DropView()
            }
            
            Tab(AppTab.footprints.title, systemImage: "figure.walk", value: AppTab.footprints) {
                FootprintsView()
            }
            
            Tab(AppTab.settings.title, systemImage: "gearshape", value: AppTab.settings) {
                SettingsView()
            }
        }
        .tint(EchoesColor.gold)
        .tabBarMinimizeBehavior(.onScrollDown)
        .ignoresSafeArea()
    }
}