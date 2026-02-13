import Foundation

enum EchoContentKind: String, Codable, CaseIterable {
    case voice
    case text
    case video
}

enum EchoVisibility: String, Codable, CaseIterable {
    case `public`
    case `private`
}

struct EchoItem: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var message: String
    var kind: EchoContentKind
    var visibility: EchoVisibility
    var distanceMeters: Int
    var locationName: String
    var createdAt: Date
    var timeLockDate: Date?
    var passcode: String?
    var isWitnessed: Bool

    var isTimeLocked: Bool {
        guard let timeLockDate else { return false }
        return timeLockDate > Date()
    }
}

struct FootprintItem: Identifiable, Hashable, Codable {
    let id: UUID
    let echoID: UUID
    let createdAt: Date
    let locationName: String
    let summary: String
}

struct SOSRecord: Identifiable, Hashable, Codable {
    let id: UUID
    let startedAt: Date
    var progress: Double
    var durationSeconds: Int
    let recoveryKey: String
}

struct DropDraft: Hashable {
    var title: String = "给未来的信"
    var text: String = ""
    var isVoiceMode = true
    var visibility: EchoVisibility = .public
    var passcode: String = ""
    var hasTimeLock = false
    var timeLockDate: Date = .now.addingTimeInterval(3600 * 24 * 365)
}

enum AppTab: String, CaseIterable, Hashable {
    case map
    case drop
    case pickup
    case footprints
    case settings

    var title: String {
        switch self {
        case .map: return "首页"
        case .drop: return "埋藏"
        case .pickup: return "地图"
        case .footprints: return "足迹"
        case .settings: return "设置"
        }
    }

    var systemImage: String {
        switch self {
        case .map: return "house"
        case .drop: return "plus"
        case .pickup: return "map"
        case .footprints: return "figure.walk"
        case .settings: return "gearshape"
        }
    }
}

enum AppPhase: Hashable {
    case launch
    case permissions
    case main
}

enum PermissionStep: Int, CaseIterable {
    case location
    case microphone
    case notifications
}
