import Foundation
import SwiftUI
import Combine

// MARK: - 生命进度视图模型
/// 管理应用的状态和数据，提供数据绑定和业务逻辑
class LifeProgressViewModel: ObservableObject {

    // MARK: - Published Properties

    /// 用户数据
    @Published var userData: UserLifeData

    /// 生命进度
    @Published var lifeProgress: LifeProgress

    /// 日常进度
    @Published var dailyProgress: DailyProgress

    /// 是否已完成引导
    @Published var isOnboardingCompleted: Bool

    /// 是否显示设置页面
    @Published var showingSettings = false

    // MARK: - Private Properties

    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init() {
        // 加载或创建默认数据
        if let savedUserData = dataManager.loadUserData() {
            self.userData = savedUserData
            self.lifeProgress = LifeProgress.calculate(from: savedUserData)
        } else {
            // 创建默认数据
            self.userData = UserLifeData()
            self.lifeProgress = LifeProgress.calculate(from: self.userData)
        }

        self.dailyProgress = DailyProgress.calculate()
        self.isOnboardingCompleted = dataManager.isOnboardingCompleted()

        // 设置定时器，每分钟更新一次进度
        setupTimer()
    }

    // MARK: - Public Methods

    /// 保存用户数据
    func saveUserData() {
        dataManager.saveUserData(userData)
        refreshProgress()
        print("✅ 数据已保存")
    }

    /// 完成引导流程
    func completeOnboarding() {
        dataManager.setOnboardingCompleted(true)
        isOnboardingCompleted = true
        saveUserData()
        print("✅ 引导完成")
    }

    /// 更新出生日期
    func updateBirthDate(_ date: Date) {
        userData.birthDate = date
        saveUserData()
    }

    /// 更新预期寿命
    func updateLifeExpectancy(_ years: Int) {
        userData.lifeExpectancy = years
        saveUserData()
    }

    /// 刷新所有进度数据
    func refreshProgress() {
        lifeProgress = LifeProgress.calculate(from: userData)
        dailyProgress = DailyProgress.calculate()
        print("🔄 进度已刷新")
    }

    /// 重置应用（用于测试）
    func resetApp() {
        dataManager.resetAllData()
        userData = UserLifeData()
        lifeProgress = LifeProgress.calculate(from: userData)
        dailyProgress = DailyProgress.calculate()
        isOnboardingCompleted = false
        print("🔄 应用已重置")
    }

    // MARK: - Private Methods

    /// 设置定时器，定期更新进度
    private func setupTimer() {
        // 每分钟更新一次今日进度
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.refreshProgress()
            }
            .store(in: &cancellables)
    }

    // MARK: - Computed Properties

    /// 格式化的进度百分比
    var formattedProgressPercentage: String {
        return DateCalculator.formatPercentage(lifeProgress.progressPercentage, decimals: 2)
    }

    /// 格式化的已过天数
    var formattedPassedDays: String {
        return DateCalculator.formatNumber(lifeProgress.passedDays)
    }

    /// 格式化的总天数
    var formattedTotalDays: String {
        return DateCalculator.formatNumber(lifeProgress.totalDays)
    }

    /// 格式化的剩余天数
    var formattedRemainingDays: String {
        return DateCalculator.formatNumber(lifeProgress.remainingDays)
    }

    /// 当前年龄
    var currentAge: Int {
        return DateCalculator.calculateAge(from: userData.birthDate)
    }

    /// 详细年龄
    var detailedAge: String {
        return DateCalculator.calculateDetailedAge(from: userData.birthDate)
    }
}

// MARK: - Widget数据提供
extension LifeProgressViewModel {
    /// 获取Widget需要的数据快照
    func getWidgetData() -> WidgetData {
        return WidgetData(
            progressPercentage: lifeProgress.progressPercentage,
            passedDays: lifeProgress.passedDays,
            totalDays: lifeProgress.totalDays,
            remainingDays: lifeProgress.remainingDays,
            displayName: userData.displayName,
            theme: userData.theme
        )
    }
}

// MARK: - Widget数据模型
struct WidgetData: Codable {
    let progressPercentage: Double
    let passedDays: Int
    let totalDays: Int
    let remainingDays: Int
    let displayName: String
    let theme: ThemeType

    /// 格式化的百分比
    var formattedPercentage: String {
        return DateCalculator.formatPercentage(progressPercentage, decimals: 1)
    }

    /// 格式化的已过天数
    var formattedPassedDays: String {
        return DateCalculator.formatNumber(passedDays)
    }

    /// 格式化的总天数
    var formattedTotalDays: String {
        return DateCalculator.formatNumber(totalDays)
    }
}
