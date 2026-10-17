import SwiftUI

/// 앱 진입 화면입니다. 시작 화면과 메인 탭 화면의 전환만 담당합니다.
struct ContentView: View {
    @State var isSplashPresented = true
    @State var isSplashLoading = true

    var body: some View {
        ZStack {
            MainView()

            if isSplashPresented {
                SplashView(isLoading: $isSplashLoading)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isSplashLoading = false
                isSplashPresented = false
            }
        }
    }
}
