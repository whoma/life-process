import SwiftUI

// MARK: - Life Progress App
/// 应用程序入口
@main
struct LifeProgressApp: App {
    // MARK: - Properties

    /// 视图模型（全局共享）
    @StateObject private var viewModel = LifeProgressViewModel()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}

// MARK: - Content View
/// 根视图，决定显示引导页还是主页面
struct ContentView: View {
    @ObservedObject var viewModel: LifeProgressViewModel

    var body: some View {
        ZStack {
            if viewModel.isOnboardingCompleted {
                // 主页面
                MainTabView(viewModel: viewModel)
                    .transition(.opacity)
            } else {
                // 引导页
                OnboardingView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.isOnboardingCompleted)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: LifeProgressViewModel())
    }
}
