import SwiftUI
import WidgetKit

@main
struct EchoesWidgetsBundle: WidgetBundle {
    var body: some Widget {
        CompassSmallWidget()
        CompassMediumWidget()
        PickupLiveActivityWidget()
    }
}
