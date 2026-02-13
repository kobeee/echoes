import ActivityKit

struct PickupTrackingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var distanceMeters: Int
        var signalBars: Int
        var targetTitle: String
    }

    var echoID: String
}
