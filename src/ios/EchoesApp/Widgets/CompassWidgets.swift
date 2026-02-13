import SwiftUI
import WidgetKit

struct CompassEntry: TimelineEntry {
    let date: Date
    let distance: Int
    let label: String
    let signalLevel: Int
}

struct CompassProvider: TimelineProvider {
    func placeholder(in context: Context) -> CompassEntry {
        CompassEntry(date: .now, distance: 250, label: "给未来的信", signalLevel: 3)
    }

    func getSnapshot(in context: Context, completion: @escaping (CompassEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CompassEntry>) -> Void) {
        let entry = CompassEntry(date: .now, distance: 250, label: "给未来的信", signalLevel: 3)
        completion(Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(900))))
    }
}

struct CompassSmallWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "CompassSmallWidget", provider: CompassProvider()) { entry in
            VStack(alignment: .leading, spacing: 2) {
                Label("回响", systemImage: "bookmark.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(EchoesColor.textPrimary)
                Text("距离上次")
                    .font(.system(size: 11))
                    .foregroundStyle(EchoesColor.textSecondary)
                Text("埋下的给未来的信")
                    .font(.system(size: 11))
                    .foregroundStyle(EchoesColor.textSecondary)
                HStack(alignment: .bottom) {
                    Text("3 km")
                        .font(.system(size: 48, weight: .bold))
                        .minimumScaleFactor(0.4)
                        .foregroundStyle(EchoesColor.gold)
                    Spacer()
                    Button(intent: DropIntent()) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .frame(width: 34, height: 34)
                            .background(EchoesColor.gold)
                            .clipShape(Circle())
                            .foregroundStyle(Color.black.opacity(0.85))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(12)
            .containerBackground(EchoesColor.bgSecondary, for: .widget)
        }
        .configurationDisplayName("The Compass")
        .description("快速查看最近回响距离")
        .supportedFamilies([.systemSmall])
    }
}

struct CompassMediumWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "CompassMediumWidget", provider: CompassProvider()) { entry in
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous)
                    .fill(Color.black.opacity(0.35))
                    .frame(width: 116, height: 116)
                    .overlay {
                        ZStack {
                            Circle().stroke(EchoesColor.teal.opacity(0.25), lineWidth: 1).frame(width: 100, height: 100)
                            Circle().stroke(EchoesColor.teal.opacity(0.18), lineWidth: 1).frame(width: 56, height: 56)
                            Circle().fill(EchoesColor.teal).frame(width: 8, height: 8)
                            Circle().fill(EchoesColor.gold).frame(width: 7, height: 7).offset(x: 17, y: -11)
                        }
                    }

                VStack(alignment: .leading, spacing: 8) {
                    Text("距离最近的回响")
                    .font(.system(size: 13))
                    .foregroundStyle(EchoesColor.textSecondary)
                    Text("\(entry.distance) m")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(EchoesColor.textPrimary)
                    SignalBarsView(level: entry.signalLevel)
                    Button(intent: ScanIntent()) {
                        Text("点击开始寻宝 →")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(EchoesColor.gold)
                }
                Spacer()
            }
            .padding(16)
            .containerBackground(EchoesColor.bgSecondary, for: .widget)
        }
        .configurationDisplayName("The Compass Medium")
        .description("查看附近回响和信号强度")
        .supportedFamilies([.systemMedium])
    }
}
