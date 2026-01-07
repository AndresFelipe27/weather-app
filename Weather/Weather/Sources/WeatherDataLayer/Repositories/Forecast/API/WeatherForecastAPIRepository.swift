//
//  WeatherForecastAPIRepository.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

final class WeatherForecastAPIRepository: WeatherForecastRepository {
    var networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func getForecast(query: String, days: Int) async throws -> WeatherForecast {
        let endpoint = WeatherForecastEndPoint.forecast(query: query, days: days)
        let response = try await networkService.request(
            endpoint,
            interceptor: nil,
            as: WeatherForecastAPIResponse.self
        )
        return response.mapToModel()
    }
}
