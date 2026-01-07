//
//  OnboardingView.swift
//  Weather
//
//  Created by Usuario on 3/01/26.
//

import SwiftUI

struct OnboardingView<ViewModel>: View where ViewModel: OnboardingViewModelProtocol {
    @StateObject private var viewModel: ViewModel

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                LinearGradient(
                    colors: [.splashTop, .splashBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    Spacer(minLength: .layoutSize12)

                    Image(systemName: currentPage.systemImageName)
                        .font(.system(size: min(proxy.size.width * .iconScaleFactor, .layoutSize96)))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .yellow, .blue.opacity(0.9))
                        .shadow(radius: .layoutSize8)

                    Spacer()

                    card(proxy: proxy)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .interactiveDismissDisabled(true)
    }

    private func card(proxy: GeometryProxy) -> some View {
        VStack(spacing: .layoutSize16) {
            dots

            Text(currentPage.title)
                .font(.system(size: .layoutSize22, weight: .semibold))
                .foregroundStyle(.primary)

            Text(currentPage.subtitle)
                .font(.system(size: .layoutSize14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(action: viewModel.onTapContinue) {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: .layoutSize54, height: .layoutSize54)

                    Image(systemName: "arrow.right")
                        .font(.system(size: .layoutSize18, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .padding(.top, .layoutSize8)
            .accessibilityLabel("Continue")
        }
        .padding(.vertical, .layoutSize20)
        .padding(.horizontal, .layoutSize24)
        .frame(maxWidth: .cardMaxWidth(for: proxy.size.width))
        .background(
            RoundedRectangle(cornerRadius: .layoutSize20)
                .fill(Color.white)
                .shadow(radius: .layoutSize8)
        )
        .padding(.horizontal, .layoutSize16)
        .padding(.bottom, .layoutSize24)
        .animation(.easeInOut, value: viewModel.selectedIndex)
    }

    private var dots: some View {
        HStack(spacing: .layoutSize8) {
            ForEach(0..<viewModel.pages.count, id: \.self) { index in
                Circle()
                    .fill(index == viewModel.selectedIndex ? Color.blue : Color.gray.opacity(0.35))
                    .frame(
                        width: .dotSize(for: index == viewModel.selectedIndex),
                        height: .dotSize(for: index == viewModel.selectedIndex)
                    )
            }
        }
        .padding(.top, .layoutSize4)
    }

    private var currentPage: OnboardingPage {
        viewModel.pages[safe: viewModel.selectedIndex] ?? viewModel.pages[0]
    }
}

private extension CGFloat {
    static let iconScaleFactor: CGFloat = 0.28

    static func dotSize(for isSelected: Bool) -> CGFloat { isSelected ? 10 : 8 }
    static func cardMaxWidth(for screenWidth: CGFloat) -> CGFloat {
        Swift.min(screenWidth - 32, 360)
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
