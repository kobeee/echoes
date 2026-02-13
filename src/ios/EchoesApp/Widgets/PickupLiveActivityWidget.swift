import ActivityKit
import SwiftUI
import WidgetKit

struct PickupLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PickupTrackingAttributes.self) { context in
            HStack(spacing: 12) {
                ZStack {
                    Circle().stroke(EchoesColor.teal.opacity(0.3), lineWidth: 1).frame(width: 62, height: 62)
                    Circle().stroke(EchoesColor.teal.opacity(0.2), lineWidth: 1).frame(width: 38, height: 38)
                    Circle().fill(EchoesColor.teal).frame(width: 7, height: 7)
                    Circle().fill(EchoesColor.gold).frame(width: 6, height: 6).offset(x: 11, y: -8)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("正在追踪")
                        .font(.system(size: 12))
                        .foregroundStyle(EchoesColor.textSecondary)
                    Text("🎧 \(context.state.targetTitle)")
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)
                        .foregroundStyle(EchoesColor.textPrimary)
                    HStack(spacing: 8) {
                        Text("\(context.state.distanceMeters)m")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundStyle(context.state.distanceMeters <= 5 ? EchoesColor.goldSoft : EchoesColor.teal)
                        SignalBarsView(level: context.state.signalBars)
                    }
                }

                Spacer()

                Text("打开 App 查看 →")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(EchoesColor.gold)
            }
            .overlay(alignment: .topLeading) {
                Label("Echoes", systemImage: "circle.circle.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(EchoesColor.gold)
                    .padding(.top, -8)
            }
            .padding(.top, 10)
            .padding(.horizontal, 2)
            .activityBackgroundTint(EchoesColor.bgPrimary)
            .activitySystemActionForegroundColor(EchoesColor.gold)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label("追踪", systemImage: "location.north.fill")
                        .foregroundStyle(EchoesColor.gold)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.distanceMeters)m")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(EchoesColor.teal)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        SignalBarsView(level: context.state.signalBars)
                        Spacer()
                        Text(context.state.targetTitle)
                            .font(.system(size: 12))
                            .lineLimit(1)
                    }
                }
            } compactLeading: {
                Image(systemName: "dot.radiowaves.left.and.right")
                    .foregroundStyle(EchoesColor.gold)
            } compactTrailing: {
                Text("\(context.state.distanceMeters)m")
                    .foregroundStyle(EchoesColor.teal)
            } minimal: {
                Circle()
                    .fill(EchoesColor.gold)
                    .frame(width: 12, height: 12)
            }
            .widgetURL(URL(string: "echoes://pickup"))
            .keylineTint(EchoesColor.gold)
        }
    }
}
