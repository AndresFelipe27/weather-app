//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Combine
import Foundation

final class ForecastViewModel: ForecastViewModelProtocol {
    enum State: Equatable {
        case idle
        case loading
        case loaded(WeatherForecast)
        case error(message: String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var isFavorite: Bool = false

    let selectedLocation: Location

    var title: String { selectedLocation.name }

    private let coordinator: NavigationCoordinator
    private let getForecastUseCase: GetWeatherForecastUseCaseType
    private let isFavoriteUseCase: IsFavoriteUseCaseType
    private let toggleFavoriteUseCase: ToggleFavoriteUseCaseType

    private var loadTask: Task<Void, Never>?

    init(
        selectedLocation: Location,
        coordinator: NavigationCoordinator,
        getForecastUseCase: GetWeatherForecastUseCaseType = GetWeatherForecastUseCase(),
        isFavoriteUseCase: IsFavoriteUseCaseType = IsFavoriteUseCase(),
        toggleFavoriteUseCase: ToggleFavoriteUseCaseType = ToggleFavoriteUseCase()
    ) {
        self.selectedLocation = selectedLocation
        self.coordinator = coordinator
        self.getForecastUseCase = getForecastUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

    func onAppear() {
        isFavorite = isFavoriteUseCase.execute(location: selectedLocation)
        fetch()
    }

    func onDisappear() {
        loadTask?.cancel()
        loadTask = nil
    }

    func onTapBack() {
        coordinator.pop()
    }

    func onToggleFavorite() {
        isFavorite = toggleFavoriteUseCase.execute(location: selectedLocation)
    }

    private func fetch() {
        loadTask?.cancel()
        state = .loading

        let query = "\(selectedLocation.name) \(selectedLocation.region) \(selectedLocation.country)"
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let forecast = try await self.getForecastUseCase.execute(
                    query: query,
                    days: Int.forecastDays
                )
                await MainActor.run { self.state = .loaded(forecast) }
            } catch {
                let message = (error as? APIErrorResponse)?.message ?? "Unknown error"
                await MainActor.run { self.state = .error(message: message) }
            }
        }
    }
}

public extension Int {
    static let forecastDays: Int = 3
}
