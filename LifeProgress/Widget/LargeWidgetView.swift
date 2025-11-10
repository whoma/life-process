import SwiftUI
import WidgetKit

// MARK: - 大组件视图
/// 显示完整格子日历的大尺寸组件
struct LargeWidgetView: View {
    let entry: LifeProgressEntry

    // 显示更多周数
    private let columns = 7
    private let cellSize: CGFloat = 5
    private let spacing: CGFloat = 1.5

    var body: some View {
        ZStack {
            Color.background

            VStack(spacing: 12) {
                // 头部信息
                headerSection

                // 格子网格
                gridView
                    .padding(.horizontal, 12)

                // 底部统计
                statsSection
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("人生日历")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)

                Text(entry.widgetData.formattedPercentage)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(entry.widgetData.theme.gradientStartColor)
            }

            Spacer()

            // 图例
            VStack(alignment: .trailing, spacing: 6) {
                legendItem(color: entry.widgetData.theme.passedSwiftUIColor, text: "已过")
                legendItem(color: entry.widgetData.theme.futureSwiftUIColor, text: "未来")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    // MARK: - Grid View

    private var gridView: some View {
        // 显示最近一年半：前270天到后270天（共540天，约77周）
        // 移除ScrollView以兼容iOS 16，格子会自适应大小
        let daysToShow = 540
        let totalWeeks = min((daysToShow + 6) / 7, 30) // 最多显示30周，防止溢出

        return GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let totalSpacing = CGFloat(columns - 1) * spacing
            let calculatedCellSize = min(cellSize, (availableWidth - totalSpacing) / CGFloat(columns))

            VStack(spacing: spacing) {
                ForEach(0..<totalWeeks, id: \.self) { week in
                    HStack(spacing: spacing) {
                        ForEach(0..<columns, id: \.self) { day in
                            let dayIndex = week * columns + day
                            if dayIndex < (totalWeeks * columns) {
                                gridCell(for: dayIndex, size: calculatedCellSize)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Stats Section

    private var statsSection: some View {
        HStack(spacing: 20) {
            statItem(
                title: "已过",
                value: entry.widgetData.formattedPassedDays,
                color: entry.widgetData.theme.gradientStartColor
            )

            Divider()
                .frame(height: 30)

            statItem(
                title: "剩余",
                value: "\(DateCalculator.formatNumber(entry.widgetData.remainingDays))",
                color: .orange
            )

            Divider()
                .frame(height: 30)

            statItem(
                title: "总计",
                value: entry.widgetData.formattedTotalDays,
                color: .gray
            )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.secondaryBackground)
        .cornerRadius(10)
    }

    // MARK: - Helper Views

    /// 单个格子
    private func gridCell(for dayIndex: Int, size: CGFloat) -> some View {
        // 显示最近一年半：从今天往前105天到往后105天（共30周=210天）
        let totalDaysToShow = 210
        let centerIndex = totalDaysToShow / 2
        let daysFromToday = dayIndex - centerIndex
        let actualDay = entry.widgetData.passedDays + daysFromToday
        let isPassed = actualDay >= 0 && actualDay <= entry.widgetData.passedDays
        let isToday = daysFromToday == 0

        return Rectangle()
            .fill(isPassed ? entry.widgetData.theme.passedSwiftUIColor : entry.widgetData.theme.futureSwiftUIColor)
            .frame(width: size, height: size)
            .cornerRadius(1)
            .overlay(
                // 今天的标记
                isToday ? Circle()
                    .stroke(Color.red, lineWidth: 1.5)
                    .scaleEffect(1.3)
                : nil
            )
    }

    /// 图例项
    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 4) {
            Rectangle()
                .fill(color)
                .frame(width: 12, height: 12)
                .cornerRadius(2)

            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.secondaryText)
        }
    }

    /// 统计项
    private func statItem(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
                .minimumScaleFactor(0.8)
                .lineLimit(1)

            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
struct LargeWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let entry = LifeProgressEntry.loadFromDataManager()

        LargeWidgetView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
