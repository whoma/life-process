import SwiftUI
import WidgetKit

// MARK: - 小组件视图
/// 显示人生总进度的小组件
struct SmallWidgetView: View {
    let entry: LifeProgressEntry

    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                gradient: Gradient(colors: [
                    entry.widgetData.theme.gradientStartColor,
                    entry.widgetData.theme.gradientEndColor
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 8) {
                // 图标
                Image(systemName: "hourglass")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.9))

                Spacer()

                // 百分比（大号）
                Text(entry.widgetData.formattedPercentage)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

                // 简单进度条
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // 背景
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 6)
                            .cornerRadius(3)

                        // 进度
                        Rectangle()
                            .fill(Color.white)
                            .frame(
                                width: geometry.size.width * CGFloat(entry.widgetData.progressPercentage / 100.0),
                                height: 6
                            )
                            .cornerRadius(3)
                    }
                }
                .frame(height: 6)

                Spacer()

                // 已过天数
                Text("已过 \(entry.widgetData.formattedPassedDays) 天")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
            .padding(16)
        }
    }
}

// MARK: - Preview
struct SmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let entry = LifeProgressEntry.loadFromDataManager()

        SmallWidgetView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
