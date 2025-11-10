import Foundation

// MARK: - 常量定义
enum Constants {
    // MARK: - App Group
    /// App Group标识符，用于主App和Widget之间共享数据
    /// 注意：在Xcode中需要配置对应的App Group
    static let appGroupIdentifier = "group.com.lifeprocess.app"

    // MARK: - UserDefaults Keys
    /// 用户数据存储key
    static let userDataKey = "user_life_data"

    /// 是否已完成首次配置
    static let isOnboardingCompletedKey = "is_onboarding_completed"

    // MARK: - 默认值
    /// 默认预期寿命
    static let defaultLifeExpectancy = 80

    /// 预期寿命范围
    static let lifeExpectancyRange = 50...120

    /// 默认显示名称
    static let defaultDisplayName = "我的人生"

    // MARK: - UI常量
    /// 格子大小（点）
    static let gridCellSize: CGFloat = 12.0

    /// 格子间距
    static let gridSpacing: CGFloat = 2.0

    /// 每行格子数量（代表一周7天）
    static let gridColumnsPerWeek = 7

    /// 圆角半径
    static let cornerRadius: CGFloat = 12.0

    /// 进度条高度
    static let progressBarHeight: CGFloat = 20.0

    // MARK: - 动画
    /// 标准动画时长
    static let animationDuration: Double = 0.3

    /// 进度条填充动画时长
    static let progressFillDuration: Double = 1.0

    // MARK: - Widget刷新
    /// Widget刷新间隔（秒）- 每天午夜刷新
    static let widgetRefreshInterval: TimeInterval = 86400

    // MARK: - 格式化
    /// 日期格式
    static let dateFormat = "yyyy年MM月dd日"

    /// 百分比格式（保留2位小数）
    static let percentageFormat = "%.2f%%"

    /// 百分比格式（保留1位小数）
    static let percentageFormatShort = "%.1f%%"
}

// MARK: - 格子视图模式
enum GridViewMode {
    case day      // 按天显示
    case week     // 按周显示
    case month    // 按月显示
    case year     // 按年显示

    var displayName: String {
        switch self {
        case .day: return "天"
        case .week: return "周"
        case .month: return "月"
        case .year: return "年"
        }
    }
}

// MARK: - Widget大小
enum WidgetSize {
    case small
    case medium
    case large

    var displayName: String {
        switch self {
        case .small: return "小组件"
        case .medium: return "中组件"
        case .large: return "大组件"
        }
    }
}
