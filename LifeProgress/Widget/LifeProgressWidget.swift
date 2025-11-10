import WidgetKit
import SwiftUI

// MARK: - Widget Entry
/// Widget数据条目
struct LifeProgressEntry: TimelineEntry {
    let date: Date
    let widgetData: WidgetData

    /// 从DataManager加载数据
    static func loadFromDataManager() -> LifeProgressEntry {
        let dataManager = DataManager.shared

        if let userData = dataManager.loadUserData() {
            let lifeProgress = LifeProgress.calculate(from: userData)
            let widgetData = WidgetData(
                progressPercentage: lifeProgress.progressPercentage,
                passedDays: lifeProgress.passedDays,
                totalDays: lifeProgress.totalDays,
                remainingDays: lifeProgress.remainingDays,
                displayName: userData.displayName,
                theme: userData.theme
            )
            return LifeProgressEntry(date: Date(), widgetData: widgetData)
        } else {
            // 默认数据
            let defaultData = UserLifeData()
            let lifeProgress = LifeProgress.calculate(from: defaultData)
            let widgetData = WidgetData(
                progressPercentage: lifeProgress.progressPercentage,
                passedDays: lifeProgress.passedDays,
                totalDays: lifeProgress.totalDays,
                remainingDays: lifeProgress.remainingDays,
                displayName: defaultData.displayName,
                theme: defaultData.theme
            )
            return LifeProgressEntry(date: Date(), widgetData: widgetData)
        }
    }
}

// MARK: - Timeline Provider
/// Widget时间线提供者
struct LifeProgressProvider: TimelineProvider {
    func placeholder(in context: Context) -> LifeProgressEntry {
        return LifeProgressEntry.loadFromDataManager()
    }

    func getSnapshot(in context: Context, completion: @escaping (LifeProgressEntry) -> Void) {
        let entry = LifeProgressEntry.loadFromDataManager()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LifeProgressEntry>) -> Void) {
        let entry = LifeProgressEntry.loadFromDataManager()

        // 设置下次刷新时间为明天午夜
        let nextUpdate = DateCalculator.nextMidnight()

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Widget Entry View
/// Widget入口视图，根据family选择不同的widget样式
struct LifeProgressWidgetEntryView: View {
    var entry: LifeProgressEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        @unknown default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Widget Configuration
/// Widget主配置
@main
struct LifeProgressWidget: Widget {
    let kind: String = "LifeProgressWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LifeProgressProvider()) { entry in
            LifeProgressWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("人生进度")
        .description("查看你的人生进度和日历")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Widget Preview
struct LifeProgressWidget_Previews: PreviewProvider {
    static var previews: some View {
        let entry = LifeProgressEntry.loadFromDataManager()

        Group {
            LifeProgressWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            LifeProgressWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            LifeProgressWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
