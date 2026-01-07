//
//  OnboardingViewModel.swift
//  Weather
//
//  Created by Usuario on 3/01/26.
//

import Combine
import SwiftUI

final class OnboardingViewModel: OnboardingViewModelProtocol {
    @Published var selectedIndex: Int = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: L10n.weatherApp,
            subtitle: L10n.discoverTheWeatherInYourCityAndPlanYourDayCorrectly,
            systemImageName: "cloud.sun.rain.fill"
        ),
        OnboardingPage(
            title: L10n.forecast,
            subtitle: L10n.checkTheForecastForTheNextDaysInSeconds,
            systemImageName: "calendar"
        )
    ]

    private let coordinator: NavigationCoordinator

    init(coordinator: NavigationCoordinator) {
        self.coordinator = coordinator
    }

    func onTapContinue() {
        if selectedIndex < pages.count - 1 {
            selectedIndex += 1
        } else {
            navigateToSearch()
        }
    }

    private func navigateToSearch() {
        Task { @MainActor in
            coordinator.push(
                SearchView(viewModel: SearchViewModel(coordinator: self.coordinator)),
                tag: .search
            )
        }
    }
}
