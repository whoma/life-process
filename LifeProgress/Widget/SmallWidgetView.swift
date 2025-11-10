import SwiftUI
import WidgetKit

// MARK: - 小组件视图
/// 显示人生总进度的小组件 - 极简块状设计
struct SmallWidgetView: View {
    let entry: LifeProgressEntry

    // 块状进度条配置
    private let totalBlocks = 20  // 总块数
    private let blockSize: CGFloat = 5
    private let blockSpacing: CGFloat = 2

    var body: some View {
        ZStack {
            // 背景色
            Color.background

            VStack(spacing: 16) {
                Spacer()

                // 块状进度条
                blockProgressBar

                Spacer()

                // 百分比（大号居中）
                Text(entry.widgetData.formattedPercentage)
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(entry.widgetData.theme.gradientStartColor)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)

                Spacer()

                // 底部说明
                Text("已过 \(entry.widgetData.formattedPassedDays) 天")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondaryText)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }
            .padding(16)
        }
    }

    // MARK: - 块状进度条
    private var blockProgressBar: some View {
        let filledBlocks = Int((entry.widgetData.progressPercentage / 100.0) * Double(totalBlocks))

        return HStack(spacing: blockSpacing) {
            ForEach(0..<totalBlocks, id: \.self) { index in
                Rectangle()
                    .fill(index < filledBlocks ?
                          entry.widgetData.theme.passedSwiftUIColor :
                          entry.widgetData.theme.futureSwiftUIColor)
                    .frame(width: blockSize, height: blockSize)
                    .cornerRadius(1)
            }
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
