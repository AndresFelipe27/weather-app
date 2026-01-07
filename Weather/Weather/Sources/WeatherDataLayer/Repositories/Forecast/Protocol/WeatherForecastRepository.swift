//
//  WeatherForecastRepository.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

protocol WeatherForecastRepository {
    func getForecast(query: String, days: Int) async throws -> WeatherForecast
}
