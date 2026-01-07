//
//  WeatherAPIConfig.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

enum WeatherAPIConfig {
    static let apiKey: String = "de5553176da64306b86153651221606"

    // swiftlint:disable:next force_unwrapping
    static let baseURL: URL = URL(string: "https://api.weatherapi.com/v1/")!
}
