# 快速开始指南 - Life Progress

这是一个5分钟快速上手指南，帮助你在Xcode中快速运行Life Progress项目。

## 🎯 5步快速启动

### 第1步: 创建Xcode项目 (1分钟)

1. 打开Xcode
2. File → New → Project
3. 选择 **iOS → App**
4. 填写信息：
   - Product Name: `LifeProgress`
   - Team: 选择你的开发团队
   - Organization Identifier: `com.yourname`
   - Interface: **SwiftUI**
   - Language: **Swift**
5. 点击 **Next**，选择保存位置

### 第2步: 导入代码 (30秒)

将本仓库的 `LifeProgress/` 文件夹拖入Xcode项目：

1. 在Finder中打开项目文件夹
2. 将整个 `LifeProgress` 文件夹拖入Xcode的项目导航器
3. 在弹出的对话框中：
   - ✅ 勾选 **Copy items if needed**
   - ✅ 勾选 **Create groups**
   - ✅ Target选择 `LifeProgress`
4. 点击 **Finish**

### 第3步: 配置App Group (1分钟)

**主App配置：**
1. 选中项目根节点
2. 选择 `LifeProgress` target
3. **Signing & Capabilities** 标签
4. 点击 **+ Capability**
5. 搜索并添加 **App Groups**
6. 点击 **+** 按钮，输入：
   ```
   group.com.yourname.lifeprogress
   ```
   （将 `yourname` 替换为你的标识符）

**更新代码中的App Group：**
打开 `LifeProgress/Utilities/Constants.swift`，修改：
```swift
static let appGroupIdentifier = "group.com.yourname.lifeprogress"
```

### 第4步: 添加Widget Extension (2分钟)

1. **创建Widget Target：**
   - File → New → Target
   - 选择 **Widget Extension**
   - Product Name: `LifeProgressWidget`
   - 不勾选 **Include Configuration Intent**
   - 点击 **Finish** → **Activate**

2. **删除自动生成的文件：**
   - 删除 `LifeProgressWidget/LifeProgressWidget.swift`
   - 删除 `LifeProgressWidget/Assets.xcassets`（保留主App的）

3. **配置Widget文件的Target：**

   在项目导航器中，选中以下文件，在右侧 **Target Membership** 中勾选对应target：

   | 文件/文件夹 | LifeProgress (主App) | LifeProgressWidget |
   |------------|---------------------|-------------------|
   | `Models/` 所有文件 | ✅ | ✅ |
   | `Utilities/` 所有文件 | ✅ | ✅ |
   | `ViewModels/` 所有文件 | ✅ | ✅ |
   | `Views/` 所有文件 | ✅ | ❌ |
   | `Widget/` 所有文件 | ❌ | ✅ |
   | `LifeProgressApp.swift` | ✅ | ❌ |

4. **为Widget配置App Group：**
   - 选中 `LifeProgressWidget` target
   - Signing & Capabilities
   - 添加 **App Groups**
   - 添加相同的ID: `group.com.yourname.lifeprogress`

### 第5步: 运行 (30秒)

**运行主App：**
1. 选择 `LifeProgress` scheme
2. 选择模拟器（建议 iPhone 15 Pro）
3. 点击 ▶️ 运行
4. 在引导页面设置你的出生日期

**测试Widget：**
1. 在模拟器主屏幕，长按空白处
2. 点击左上角 **+**
3. 搜索 "Life Progress"
4. 选择不同大小的Widget添加到主屏幕

## ✅ 验证清单

确保以下都正确配置：

- [ ] 主App可以正常运行
- [ ] 可以在引导页面设置出生日期
- [ ] 日历页面显示格子网格
- [ ] 进度页面显示各个维度的进度
- [ ] Widget可以在主屏幕添加
- [ ] Widget显示正确的数据

## 🐛 常见错误及解决

### 错误1: "No such module 'WidgetKit'"

**原因**: Widget文件被错误地添加到主App target

**解决**:
- 选中 `Widget/` 文件夹下的所有文件
- 在 **Target Membership** 中：
  - ❌ 取消勾选 `LifeProgress`
  - ✅ 只勾选 `LifeProgressWidget`

### 错误2: "Cannot find 'UserLifeData' in scope" (在Widget中)

**原因**: Models文件没有添加到Widget target

**解决**:
- 选中 `Models/` 文件夹下的所有文件
- 在 **Target Membership** 中：
  - ✅ 同时勾选 `LifeProgress` 和 `LifeProgressWidget`

### 错误3: Widget不显示数据

**原因**: App Group配置不正确

**解决**:
1. 检查主App和Widget的App Group ID是否完全一致
2. 检查 `Constants.swift` 中的ID是否匹配
3. 在主App中重新设置出生日期，确保数据被保存到App Group

### 错误4: 编译成功但Widget显示"Unable to Load"

**原因**: Widget的Info.plist配置问题或代码错误

**解决**:
1. Clean Build Folder (Cmd + Shift + K)
2. 删除模拟器上的App
3. 重新运行

## 📂 文件Target配置速查表

```
LifeProgress/
├── LifeProgressApp.swift          [主App]
├── Models/                        [主App + Widget]
│   ├── UserLifeData.swift
│   ├── LifeProgress.swift
│   └── Theme.swift
├── ViewModels/                    [主App + Widget]
│   └── LifeProgressViewModel.swift
├── Views/                         [主App]
│   ├── Onboarding/
│   ├── Main/
│   └── Settings/
├── Utilities/                     [主App + Widget]
│   ├── DateCalculator.swift
│   ├── DataManager.swift
│   └── Constants.swift
└── Widget/                        [Widget]
    ├── LifeProgressWidget.swift
    ├── SmallWidgetView.swift
    ├── MediumWidgetView.swift
    └── LargeWidgetView.swift
```

## 🎓 下一步

完成快速启动后，你可以：

1. **自定义配置**：
   - 修改默认预期寿命（在 `Constants.swift` 中）
   - 调整格子大小和间距
   - 自定义主题颜色

2. **添加功能**：
   - 实现主题切换UI
   - 添加里程碑标记
   - 实现数据导出功能

3. **优化性能**：
   - 优化大量格子的渲染性能
   - 添加动画效果
   - 改进Widget刷新策略

## 📚 相关资源

- [完整README](./README.md) - 详细的项目文档
- [SwiftUI官方文档](https://developer.apple.com/documentation/swiftui)
- [WidgetKit官方文档](https://developer.apple.com/documentation/widgetkit)

## 💬 需要帮助？

如果遇到问题：

1. 检查上面的"常见错误及解决"
2. 仔细对照"验证清单"
3. 确保Xcode和iOS版本符合要求
4. 尝试Clean Build (Cmd + Shift + K)

---

**祝你开发顺利！🚀**
