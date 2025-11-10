import SwiftUI

// MARK: - 进度条视图
/// 显示多维度的时间进度（今日/本周/本月/本年/人生）
struct ProgressView: View {
    @ObservedObject var viewModel: LifeProgressViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 人生总进度（大号显示）
                    lifeProgressSection

                    // 分隔线
                    Divider()
                        .padding(.vertical, 8)

                    // 各个维度的进度
                    VStack(spacing: 16) {
                        progressCard(
                            title: "今日进度",
                            percentage: viewModel.dailyProgress.todayProgress,
                            remaining: "剩余 \(DateCalculator.calculateTodayRemainingHours()) 小时",
                            icon: "sun.max.fill",
                            color: .orange
                        )

                        progressCard(
                            title: "本周进度",
                            percentage: viewModel.dailyProgress.weekProgress,
                            remaining: "剩余 \(DateCalculator.calculateWeekRemainingDays()) 天",
                            icon: "calendar.badge.clock",
                            color: .green
                        )

                        progressCard(
                            title: "本月进度",
                            percentage: viewModel.dailyProgress.monthProgress,
                            remaining: "剩余 \(DateCalculator.calculateMonthRemainingDays()) 天",
                            icon: "calendar",
                            color: .blue
                        )

                        progressCard(
                            title: "本年进度",
                            percentage: viewModel.dailyProgress.yearProgress,
                            remaining: "剩余 \(DateCalculator.calculateYearRemainingDays()) 天",
                            icon: "calendar.circle.fill",
                            color: .purple
                        )
                    }
                }
                .padding()
            }
            .background(Color.background)
            .navigationTitle("时间进度")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.refreshProgress()
            }
        }
    }

    // MARK: - Life Progress Section

    private var lifeProgressSection: some View {
        VStack(spacing: 16) {
            // 图标
            Image(systemName: "hourglass")
                .font(.system(size: 48))
                .foregroundColor(.blue)

            // 百分比
            Text(viewModel.formattedProgressPercentage)
                .font(.system(size: 56, weight: .bold))
                .foregroundColor(.blue)

            // 进度条
            ProgressBarView(
                progress: viewModel.lifeProgress.progressPercentage / 100.0,
                color: viewModel.userData.theme.gradientStartColor
            )
            .frame(height: 32)

            // 统计信息
            HStack(spacing: 40) {
                VStack(spacing: 4) {
                    Text(viewModel.formattedPassedDays)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)

                    Text("已过天数")
                        .font(.system(size: 12))
                        .foregroundColor(.secondaryText)
                }

                VStack(spacing: 4) {
                    Text(viewModel.formattedRemainingDays)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.orange)

                    Text("剩余天数")
                        .font(.system(size: 12))
                        .foregroundColor(.secondaryText)
                }
            }

            // 年龄信息
            Text(viewModel.detailedAge)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondaryText)
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(Constants.cornerRadius)
    }

    // MARK: - Progress Card

    private func progressCard(
        title: String,
        percentage: Double,
        remaining: String,
        icon: String,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // 标题和图标
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)

                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)

                Spacer()

                Text(DateCalculator.formatPercentage(percentage, decimals: 1))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color)
            }

            // 进度条
            ProgressBarView(
                progress: percentage / 100.0,
                color: color
            )
            .frame(height: Constants.progressBarHeight)

            // 剩余信息
            Text(remaining)
                .font(.system(size: 14))
                .foregroundColor(.secondaryText)
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(Constants.cornerRadius)
    }
}

// MARK: - 进度条组件
struct ProgressBarView: View {
    let progress: Double
    let color: Color

    @State private var animatedProgress: Double = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 背景
                Rectangle()
                    .fill(Color.progressBackground)
                    .cornerRadius(Constants.cornerRadius / 2)

                // 进度
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(animatedProgress))
                    .cornerRadius(Constants.cornerRadius / 2)
                    .animation(.easeInOut(duration: Constants.progressFillDuration), value: animatedProgress)
            }
        }
        .onAppear {
            animatedProgress = min(1.0, max(0.0, progress))
        }
        .onChange(of: progress) { newValue in
            animatedProgress = min(1.0, max(0.0, newValue))
        }
    }
}

// MARK: - Preview
struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(viewModel: LifeProgressViewModel())
    }
}
