import SwiftUI

/// 앱의 최상위 탭과 각 기능 화면을 조합합니다.
struct MainView: View {
    @State var viewModel = MainViewModel()

    var body: some View {
        VStack(spacing: 0) {
            selectedContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            AppTabBar(
                selectedTab: viewModel.selectedTab,
                onSelect: { tab in
                    viewModel.select(tab)
                }
            )
        }
    }

    @ViewBuilder
    private var selectedContent: some View {
        switch viewModel.selectedTab {
        case .home:
            TabPlaceholderView(title: "홈")
        case .spot:
            TabPlaceholderView(title: "관측지")
        case .forecast:
            TabPlaceholderView(title: "예보")
        case .login:
            TabPlaceholderView(title: "로그인")
        }
    }
}

/// 각 기능 화면이 연결되기 전 사용하는 임시 콘텐츠입니다.
fileprivate struct TabPlaceholderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title2)
            .foregroundStyle(Color.black)
    }
}
