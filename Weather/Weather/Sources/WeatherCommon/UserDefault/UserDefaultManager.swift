//
//  UserDefaultManager.swift
//  Weather
//
//  Created by Usuario on 5/01/26.
//

import Foundation

final class UserDefaultManager: UserDefaultManaging {
    enum UserDefaultKey {
        static let favoriteLocations: String = "weather_favorite_locations"
    }

    init() {}

    func getFavoriteLocations() -> [Location] {
        UserDefaultWrapper.get(
            key: UserDefaultKey.favoriteLocations,
            as: [Location].self
        ) ?? []
    }

    func setFavoriteLocations(_ locations: [Location]) {
        UserDefaultWrapper.set(
            value: locations,
            forKey: UserDefaultKey.favoriteLocations
        )
    }

    func deleteFavoriteLocations() {
        UserDefaultWrapper.delete(key: UserDefaultKey.favoriteLocations)
    }
}
