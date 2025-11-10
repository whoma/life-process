import Foundation

// MARK: - 用户生命数据模型
/// 存储用户的基本信息，包括出生日期、预期寿命等
struct UserLifeData: Codable {
    /// 出生日期
    var birthDate: Date

    /// 预期寿命（岁）
    var lifeExpectancy: Int

    /// 显示名称
    var displayName: String

    /// 主题配色
    var theme: ThemeType

    /// 进度条样式
    var progressStyle: ProgressStyle

    /// 默认初始化
    init(
        birthDate: Date = Date(),
        lifeExpectancy: Int = 80,
        displayName: String = "我的人生",
        theme: ThemeType = .classicBlue,
        progressStyle: ProgressStyle = .classic
    ) {
        self.birthDate = birthDate
        self.lifeExpectancy = lifeExpectancy
        self.displayName = displayName
        self.theme = theme
        self.progressStyle = progressStyle
    }
}

// MARK: - 主题类型
enum ThemeType: String, Codable, CaseIterable {
    case classicBlue = "经典蓝"
    case warmOrange = "暖阳橙"
    case forestGreen = "森林绿"
    case minimalBlackWhite = "极简黑白"

    /// 已过时间的颜色
    var passedColor: String {
        switch self {
        case .classicBlue: return "#1E3A8A"
        case .warmOrange: return "#C2410C"
        case .forestGreen: return "#065F46"
        case .minimalBlackWhite: return "#000000"
        }
    }

    /// 未来时间的颜色
    var futureColor: String {
        switch self {
        case .classicBlue: return "#DBEAFE"
        case .warmOrange: return "#FED7AA"
        case .forestGreen: return "#D1FAE5"
        case .minimalBlackWhite: return "#F3F4F6"
        }
    }

    /// 渐变色起始
    var gradientStart: String {
        switch self {
        case .classicBlue: return "#3B82F6"
        case .warmOrange: return "#F97316"
        case .forestGreen: return "#10B981"
        case .minimalBlackWhite: return "#6B7280"
        }
    }

    /// 渐变色结束
    var gradientEnd: String {
        switch self {
        case .classicBlue: return "#1E40AF"
        case .warmOrange: return "#EA580C"
        case .forestGreen: return "#059669"
        case .minimalBlackWhite: return "#374151"
        }
    }
}

// MARK: - 进度条样式
enum ProgressStyle: String, Codable, CaseIterable {
    case classic = "经典"
    case charging = "充电"
    case gradient = "渐变"

    var description: String {
        return self.rawValue
    }
}
