//
//  SplashViewModel.swift
//  Weather
//
//  Created by Usuario on 3/01/26.
//

import Combine
import SwiftUI

final class SplashViewModel: SplashViewModelProtocol {
    @Published private(set) var isAnimating: Bool = true

    private let coordinator: NavigationCoordinator
    private var cancellables = Set<AnyCancellable>()

    init(coordinator: NavigationCoordinator) {
        self.coordinator = coordinator
    }

    func onAppear() {
        startDelayAndNavigate()
    }

    private func startDelayAndNavigate() {
        Just(())
            .delay(for: .seconds(.splashSeconds), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.navigateToOnboarding()
            }
            .store(in: &cancellables)
    }

    private func navigateToOnboarding() {
        Task { @MainActor in
            coordinator.push(
                OnboardingView(
                    viewModel: OnboardingViewModel(coordinator: self.coordinator)
                ),
                tag: .onboarding
            )
        }
    }
}

private extension Double {
    static let splashSeconds: Double = 1.2
}
