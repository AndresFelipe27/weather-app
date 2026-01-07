//
//  SearchLocationsUseCase.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

protocol SearchLocationsUseCaseType {
    func execute(query: String) async throws -> [Location]
}

final class SearchLocationsUseCase: SearchLocationsUseCaseType {
    private let repository: WeatherSearchRepository

    init(repository: WeatherSearchRepository = WeatherSearchAPIRepository()) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [Location] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        return try await repository.searchLocations(query: trimmed)
    }
}
