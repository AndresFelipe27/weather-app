//
//  UserDefaultManaging.swift
//  Weather
//
//  Created by Usuario on 5/01/26.
//

import Foundation

protocol UserDefaultManaging: AnyObject {
    func getFavoriteLocations() -> [Location]
    func setFavoriteLocations(_ locations: [Location])
    func deleteFavoriteLocations()
}
