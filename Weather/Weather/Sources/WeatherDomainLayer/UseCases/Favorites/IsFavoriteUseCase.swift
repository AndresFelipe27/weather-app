//
//  IsFavoriteUseCase.swift
//  Weather
//
//  Created by Usuario on 5/01/26.
//

import Foundation

protocol IsFavoriteUseCaseType {
    func execute(location: Location) -> Bool
}

final class IsFavoriteUseCase: IsFavoriteUseCaseType {
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository = FavoritesLocalRepository()) {
        self.repository = repository
    }

    func execute(location: Location) -> Bool {
        repository.isFavorite(location)
    }
}
