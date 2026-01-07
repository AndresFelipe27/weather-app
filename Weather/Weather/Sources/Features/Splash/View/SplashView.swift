//
//  SplashView.swift
//  Weather
//
//  Created by Usuario on 3/01/26.
//

import SwiftUI

struct SplashView<ViewModel>: View where ViewModel: SplashViewModelProtocol {
    @StateObject private var viewModel: ViewModel

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.splashTop, .splashBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: .layoutSize20) {
                Image(systemName: "cloud.sun.rain.fill")
                    .font(.system(size: .layoutSize88))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .yellow, .blue.opacity(0.9))
                    .shadow(radius: .layoutSize8)

                Text("Weather App")
                    .font(.system(size: .layoutSize28, weight: .semibold))
                    .foregroundStyle(.white)

                ProgressView()
                    .tint(.white)
                    .scaleEffect(.progressScale)
                    .opacity(viewModel.isAnimating ? 1 : 0)
            }
            .padding(.horizontal, .layoutSize24)
        }
        .onAppear(perform: viewModel.onAppear)
    }
}

public extension Color {
    static let splashTop: Color = .blue.opacity(0.75)
    static let splashBottom: Color = .yellow.opacity(0.85)
}

#Preview {
    SplashView(viewModel: SplashViewModel(coordinator: NavigationCoordinator()))
}
