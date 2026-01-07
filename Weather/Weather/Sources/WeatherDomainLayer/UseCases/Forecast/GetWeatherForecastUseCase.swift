//
//  GetWeatherForecastUseCase.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

protocol GetWeatherForecastUseCaseType {
    func execute(query: String, days: Int) async throws -> WeatherForecast
}

final class GetWeatherForecastUseCase: GetWeatherForecastUseCaseType {
    private let repository: WeatherForecastRepository

    init(repository: WeatherForecastRepository = WeatherForecastAPIRepository()) {
        self.repository = repository
    }

    func execute(query: String, days: Int) async throws -> WeatherForecast {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw ForecastError.emptyQuery }
        return try await repository.getForecast(query: query, days: days)
    }
}

enum ForecastError: Error {
    case emptyQuery
}
