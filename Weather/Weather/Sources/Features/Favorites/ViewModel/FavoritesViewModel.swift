//
//  FavoritesViewModel.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Combine
import SwiftUI

final class FavoritesViewModel: FavoritesViewModelProtocol {
    private let coordinator: NavigationCoordinator
    private let getFavoritesUseCase: GetFavoriteLocationsUseCaseType

    @Published private(set) var favorites: [Location] = []

    init(
        coordinator: NavigationCoordinator,
        getFavoritesUseCase: GetFavoriteLocationsUseCaseType = GetFavoriteLocationsUseCase()
    ) {
        self.coordinator = coordinator
        self.getFavoritesUseCase = getFavoritesUseCase
    }

    func onAppear() {
        favorites = getFavoritesUseCase.execute()
    }

    func onTapLocation(_ location: Location) {
        Task { @MainActor in
            coordinator.push(
                ForecastView(
                    viewModel: ForecastViewModel(
                        selectedLocation: location,
                        coordinator: self.coordinator
                    )
                ),
                tag: .forecast
            )
        }
    }
}
