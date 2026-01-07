//
//  WeatherSearchAPIRepository.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

final class WeatherSearchAPIRepository: WeatherSearchRepository {
    var networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func searchLocations(query: String) async throws -> [Location] {
        let endpoint = WeatherSearchEndPoint.search(query: query)
        let response = try await networkService.request(
            endpoint,
            interceptor: nil,
            as: [LocationSearchAPIResponse].self
        )
        return response.mapToModel()
    }
}
