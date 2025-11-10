import SwiftUI

// MARK: - 引导页面视图
/// 首次启动时的配置页面，只需要设置出生日期
struct OnboardingView: View {
    @ObservedObject var viewModel: LifeProgressViewModel

    // MARK: - State

    @State private var selectedDate = Date()
    @State private var showingDatePicker = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                // 背景
                Color.background
                    .ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer()

                    // 标题区域
                    VStack(spacing: 16) {
                        Image(systemName: "hourglass")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)

                        Text("Life Progress")
                            .font(.system(size: 36, weight: .bold))

                        Text("让时间可视化")
                            .font(.system(size: 18))
                            .foregroundColor(.secondaryText)
                    }

                    Spacer()

                    // 设置区域
                    VStack(spacing: 24) {
                        // 出生日期选择
                        VStack(alignment: .leading, spacing: 12) {
                            Text("你的出生日期")
                                .font(.headline)
                                .foregroundColor(.primaryText)

                            Button(action: {
                                showingDatePicker = true
                            }) {
                                HStack {
                                    Text(selectedDate.formatted("yyyy年MM月dd日"))
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.primary)

                                    Spacer()

                                    Image(systemName: "calendar")
                                        .foregroundColor(.blue)
                                }
                                .padding()
                                .background(Color.secondaryBackground)
                                .cornerRadius(Constants.cornerRadius)
                            }
                        }

                        // 说明文字
                        Text("我们将根据你的出生日期\n计算你的人生进度")
                            .font(.system(size: 14))
                            .foregroundColor(.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)

                    Spacer()

                    // 开始按钮
                    Button(action: startApp) {
                        Text("开始")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .cornerRadius(Constants.cornerRadius)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePickerSheet(selectedDate: $selectedDate)
            }
        }
    }

    // MARK: - Actions

    /// 开始使用应用
    private func startApp() {
        // 验证日期
        guard DateCalculator.isValidBirthDate(selectedDate) else {
            print("❌ 无效的出生日期")
            return
        }

        // 更新数据
        viewModel.updateBirthDate(selectedDate)
        viewModel.completeOnboarding()

        // 添加触觉反馈
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// MARK: - 日期选择器弹窗
struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "选择出生日期",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()

                Spacer()
            }
            .navigationTitle("选择出生日期")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: LifeProgressViewModel())
    }
}
