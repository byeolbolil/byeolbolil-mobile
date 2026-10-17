/// 앱의 최상위 화면을 나타내는 탭입니다.
enum MainTab: String, CaseIterable, Hashable {
    case home
    case spot
    case forecast
    case login

    var title: String {
        switch self {
        case .home: return "홈"
        case .spot: return "관측지"
        case .forecast: return "예보"
        case .login: return "로그인"
        }
    }

    var iconName: String {
        switch self {
        case .home: return "tab_home"
        case .spot: return "tab_spot"
        case .forecast: return "tab_forecast"
        case .login: return "tab_login"
        }
    }
}
