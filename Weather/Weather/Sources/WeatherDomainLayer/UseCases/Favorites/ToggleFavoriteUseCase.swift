//
//  ToggleFavoriteUseCase.swift
//  Weather
//
//  Created by Usuario on 5/01/26.
//

import Foundation

protocol ToggleFavoriteUseCaseType {
    @discardableResult func execute(location: Location) -> Bool
}

final class ToggleFavoriteUseCase: ToggleFavoriteUseCaseType {
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository = FavoritesLocalRepository()) {
        self.repository = repository
    }

    @discardableResult func execute(location: Location) -> Bool {
        repository.toggleFavorite(location)
    }
}
