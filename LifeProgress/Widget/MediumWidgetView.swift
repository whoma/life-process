import SwiftUI
import WidgetKit

// MARK: - 中组件视图
/// 显示简化格子日历的中等尺寸组件
struct MediumWidgetView: View {
    let entry: LifeProgressEntry

    // 每周7天，显示52周（一年）
    private let columns = 7
    private let rows = 52
    private let cellSize: CGFloat = 4.5
    private let spacing: CGFloat = 1.5

    var body: some View {
        ZStack {
            Color.background

            VStack(spacing: 12) {
                // 头部信息
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("人生进度")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)

                        Text(entry.widgetData.formattedPercentage)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(entry.widgetData.theme.gradientStartColor)
                    }

                    Spacer()

                    // 图例
                    VStack(alignment: .trailing, spacing: 4) {
                        legendItem(color: entry.widgetData.theme.passedSwiftUIColor, text: "已过")
                        legendItem(color: entry.widgetData.theme.futureSwiftUIColor, text: "未来")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

                // 格子网格（显示最近一年）
                gridView
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
            }
        }
    }

    // MARK: - Grid View

    private var gridView: some View {
        // 显示365天
        let daysToShow = 365
        let totalWeeks = (daysToShow + 6) / 7 // 向上取整

        return GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let totalSpacing = CGFloat(columns - 1) * spacing
            let calculatedCellSize = min(cellSize, (availableWidth - totalSpacing) / CGFloat(columns))

            VStack(spacing: spacing) {
                ForEach(0..<totalWeeks, id: \.self) { week in
                    HStack(spacing: spacing) {
                        ForEach(0..<columns, id: \.self) { day in
                            let dayIndex = week * columns + day
                            if dayIndex < daysToShow {
                                gridCell(for: dayIndex, size: calculatedCellSize)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Helper Views

    /// 单个格子
    private func gridCell(for dayIndex: Int, size: CGFloat) -> some View {
        // 计算从出生开始的实际天数
        let actualDay = entry.widgetData.passedDays - (365 - dayIndex)
        let isPassed = actualDay >= 0 && actualDay < entry.widgetData.passedDays

        return Rectangle()
            .fill(isPassed ? entry.widgetData.theme.passedSwiftUIColor : entry.widgetData.theme.futureSwiftUIColor)
            .frame(width: size, height: size)
            .cornerRadius(1)
    }

    /// 图例项
    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 4) {
            Rectangle()
                .fill(color)
                .frame(width: 10, height: 10)
                .cornerRadius(2)

            Text(text)
                .font(.system(size: 10))
                .foregroundColor(.secondaryText)
        }
    }
}

// MARK: - Preview
struct MediumWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let entry = LifeProgressEntry.loadFromDataManager()

        MediumWidgetView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
