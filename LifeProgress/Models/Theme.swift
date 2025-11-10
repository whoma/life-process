import SwiftUI

// MARK: - 主题颜色扩展
/// 为每个主题提供 SwiftUI Color 对象
extension ThemeType {
    /// 已过时间的 SwiftUI 颜色
    var passedSwiftUIColor: Color {
        return Color(hex: passedColor)
    }

    /// 未来时间的 SwiftUI 颜色
    var futureSwiftUIColor: Color {
        return Color(hex: futureColor)
    }

    /// 渐变起始颜色
    var gradientStartColor: Color {
        return Color(hex: gradientStart)
    }

    /// 渐变结束颜色
    var gradientEndColor: Color {
        return Color(hex: gradientEnd)
    }

    /// 线性渐变
    var linearGradient: LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [gradientStartColor, gradientEndColor]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Color 扩展：从十六进制创建颜色
extension Color {
    /// 从十六进制字符串创建颜色
    /// - Parameter hex: 十六进制颜色字符串（如 "#1E3A8A" 或 "1E3A8A"）
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }

    /// 转换为十六进制字符串
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])

        return String(
            format: "#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)
        )
    }
}

// MARK: - 预定义颜色
extension Color {
    // 通用颜色
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)

    // 进度相关
    static let progressBackground = Color.gray.opacity(0.2)
    static let progressForeground = Color.blue
}
