import ActivityKit
import Foundation

struct PickupActivityManager {
    func start(for echo: EchoItem) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let attributes = PickupTrackingAttributes(echoID: echo.id.uuidString)
        let state = PickupTrackingAttributes.ContentState(
            distanceMeters: echo.distanceMeters,
            signalBars: 3,
            targetTitle: echo.title
        )
        _ = try? Activity.request(attributes: attributes, content: .init(state: state, staleDate: nil))
    }

    func update(distanceMeters: Int, signalBars: Int, targetTitle: String) async {
        let state = PickupTrackingAttributes.ContentState(
            distanceMeters: distanceMeters,
            signalBars: signalBars,
            targetTitle: targetTitle
        )
        for activity in Activity<PickupTrackingAttributes>.activities {
            await activity.update(.init(state: state, staleDate: nil))
        }
    }

    func stop() async {
        for activity in Activity<PickupTrackingAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}
