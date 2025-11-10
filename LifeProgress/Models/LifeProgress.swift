import Foundation

// MARK: - 生命进度模型
/// 计算和存储各种时间维度的进度信息
struct LifeProgress {
    /// 总天数（基于预期寿命）
    var totalDays: Int

    /// 已过天数
    var passedDays: Int

    /// 剩余天数
    var remainingDays: Int {
        return totalDays - passedDays
    }

    /// 进度百分比
    var progressPercentage: Double {
        guard totalDays > 0 else { return 0 }
        return (Double(passedDays) / Double(totalDays)) * 100.0
    }

    /// 从用户数据计算生命进度
    static func calculate(from userData: UserLifeData) -> LifeProgress {
        // 计算总天数
        let totalDays = userData.lifeExpectancy * 365

        // 计算已过天数
        let passedDays = Int(Date().timeIntervalSince(userData.birthDate) / 86400)

        return LifeProgress(
            totalDays: totalDays,
            passedDays: max(0, passedDays) // 确保不是负数
        )
    }
}

// MARK: - 日常进度模型
/// 计算今日、本周、本月、本年的进度
struct DailyProgress {
    /// 今日进度 (0-100%)
    var todayProgress: Double

    /// 本周进度 (0-100%)
    var weekProgress: Double

    /// 本月进度 (0-100%)
    var monthProgress: Double

    /// 本年进度 (0-100%)
    var yearProgress: Double

    /// 计算所有日常进度
    static func calculate() -> DailyProgress {
        let calendar = Calendar.current
        let now = Date()

        // 今日进度
        let startOfDay = calendar.startOfDay(for: now)
        let todayElapsed = now.timeIntervalSince(startOfDay)
        let todayProgress = (todayElapsed / 86400.0) * 100.0

        // 本周进度
        let weekday = calendar.component(.weekday, from: now)
        // weekday: 1=周日, 2=周一, ..., 7=周六
        // 转换为 周一=1, ..., 周日=7
        let weekdayAdjusted = weekday == 1 ? 7 : weekday - 1
        let weekProgress = (Double(weekdayAdjusted) / 7.0) * 100.0

        // 本月进度
        let day = calendar.component(.day, from: now)
        let range = calendar.range(of: .day, in: .month, for: now)
        let daysInMonth = range?.count ?? 30
        let monthProgress = (Double(day) / Double(daysInMonth)) * 100.0

        // 本年进度
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: now) ?? 1
        let daysInYear = calendar.range(of: .day, in: .year, for: now)?.count ?? 365
        let yearProgress = (Double(dayOfYear) / Double(daysInYear)) * 100.0

        return DailyProgress(
            todayProgress: todayProgress,
            weekProgress: weekProgress,
            monthProgress: monthProgress,
            yearProgress: yearProgress
        )
    }

    /// 获取剩余时间描述
    func remainingDescription(for type: ProgressType) -> String {
        let calendar = Calendar.current
        let now = Date()

        switch type {
        case .today:
            let hours = Int((100 - todayProgress) * 24 / 100)
            return "剩余 \(hours) 小时"

        case .week:
            let days = Int((100 - weekProgress) * 7 / 100)
            return "剩余 \(days) 天"

        case .month:
            let range = calendar.range(of: .day, in: .month, for: now)
            let daysInMonth = range?.count ?? 30
            let days = Int((100 - monthProgress) * Double(daysInMonth) / 100)
            return "剩余 \(days) 天"

        case .year:
            let daysInYear = calendar.range(of: .day, in: .year, for: now)?.count ?? 365
            let days = Int((100 - yearProgress) * Double(daysInYear) / 100)
            return "剩余 \(days) 天"
        }
    }
}

// MARK: - 进度类型
enum ProgressType {
    case today
    case week
    case month
    case year

    var displayName: String {
        switch self {
        case .today: return "今日进度"
        case .week: return "本周进度"
        case .month: return "本月进度"
        case .year: return "本年进度"
        }
    }
}
