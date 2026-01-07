//
//  SearchViewModel.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Combine
import Foundation
import SwiftUI

enum SearchViewState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error
}

final class SearchViewModel: SearchViewModelProtocol {
    @Published var query: String = ""
    @Published private(set) var locations: [Location] = []
    @Published private(set) var viewState: SearchViewState = .idle
    @Published private(set) var errorMessage: String?

    private let coordinator: NavigationCoordinator
    private let searchUseCase: SearchLocationsUseCaseType

    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?

    init(
        coordinator: NavigationCoordinator,
        searchUseCase: SearchLocationsUseCaseType = SearchLocationsUseCase()
    ) {
        self.coordinator = coordinator
        self.searchUseCase = searchUseCase
        bindSearch()
    }

    func onAppear() {
        if query.isEmpty {
            viewState = .idle
            locations = []
        }
    }

    func onTapFavorites() {
        Task { @MainActor in
            coordinator.push(
                FavoritesView(viewModel: FavoritesViewModel(coordinator: self.coordinator)),
                tag: .favorites
            )
        }
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

    private func bindSearch() {
        $query
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .debounce(for: .milliseconds(.searchDebounceMs), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.performSearch(for: text)
            }
            .store(in: &cancellables)
    }

    private func performSearch(for text: String) {
        searchTask?.cancel()
        errorMessage = nil

        guard !text.isEmpty else {
            viewState = .idle
            locations = []
            return
        }

        viewState = .loading

        searchTask = Task { @MainActor in
            do {
                let results = try await searchUseCase.execute(query: text)
                locations = results
                viewState = results.isEmpty ? .empty : .loaded
            } catch {
                locations = []
                errorMessage = (error as? LocalizedError)?.errorDescription ?? "Unexpected error"
                viewState = .error
            }
        }
    }
}

private extension Int {
    static let searchDebounceMs: Int = 250
}
