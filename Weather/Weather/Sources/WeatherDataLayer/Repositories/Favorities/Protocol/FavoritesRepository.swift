//
//  FavoritesRepository.swift
//  Weather
//
//  Created by Usuario on 5/01/26.
//

import Foundation

protocol FavoritesRepository {
    func fetchFavorites() -> [Location]
    func isFavorite(_ location: Location) -> Bool

    @discardableResult func toggleFavorite(_ location: Location) -> Bool
}
