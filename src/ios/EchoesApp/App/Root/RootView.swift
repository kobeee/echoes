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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
        TabView(selection: $store.selectedTab) {
            MapHomeView()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .tag(AppTab.map)
                .tabItem {
                    Label("首页", systemImage: "house")
                }

            PickupView()
                .tag(AppTab.pickup)
                .tabItem {
                    Label("地图", systemImage: "map")
                }

            DropView()
                .tag(AppTab.drop)
                .tabItem {
                    Label("埋藏", systemImage: "plus.circle.fill")
                }

            FootprintsView()
                .tag(AppTab.footprints)
                .tabItem {
                    Label("足迹", systemImage: "figure.walk")
                }

            SettingsView()
                .tag(AppTab.settings)
                .tabItem {
                    Label("设置", systemImage: "gearshape")
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tint(EchoesColor.gold)
        .toolbarBackground(EchoesColor.bgSecondary, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}
