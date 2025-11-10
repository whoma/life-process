import SwiftUI

// MARK: - 主标签视图
/// 包含格子视图和进度条视图的主页面
struct MainTabView: View {
    @ObservedObject var viewModel: LifeProgressViewModel

    var body: some View {
        TabView {
            // 格子视图
            GridView(viewModel: viewModel)
                .tabItem {
                    Label("日历", systemImage: "square.grid.3x3")
                }

            // 进度条视图
            ProgressView(viewModel: viewModel)
                .tabItem {
                    Label("进度", systemImage: "chart.bar.fill")
                }
        }
    }
}

// MARK: - Preview
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(viewModel: LifeProgressViewModel())
    }
}
