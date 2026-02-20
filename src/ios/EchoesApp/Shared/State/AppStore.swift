import Foundation

@MainActor
final class AppStore: ObservableObject {
    enum FullScreenRoute: Identifiable {
        case blackBox
        var id: String { "blackBox" }
    }

    @Published var phase: AppPhase = .launch
    @Published var selectedTab: AppTab = .map
    @Published var permissionStep: PermissionStep = .location
    @Published var grantedPermissions: Set<PermissionStep> = []
    @Published var fullScreenRoute: FullScreenRoute?
    @Published var sosCompletionKey: String?
    @Published var dropDraft = DropDraft()
    @Published var echoes: [EchoItem] = []
    @Published var footprints: [FootprintItem] = []
    @Published var isDiscoveringEcho = false
    @Published var currentSOS: SOSRecord?
    @Published var isPro = false

    let echoRepository: EchoRepository
    let footprintRepository: FootprintRepository
    let sosRepository: SOSRepository
    let subscriptionRepository: SubscriptionRepository
    private let activityManager = PickupActivityManager()

    init(
        echoRepository: EchoRepository = MockEchoRepository(),
        footprintRepository: FootprintRepository = MockFootprintRepository(),
        sosRepository: SOSRepository = MockSOSRepository(),
        subscriptionRepository: SubscriptionRepository = MockSubscriptionRepository()
    ) {
        self.echoRepository = echoRepository
        self.footprintRepository = footprintRepository
        self.sosRepository = sosRepository
        self.subscriptionRepository = subscriptionRepository
        refresh()

        if ProcessInfo.processInfo.arguments.contains("--force-main-shell") {
            grantedPermissions = Set(PermissionStep.allCases)
            phase = .main
        }
    }

    var nearbyEchoes: [EchoItem] {
        echoes.filter { $0.distanceMeters <= 500 }
    }

    func onLaunchFinished() {
        phase = grantedPermissions.count == PermissionStep.allCases.count ? .main : .permissions
    }

    func grantCurrentPermission() {
        grantedPermissions.insert(permissionStep)
        if let next = PermissionStep(rawValue: permissionStep.rawValue + 1) {
            permissionStep = next
        } else {
            phase = .main
        }
    }

    func skipPermissions() {
        phase = .main
    }

    func refresh() {
        echoes = echoRepository.allEchoes()
        footprints = footprintRepository.allFootprints()
        isPro = subscriptionRepository.isPro
        isDiscoveringEcho = nearbyEchoes.isEmpty == false
    }

    func submitDrop() {
        echoRepository.addEcho(from: dropDraft)
        Haptics.success()
        dropDraft = DropDraft()
        refresh()
    }

    func markWitnessed(_ id: UUID) {
        guard let echo = echoRepository.find(id: id) else { return }
        echoRepository.markWitnessed(echo)
        footprintRepository.append(from: echo)
        refresh()
    }

    func startSOS() {
        fullScreenRoute = .blackBox
        currentSOS = sosRepository.start()
        Haptics.impact(.heavy)
    }

    func updateSOS(seconds: Int) {
        let progress = min(Double(seconds) / 30.0, 1)
        sosRepository.updateProgress(progress, seconds: seconds)
        currentSOS = sosRepository.current()
    }

    func completeSOS() {
        fullScreenRoute = nil
        guard let completed = sosRepository.finish() else { return }
        sosCompletionKey = completed.recoveryKey
        currentSOS = nil
        Haptics.success()
    }

    func togglePro() {
        subscriptionRepository.isPro.toggle()
        isPro = subscriptionRepository.isPro
    }

    func handleDeepLink(_ url: URL) {
        phase = .main
        switch url.host {
        case "drop": selectedTab = .drop
        case "pickup": selectedTab = .pickup
        case "sos": startSOS()
        default: break
        }
    }

    func startTracking(_ echo: EchoItem) {
        Task {
            await activityManager.stop()
            await activityManager.start(for: echo)
        }
    }

    func updateTracking(distance: Int, title: String) {
        let bars = max(1, min(5, 6 - (distance / 100)))
        Task {
            await activityManager.update(distanceMeters: distance, signalBars: bars, targetTitle: title)
        }
    }

    func stopTracking() {
        Task {
            await activityManager.stop()
        }
    }
}
