import SwiftUI

// MARK: - 格子视图
/// 显示人生日历，每个格子代表一天
struct GridView: View {
    @ObservedObject var viewModel: LifeProgressViewModel

    // MARK: - State
    @State private var selectedDay: Int?

    // MARK: - Body

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 头部信息
                    headerSection

                    // 格子网格
                    gridSection

                    // 底部统计
                    statsSection
                }
                .padding()
            }
            .background(Color.background)
            .navigationTitle("人生日历")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 12) {
            // 总进度
            Text(viewModel.formattedProgressPercentage)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.blue)

            // 年龄信息
            Text(viewModel.detailedAge)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.secondaryText)

            // 格子说明
            HStack(spacing: 20) {
                legendItem(color: viewModel.userData.theme.passedSwiftUIColor, text: "已过")
                legendItem(color: viewModel.userData.theme.futureSwiftUIColor, text: "未来")
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(Constants.cornerRadius)
    }

    // MARK: - Grid Section

    private var gridSection: some View {
        let columns = Array(repeating: GridItem(.fixed(Constants.gridCellSize), spacing: Constants.gridSpacing), count: 52)

        return LazyVGrid(columns: columns, spacing: Constants.gridSpacing) {
            ForEach(0..<viewModel.lifeProgress.totalDays, id: \.self) { day in
                gridCell(for: day)
            }
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(Constants.cornerRadius)
    }

    // MARK: - Stats Section

    private var statsSection: some View {
        VStack(spacing: 16) {
            statRow(title: "已过天数", value: viewModel.formattedPassedDays, color: .blue)
            statRow(title: "剩余天数", value: viewModel.formattedRemainingDays, color: .orange)
            statRow(title: "总天数", value: viewModel.formattedTotalDays, color: .gray)
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(Constants.cornerRadius)
    }

    // MARK: - Helper Views

    /// 单个格子
    private func gridCell(for day: Int) -> some View {
        let isPassed = day < viewModel.lifeProgress.passedDays
        let isToday = day == viewModel.lifeProgress.passedDays

        return Rectangle()
            .fill(isPassed ? viewModel.userData.theme.passedSwiftUIColor : viewModel.userData.theme.futureSwiftUIColor)
            .frame(width: Constants.gridCellSize, height: Constants.gridCellSize)
            .cornerRadius(2)
            .overlay(
                // 今天的特殊标记
                isToday ? Circle()
                    .stroke(Color.red, lineWidth: 2)
                    .scaleEffect(1.2)
                : nil
            )
            .onTapGesture {
                selectedDay = day
                // 添加触觉反馈
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
    }

    /// 图例项
    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 6) {
            Rectangle()
                .fill(color)
                .frame(width: 16, height: 16)
                .cornerRadius(3)

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.secondaryText)
        }
    }

    /// 统计行
    private func statRow(title: String, value: String, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.secondaryText)

            Spacer()

            Text(value)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
        }
    }
}

// MARK: - Preview
struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(viewModel: LifeProgressViewModel())
    }
}
