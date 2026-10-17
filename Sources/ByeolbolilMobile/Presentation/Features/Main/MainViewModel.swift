import Observation
import SkipFuse

/// 앱 최상위 내비게이션 상태를 관리합니다.
@Observable
final class MainViewModel {
    private(set) var selectedTab: MainTab

    init(selectedTab: MainTab = .home) {
        self.selectedTab = selectedTab
    }

    func select(_ tab: MainTab) {
        selectedTab = tab
    }
}
