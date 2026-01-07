//
//  LocationSearchAPIResponse.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

struct LocationSearchAPIResponse: Codable {
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let url: String
}

extension LocationSearchAPIResponse {
    func mapToModel() -> Location {
        Location(
            id: id,
            name: name,
            region: region,
            country: country,
            latitude: lat,
            longitude: lon,
            url: url
        )
    }
}

extension Array where Element == LocationSearchAPIResponse {
    func mapToModel() -> [Location] {
        map { $0.mapToModel() }
    }
}
