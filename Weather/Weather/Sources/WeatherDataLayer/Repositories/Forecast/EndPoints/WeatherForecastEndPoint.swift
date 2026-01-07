//
//  WeatherForecastEndPoint.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

enum WeatherForecastEndPoint: APIEndpoint {
    case forecast(query: String, days: Int)

    var baseURL: URL {
        WeatherAPIConfig.baseURL
    }

    var path: String {
        "forecast.json"
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String: String]? {
        [:]
    }

    var parameters: [String: Any]? {
        [:]
    }

    var queryParameters: [String: String]? {
        switch self {
        case let .forecast(query, days):
            return [
                "key": WeatherAPIConfig.apiKey,
                "q": query,
                "days": String(days)
            ]
        }
    }
}
