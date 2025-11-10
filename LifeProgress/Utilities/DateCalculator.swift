import Foundation

// MARK: - 日期计算工具
/// 提供各种日期和时间相关的计算功能
struct DateCalculator {

    // MARK: - 生命进度计算

    /// 计算总天数
    static func calculateTotalDays(lifeExpectancy: Int) -> Int {
        return lifeExpectancy * 365
    }

    /// 计算已过天数
    static func calculatePassedDays(since birthDate: Date) -> Int {
        let now = Date()
        let timeInterval = now.timeIntervalSince(birthDate)
        let days = Int(timeInterval / 86400)
        return max(0, days) // 确保不为负数
    }

    /// 计算剩余天数
    static func calculateRemainingDays(totalDays: Int, passedDays: Int) -> Int {
        return max(0, totalDays - passedDays)
    }

    /// 计算进度百分比
    static func calculateProgressPercentage(passedDays: Int, totalDays: Int) -> Double {
        guard totalDays > 0 else { return 0 }
        return (Double(passedDays) / Double(totalDays)) * 100.0
    }

    // MARK: - 今日进度

    /// 计算今日已过时间百分比
    static func calculateTodayProgress() -> Double {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)

        let elapsed = now.timeIntervalSince(startOfDay)
        let progress = (elapsed / 86400.0) * 100.0

        return min(100.0, max(0.0, progress))
    }

    /// 计算今日剩余小时
    static func calculateTodayRemainingHours() -> Int {
        let todayProgress = calculateTodayProgress()
        return Int((100.0 - todayProgress) * 24.0 / 100.0)
    }

    // MARK: - 本周进度

    /// 计算本周进度百分比
    static func calculateWeekProgress() -> Double {
        let calendar = Calendar.current
        let now = Date()

        let weekday = calendar.component(.weekday, from: now)
        // weekday: 1=周日, 2=周一, ..., 7=周六
        // 转换为 周一=1, ..., 周日=7
        let weekdayAdjusted = weekday == 1 ? 7 : weekday - 1

        return (Double(weekdayAdjusted) / 7.0) * 100.0
    }

    /// 计算本周剩余天数
    static func calculateWeekRemainingDays() -> Int {
        let weekProgress = calculateWeekProgress()
        return Int((100.0 - weekProgress) * 7.0 / 100.0)
    }

    // MARK: - 本月进度

    /// 计算本月进度百分比
    static func calculateMonthProgress() -> Double {
        let calendar = Calendar.current
        let now = Date()

        let day = calendar.component(.day, from: now)
        let range = calendar.range(of: .day, in: .month, for: now)
        let daysInMonth = range?.count ?? 30

        return (Double(day) / Double(daysInMonth)) * 100.0
    }

    /// 计算本月剩余天数
    static func calculateMonthRemainingDays() -> Int {
        let calendar = Calendar.current
        let now = Date()

        let day = calendar.component(.day, from: now)
        let range = calendar.range(of: .day, in: .month, for: now)
        let daysInMonth = range?.count ?? 30

        return daysInMonth - day
    }

    // MARK: - 本年进度

    /// 计算本年进度百分比
    static func calculateYearProgress() -> Double {
        let calendar = Calendar.current
        let now = Date()

        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: now) ?? 1
        let daysInYear = calendar.range(of: .day, in: .year, for: now)?.count ?? 365

        return (Double(dayOfYear) / Double(daysInYear)) * 100.0
    }

    /// 计算本年剩余天数
    static func calculateYearRemainingDays() -> Int {
        let calendar = Calendar.current
        let now = Date()

        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: now) ?? 1
        let daysInYear = calendar.range(of: .day, in: .year, for: now)?.count ?? 365

        return daysInYear - dayOfYear
    }

    // MARK: - 日期格式化

    /// 格式化日期为字符串
    static func formatDate(_ date: Date, format: String = Constants.dateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }

    /// 格式化百分比
    static func formatPercentage(_ value: Double, decimals: Int = 2) -> String {
        return String(format: "%.\(decimals)f%%", value)
    }

    /// 格式化大数字（添加逗号分隔符）
    static func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    // MARK: - 年龄计算

    /// 计算当前年龄
    static func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        return ageComponents.year ?? 0
    }

    /// 计算具体年龄（X年X月X天）
    static func calculateDetailedAge(from birthDate: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: birthDate, to: now)

        let years = components.year ?? 0
        let months = components.month ?? 0
        let days = components.day ?? 0

        return "\(years)岁\(months)个月\(days)天"
    }

    // MARK: - 下次午夜时间

    /// 获取下一个午夜的时间（用于Widget刷新）
    static func nextMidnight() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        return calendar.startOfDay(for: tomorrow)
    }

    // MARK: - 日期验证

    /// 验证出生日期是否有效
    static func isValidBirthDate(_ date: Date) -> Bool {
        let now = Date()
        // 出生日期不能是未来
        guard date <= now else { return false }

        // 出生日期不能超过150年前
        let calendar = Calendar.current
        if let date150YearsAgo = calendar.date(byAdding: .year, value: -150, to: now) {
            return date >= date150YearsAgo
        }

        return true
    }
}

// MARK: - Date扩展
extension Date {
    /// 获取年份
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    /// 获取月份
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    /// 获取日期
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    /// 是否是今天
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    /// 是否是过去的日期
    var isPast: Bool {
        return self < Date()
    }

    /// 格式化为字符串
    func formatted(_ format: String = Constants.dateFormat) -> String {
        return DateCalculator.formatDate(self, format: format)
    }
}
