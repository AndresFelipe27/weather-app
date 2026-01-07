//
//  WeatherSearchRepository.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

protocol WeatherSearchRepository {
    func searchLocations(query: String) async throws -> [Location]
}
