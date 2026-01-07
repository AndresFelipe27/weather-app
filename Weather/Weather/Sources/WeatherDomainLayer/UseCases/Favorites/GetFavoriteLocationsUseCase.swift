//
//  GetFavoriteLocationsUseCase.swift
//  Weather
//
//  Created by Usuario on 5/01/26.
//

import Foundation

protocol GetFavoriteLocationsUseCaseType {
    func execute() -> [Location]
}

final class GetFavoriteLocationsUseCase: GetFavoriteLocationsUseCaseType {
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository = FavoritesLocalRepository()) {
        self.repository = repository
    }

    func execute() -> [Location] {
        repository.fetchFavorites()
    }
}
