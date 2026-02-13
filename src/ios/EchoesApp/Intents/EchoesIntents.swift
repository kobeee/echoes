import AppIntents

private enum EchoesDeepLink {
    static let drop = URL(string: "echoes://drop")!
    static let pickup = URL(string: "echoes://pickup")!
    static let sos = URL(string: "echoes://sos")!
}

struct DropIntent: AppIntent {
    static let title: LocalizedStringResource = "快捷埋藏"
    static let description = IntentDescription("快速进入埋藏页面")

    func perform() async throws -> some IntentResult {
        .result(opensIntent: OpenURLIntent(EchoesDeepLink.drop))
    }
}

struct EmergencyTraceIntent: AppIntent {
    static let title: LocalizedStringResource = "紧急信标"
    static let description = IntentDescription("快速开启黑匣子模式")

    func perform() async throws -> some IntentResult {
        .result(opensIntent: OpenURLIntent(EchoesDeepLink.sos))
    }
}

struct ScanIntent: AppIntent {
    static let title: LocalizedStringResource = "雷达扫描"
    static let description = IntentDescription("查看附近回响")

    func perform() async throws -> some IntentResult {
        .result(opensIntent: OpenURLIntent(EchoesDeepLink.pickup))
    }
}

struct EchoesShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: DropIntent(),
            phrases: ["在 \(.applicationName) 留个话"],
            shortTitle: "快捷埋藏",
            systemImageName: "mic.fill"
        )

        AppShortcut(
            intent: EmergencyTraceIntent(),
            phrases: ["在 \(.applicationName) 开启黑匣子"],
            shortTitle: "紧急信标",
            systemImageName: "exclamationmark.triangle.fill"
        )

        AppShortcut(
            intent: ScanIntent(),
            phrases: ["用 \(.applicationName) 扫描附近回响"],
            shortTitle: "雷达扫描",
            systemImageName: "location.north"
        )
    }
}
