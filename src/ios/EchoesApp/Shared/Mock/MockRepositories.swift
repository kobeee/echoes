import Foundation

protocol EchoRepository {
    func allEchoes() -> [EchoItem]
    func addEcho(from draft: DropDraft)
    func markWitnessed(_ echo: EchoItem)
    func find(id: UUID) -> EchoItem?
}

protocol FootprintRepository {
    func allFootprints() -> [FootprintItem]
    func append(from echo: EchoItem)
}

protocol SOSRepository {
    func current() -> SOSRecord?
    func start() -> SOSRecord
    func updateProgress(_ progress: Double, seconds: Int)
    func finish() -> SOSRecord?
}

protocol SubscriptionRepository: AnyObject {
    var isPro: Bool { get set }
}

final class MockEchoRepository: EchoRepository {
    private var echoes: [EchoItem]

    init(now: Date = .now) {
        echoes = [
            EchoItem(
                id: UUID(),
                title: "给未来的信",
                message: "如果你听到这条回响，说明你走到了我们约定的地方。",
                kind: .voice,
                visibility: .public,
                distanceMeters: 250,
                locationName: "三里屯",
                createdAt: now.addingTimeInterval(-3600),
                timeLockDate: nil,
                passcode: nil,
                isWitnessed: false
            ),
            EchoItem(
                id: UUID(),
                title: "语音回响",
                message: "输入口令后即可播放这段语音回响。",
                kind: .voice,
                visibility: .private,
                distanceMeters: 15,
                locationName: "来自匿名旅行者",
                createdAt: now.addingTimeInterval(-3600 * 24 * 3),
                timeLockDate: nil,
                passcode: "1024",
                isWitnessed: false
            ),
            EchoItem(
                id: UUID(),
                title: "加密时间胶囊",
                message: "现在还不能打开。",
                kind: .text,
                visibility: .public,
                distanceMeters: 50,
                locationName: "来自匿名旅行者",
                createdAt: now.addingTimeInterval(-90_000),
                timeLockDate: Calendar.current.date(from: DateComponents(year: 2030, month: 1, day: 1)),
                passcode: nil,
                isWitnessed: false
            )
        ]
    }

    func allEchoes() -> [EchoItem] { echoes.sorted { $0.distanceMeters < $1.distanceMeters } }

    func addEcho(from draft: DropDraft) {
        let new = EchoItem(
            id: UUID(),
            title: draft.title,
            message: draft.isVoiceMode ? "[语音回响]" : draft.text,
            kind: draft.isVoiceMode ? .voice : .text,
            visibility: draft.visibility,
            distanceMeters: 0,
            locationName: "当前位置",
            createdAt: .now,
            timeLockDate: draft.hasTimeLock ? draft.timeLockDate : nil,
            passcode: draft.visibility == .private ? draft.passcode : nil,
            isWitnessed: false
        )
        echoes.insert(new, at: 0)
    }

    func markWitnessed(_ echo: EchoItem) {
        guard let index = echoes.firstIndex(where: { $0.id == echo.id }) else { return }
        echoes[index].isWitnessed = true
    }

    func find(id: UUID) -> EchoItem? {
        echoes.first { $0.id == id }
    }
}

final class MockFootprintRepository: FootprintRepository {
    private var items: [FootprintItem] = []

    func allFootprints() -> [FootprintItem] {
        items.sorted { $0.createdAt > $1.createdAt }
    }

    func append(from echo: EchoItem) {
        let item = FootprintItem(
            id: UUID(),
            echoID: echo.id,
            createdAt: .now,
            locationName: echo.locationName,
            summary: "已阅：\(echo.title)"
        )
        items.insert(item, at: 0)
    }
}

final class MockSOSRepository: SOSRepository {
    private var activeRecord: SOSRecord?

    func current() -> SOSRecord? { activeRecord }

    func start() -> SOSRecord {
        let record = SOSRecord(
            id: UUID(),
            startedAt: .now,
            progress: 0,
            durationSeconds: 0,
            recoveryKey: Self.makeRecoveryKey()
        )
        activeRecord = record
        return record
    }

    func updateProgress(_ progress: Double, seconds: Int) {
        guard var record = activeRecord else { return }
        record.progress = progress
        record.durationSeconds = seconds
        activeRecord = record
    }

    func finish() -> SOSRecord? {
        defer { activeRecord = nil }
        return activeRecord
    }

    private static func makeRecoveryKey() -> String {
        [4, 4, 4, 4]
            .map { _ in String((0..<4).map { _ in "ABCDEFGHJKLMNPQRSTUVWXYZ23456789".randomElement()! }) }
            .joined(separator: "-")
    }
}

final class MockSubscriptionRepository: SubscriptionRepository {
    var isPro: Bool = false
}
