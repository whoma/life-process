import SwiftUI

// MARK: - 设置视图
/// 应用设置页面
struct SettingsView: View {
    @ObservedObject var viewModel: LifeProgressViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var showingDatePicker = false
    @State private var showingResetAlert = false

    var body: some View {
        NavigationView {
            Form {
                // 基本信息
                Section("基本信息") {
                    // 出生日期
                    Button(action: {
                        showingDatePicker = true
                    }) {
                        HStack {
                            Text("出生日期")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(viewModel.userData.birthDate.formatted("yyyy年MM月dd日"))
                                .foregroundColor(.secondaryText)
                        }
                    }

                    // 当前年龄
                    HStack {
                        Text("当前年龄")
                        Spacer()
                        Text(viewModel.detailedAge)
                            .foregroundColor(.secondaryText)
                    }

                    // 预期寿命
                    HStack {
                        Text("预期寿命")
                        Spacer()
                        Text("\(viewModel.userData.lifeExpectancy) 岁")
                            .foregroundColor(.secondaryText)
                    }
                }

                // 进度统计
                Section("进度统计") {
                    HStack {
                        Text("人生进度")
                        Spacer()
                        Text(viewModel.formattedProgressPercentage)
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }

                    HStack {
                        Text("已过天数")
                        Spacer()
                        Text(viewModel.formattedPassedDays)
                            .foregroundColor(.secondaryText)
                    }

                    HStack {
                        Text("剩余天数")
                        Spacer()
                        Text(viewModel.formattedRemainingDays)
                            .foregroundColor(.orange)
                            .fontWeight(.semibold)
                    }
                }

                // 关于
                Section("关于") {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondaryText)
                    }

                    Link(destination: URL(string: "https://github.com")!) {
                        HStack {
                            Text("GitHub")
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .font(.system(size: 12))
                        }
                    }
                }

                // 危险区域
                Section("数据管理") {
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("重置所有数据")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePickerSheet(selectedDate: $viewModel.userData.birthDate)
                    .onDisappear {
                        viewModel.saveUserData()
                    }
            }
            .alert("重置数据", isPresented: $showingResetAlert) {
                Button("取消", role: .cancel) { }
                Button("重置", role: .destructive) {
                    viewModel.resetApp()
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("这将删除所有数据并重新开始。此操作无法撤销。")
            }
        }
    }
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: LifeProgressViewModel())
    }
}
