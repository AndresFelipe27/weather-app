//
//  FavoritesLocalRepository.swift
//  Weather
//
//  Created by Usuario on 5/01/26.
//

import Foundation

final class FavoritesLocalRepository: FavoritesRepository {
    private let userDefaultManager: UserDefaultManaging

    init(userDefaultManager: UserDefaultManaging = UserDefaultManager()) {
        self.userDefaultManager = userDefaultManager
    }

    func fetchFavorites() -> [Location] {
        userDefaultManager.getFavoriteLocations()
    }

    func isFavorite(_ location: Location) -> Bool {
        let favorites = userDefaultManager.getFavoriteLocations()
        return favorites.contains(where: { $0.id == location.id })
    }

    @discardableResult func toggleFavorite(_ location: Location) -> Bool {
        var favorites = userDefaultManager.getFavoriteLocations()

        if let index = favorites.firstIndex(where: { $0.id == location.id }) {
            favorites.remove(at: index)
            userDefaultManager.setFavoriteLocations(favorites)
            return false
        } else {
            favorites.append(location)
            userDefaultManager.setFavoriteLocations(favorites)
            return true
        }
    }
}
