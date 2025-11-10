import Foundation

// MARK: - 数据管理器
/// 负责数据的持久化存储和读取，支持App Group共享
class DataManager {
    // MARK: - Singleton
    static let shared = DataManager()

    // MARK: - Properties
    /// 共享的UserDefaults（用于App和Widget之间共享数据）
    private let sharedDefaults: UserDefaults?

    /// 标准UserDefaults（备用）
    private let standardDefaults = UserDefaults.standard

    // MARK: - Initialization
    private init() {
        // 初始化App Group的UserDefaults
        self.sharedDefaults = UserDefaults(suiteName: Constants.appGroupIdentifier)

        // 如果无法创建shared defaults，打印警告
        if sharedDefaults == nil {
            print("⚠️ 警告: 无法创建App Group UserDefaults。请在Xcode中配置App Group: \(Constants.appGroupIdentifier)")
        }
    }

    // MARK: - User Data Management

    /// 保存用户数据
    func saveUserData(_ userData: UserLifeData) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userData)

            // 保存到shared defaults（供Widget使用）
            sharedDefaults?.set(data, forKey: Constants.userDataKey)

            // 同时保存到standard defaults（备用）
            standardDefaults.set(data, forKey: Constants.userDataKey)

            print("✅ 用户数据保存成功")
        } catch {
            print("❌ 保存用户数据失败: \(error.localizedDescription)")
        }
    }

    /// 读取用户数据
    func loadUserData() -> UserLifeData? {
        // 优先从shared defaults读取
        if let data = sharedDefaults?.data(forKey: Constants.userDataKey) {
            return decodeUserData(from: data)
        }

        // 备用：从standard defaults读取
        if let data = standardDefaults.data(forKey: Constants.userDataKey) {
            return decodeUserData(from: data)
        }

        print("ℹ️ 未找到用户数据")
        return nil
    }

    /// 解码用户数据
    private func decodeUserData(from data: Data) -> UserLifeData? {
        do {
            let decoder = JSONDecoder()
            let userData = try decoder.decode(UserLifeData.self, from: data)
            return userData
        } catch {
            print("❌ 解码用户数据失败: \(error.localizedDescription)")
            return nil
        }
    }

    /// 删除用户数据
    func deleteUserData() {
        sharedDefaults?.removeObject(forKey: Constants.userDataKey)
        standardDefaults.removeObject(forKey: Constants.userDataKey)
        print("✅ 用户数据已删除")
    }

    // MARK: - Onboarding Status

    /// 标记首次配置已完成
    func setOnboardingCompleted(_ completed: Bool) {
        sharedDefaults?.set(completed, forKey: Constants.isOnboardingCompletedKey)
        standardDefaults.set(completed, forKey: Constants.isOnboardingCompletedKey)
    }

    /// 检查是否已完成首次配置
    func isOnboardingCompleted() -> Bool {
        // 优先检查shared defaults
        if let value = sharedDefaults?.object(forKey: Constants.isOnboardingCompletedKey) as? Bool {
            return value
        }

        // 备用：检查standard defaults
        return standardDefaults.bool(forKey: Constants.isOnboardingCompletedKey)
    }

    // MARK: - Debug Helpers

    /// 打印当前存储的所有数据（用于调试）
    func printAllData() {
        print("📦 === 存储的数据 ===")

        if let userData = loadUserData() {
            print("👤 用户数据:")
            print("  - 出生日期: \(userData.birthDate)")
            print("  - 预期寿命: \(userData.lifeExpectancy)岁")
            print("  - 显示名称: \(userData.displayName)")
            print("  - 主题: \(userData.theme.rawValue)")
            print("  - 进度条样式: \(userData.progressStyle.rawValue)")
        } else {
            print("👤 用户数据: 无")
        }

        print("✅ 首次配置完成: \(isOnboardingCompleted())")
        print("📦 ==================")
    }

    /// 重置所有数据（用于测试）
    func resetAllData() {
        deleteUserData()
        setOnboardingCompleted(false)
        print("🔄 所有数据已重置")
    }
}

// MARK: - 便捷访问扩展
extension DataManager {
    /// 获取当前用户的生命进度
    func getCurrentLifeProgress() -> LifeProgress? {
        guard let userData = loadUserData() else { return nil }
        return LifeProgress.calculate(from: userData)
    }

    /// 获取当前日常进度
    func getCurrentDailyProgress() -> DailyProgress {
        return DailyProgress.calculate()
    }

    /// 更新用户的出生日期
    func updateBirthDate(_ date: Date) {
        guard var userData = loadUserData() else { return }
        userData.birthDate = date
        saveUserData(userData)
    }

    /// 更新预期寿命
    func updateLifeExpectancy(_ years: Int) {
        guard var userData = loadUserData() else { return }
        userData.lifeExpectancy = years
        saveUserData(userData)
    }

    /// 更新显示名称
    func updateDisplayName(_ name: String) {
        guard var userData = loadUserData() else { return }
        userData.displayName = name
        saveUserData(userData)
    }

    /// 更新主题
    func updateTheme(_ theme: ThemeType) {
        guard var userData = loadUserData() else { return }
        userData.theme = theme
        saveUserData(userData)
    }

    /// 更新进度条样式
    func updateProgressStyle(_ style: ProgressStyle) {
        guard var userData = loadUserData() else { return }
        userData.progressStyle = style
        saveUserData(userData)
    }
}
