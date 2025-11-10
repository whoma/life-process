# Life Progress - 项目结构说明

## 📁 目录结构

```
LifeProgress/
├── LifeProgressApp.swift                 # App入口文件
│
├── Models/                               # 数据模型层
│   ├── UserLifeData.swift               # 用户数据模型
│   ├── LifeProgress.swift               # 进度计算模型
│   └── Theme.swift                      # 主题颜色系统
│
├── ViewModels/                          # 视图模型层
│   └── LifeProgressViewModel.swift      # 主视图模型
│
├── Views/                               # 视图层
│   ├── Onboarding/
│   │   └── OnboardingView.swift        # 首次引导页面
│   ├── Main/
│   │   ├── MainTabView.swift           # 主标签页
│   │   ├── GridView.swift              # 格子日历视图
│   │   └── ProgressView.swift          # 进度条视图
│   └── Settings/
│       └── SettingsView.swift          # 设置页面
│
├── Utilities/                           # 工具类
│   ├── DateCalculator.swift            # 日期计算
│   ├── DataManager.swift                # 数据管理
│   └── Constants.swift                  # 常量定义
│
└── Widget/                              # Widget扩展
    ├── LifeProgressWidget.swift         # Widget入口
    ├── SmallWidgetView.swift            # 小组件
    ├── MediumWidgetView.swift           # 中组件
    └── LargeWidgetView.swift            # 大组件
```

## 🏗️ 架构说明

### MVVM架构

项目采用MVVM (Model-View-ViewModel) 架构：

```
┌─────────────┐
│    View     │ ← 用户界面（SwiftUI Views）
└──────┬──────┘
       │ 绑定 (@ObservedObject)
┌──────▼──────┐
│  ViewModel  │ ← 业务逻辑和状态管理
└──────┬──────┘
       │ 读写
┌──────▼──────┐
│    Model    │ ← 数据模型和计算逻辑
└─────────────┘
       │
┌──────▼──────┐
│  Utilities  │ ← 工具类和数据持久化
└─────────────┘
```

## 📦 核心模块详解

### 1. Models（数据模型）

#### UserLifeData.swift
```swift
// 用户的基本信息
struct UserLifeData {
    var birthDate: Date           // 出生日期
    var lifeExpectancy: Int       // 预期寿命
    var displayName: String       // 显示名称
    var theme: ThemeType          // 主题
    var progressStyle: ProgressStyle
}
```

**关键枚举：**
- `ThemeType`: 4种配色方案（经典蓝、暖阳橙、森林绿、极简黑白）
- `ProgressStyle`: 进度条样式（经典、充电、渐变）

#### LifeProgress.swift
```swift
// 生命进度计算
struct LifeProgress {
    var totalDays: Int           // 总天数
    var passedDays: Int          // 已过天数
    var remainingDays: Int       // 剩余天数
    var progressPercentage: Double // 进度百分比
}

// 日常进度
struct DailyProgress {
    var todayProgress: Double    // 今日进度
    var weekProgress: Double     // 本周进度
    var monthProgress: Double    // 本月进度
    var yearProgress: Double     // 本年进度
}
```

#### Theme.swift
- Color扩展：十六进制颜色支持
- ThemeType扩展：SwiftUI Color映射
- 预定义颜色常量

### 2. ViewModels（视图模型）

#### LifeProgressViewModel.swift

**职责：**
- 管理应用状态
- 处理用户交互
- 数据持久化
- 提供计算属性

**主要属性：**
```swift
@Published var userData: UserLifeData
@Published var lifeProgress: LifeProgress
@Published var dailyProgress: DailyProgress
@Published var isOnboardingCompleted: Bool
```

**主要方法：**
- `saveUserData()`: 保存数据
- `completeOnboarding()`: 完成引导
- `refreshProgress()`: 刷新进度
- `resetApp()`: 重置应用

### 3. Views（视图）

#### OnboardingView.swift
- 首次启动配置
- 日期选择器
- 数据验证

#### MainTabView.swift
- Tab容器
- 格子视图和进度视图切换

#### GridView.swift
- 格子日历展示
- LazyVGrid性能优化
- 格子点击交互

#### ProgressView.swift
- 多维度进度展示
- 进度条动画
- 实时数据更新

#### SettingsView.swift
- 基本设置
- 数据管理
- 应用信息

### 4. Utilities（工具类）

#### Constants.swift
定义全局常量：
- App Group标识符
- UserDefaults键
- 默认值
- UI常量（大小、间距、圆角等）
- 动画时长

#### DataManager.swift
数据持久化管理：
- 单例模式
- App Group UserDefaults
- 数据的增删改查
- 引导状态管理

**关键功能：**
```swift
// 保存/读取用户数据
func saveUserData(_ userData: UserLifeData)
func loadUserData() -> UserLifeData?

// 引导状态
func setOnboardingCompleted(_ completed: Bool)
func isOnboardingCompleted() -> Bool

// 便捷方法
func updateBirthDate(_ date: Date)
func updateLifeExpectancy(_ years: Int)
```

#### DateCalculator.swift
日期和时间计算：
- 生命进度计算
- 今日/周/月/年进度
- 日期格式化
- 年龄计算
- 数字格式化

### 5. Widget（小组件）

#### LifeProgressWidget.swift
- Widget入口配置
- Timeline Provider
- 数据刷新策略（每天午夜）

#### SmallWidgetView.swift
**小组件（系统小尺寸）**
- 显示内容：
  - 总进度百分比
  - 简单进度条
  - 已过天数
- 尺寸：约 155 x 155 点

#### MediumWidgetView.swift
**中组件（系统中尺寸）**
- 显示内容：
  - 总进度
  - 格子日历（365天）
  - 图例
- 尺寸：约 329 x 155 点

#### LargeWidgetView.swift
**大组件（系统大尺寸）**
- 显示内容：
  - 总进度
  - 格子日历（730天）
  - 统计信息
  - 今日标记
- 尺寸：约 329 x 345 点

## 🔄 数据流

### 1. 首次启动流程

```
用户启动App
    ↓
ContentView检查isOnboardingCompleted
    ↓ (false)
显示OnboardingView
    ↓
用户选择出生日期
    ↓
点击"开始"按钮
    ↓
ViewModel.updateBirthDate()
    ↓
ViewModel.completeOnboarding()
    ↓
DataManager.saveUserData()
    ↓
DataManager.setOnboardingCompleted(true)
    ↓
显示MainTabView
```

### 2. 数据更新流程

```
用户在SettingsView修改数据
    ↓
ViewModel.updateBirthDate/updateLifeExpectancy()
    ↓
ViewModel.saveUserData()
    ↓
DataManager.saveUserData()
    ↓
保存到App Group UserDefaults
    ↓
ViewModel.refreshProgress()
    ↓
更新所有@Published属性
    ↓
View自动刷新
    ↓
Widget在下次刷新时读取新数据
```

### 3. Widget刷新流程

```
系统请求Widget更新
    ↓
LifeProgressProvider.getTimeline()
    ↓
LifeProgressEntry.loadFromDataManager()
    ↓
DataManager.loadUserData()
    ↓
从App Group UserDefaults读取
    ↓
计算LifeProgress
    ↓
创建WidgetData
    ↓
返回Timeline（下次刷新时间：明天午夜）
    ↓
系统渲染对应尺寸的Widget视图
```

## 🎨 UI组件复用

### 通用组件

1. **ProgressBarView** (ProgressView.swift)
   - 可复用的进度条组件
   - 支持动画
   - 支持自定义颜色

2. **DatePickerSheet** (OnboardingView.swift)
   - 日期选择弹窗
   - 可在多处复用

3. **Grid Cell** (GridView.swift)
   - 单个格子组件
   - 支持不同状态显示

## 📊 性能优化

### 1. 格子视图优化
- 使用 `LazyVGrid` 而非 `Grid`
- 按需加载格子
- 最小化重绘

### 2. Widget优化
- 数据预计算
- 简化渲染逻辑
- 合理的刷新策略（每天午夜）

### 3. 内存优化
- 单例DataManager
- 避免重复计算
- 及时释放资源

## 🔐 数据安全

### 本地存储
- 所有数据存储在设备本地
- 使用UserDefaults（加密存储）
- App Group隔离

### 隐私保护
- 不上传任何数据
- 不需要网络权限
- 不收集用户信息

## 🧪 测试建议

### 单元测试
- DateCalculator的各种计算方法
- LifeProgress的进度计算
- 边界条件测试

### UI测试
- 引导流程
- 数据输入验证
- 页面切换

### Widget测试
- 不同尺寸显示
- 数据同步
- 刷新策略

## 📝 代码规范

### 命名约定
- 类型：PascalCase (如 `UserLifeData`)
- 变量/方法：camelCase (如 `birthDate`)
- 常量：camelCase (如 `defaultLifeExpectancy`)
- 文件名：与主要类型名相同

### 注释规范
- 使用中文注释
- MARK分隔代码块
- 函数注释说明参数和返回值

### 代码组织
```swift
// MARK: - 类型名称
/// 简要描述

// MARK: - Properties
// 属性

// MARK: - Initialization
// 初始化

// MARK: - Public Methods
// 公开方法

// MARK: - Private Methods
// 私有方法

// MARK: - Computed Properties
// 计算属性
```

## 🔄 版本历史

### v1.0.0 (2025-11-10)
- ✅ 首次发布
- ✅ 基础功能实现
- ✅ Widget支持
- ✅ 简化配置流程

## 🚀 未来扩展

### 计划功能
- 主题切换UI
- 里程碑标记
- 数据导出
- iCloud同步
- iPad适配
- Apple Watch支持

### 架构优化
- 引入Coordinator模式
- 添加Repository层
- 实现依赖注入

---

**文档更新日期：2025-11-10**
