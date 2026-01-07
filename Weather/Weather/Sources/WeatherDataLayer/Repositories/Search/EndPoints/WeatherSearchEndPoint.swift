//
//  WeatherSearchEndPoint.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

enum WeatherSearchEndPoint: APIEndpoint {
    case search(query: String)

    var baseURL: URL {
        WeatherAPIConfig.baseURL
    }

    var path: String {
        "search.json"
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
        case let .search(query):
            return [
                "key": WeatherAPIConfig.apiKey,
                "q": query
            ]
        }
    }
}
