//
//  SwiftUIView.swift
//  byeolbolil-mobile
//
//  Created by Quarang on 5/23/26.
//

import SwiftUI

struct SplashView: View {
    @Binding var isLoading: Bool
    @State var spinnerRotation = 0.0

    var body: some View {
        ZStack {
            Image("splash_background")
                .resizable()
                .scaledToFill()

            VStack(spacing: 20) {
                Image("splash_title")
                    .resizable()
                    .frame(width: 120, height: 50)
                    .offset(x: 5)
                    .padding(.vertical, 12)

                if isLoading {
                    Circle()
                        .trim(from: 0.12, to: 0.82)
                        .stroke(
                            Color.white,
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 28, height: 28)
                        .rotationEffect(.degrees(spinnerRotation))
                        .onAppear {
                            withAnimation(
                                .linear(duration: 0.9)
                                    .repeatForever(autoreverses: false)
                            ) {
                                spinnerRotation = 360
                            }
                        }
                }
            }
            .offset(y: 50)
        }
        .ignoresSafeArea()
    }
}
