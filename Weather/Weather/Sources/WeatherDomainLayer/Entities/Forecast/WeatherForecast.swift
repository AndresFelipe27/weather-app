//
//  WeatherForecast.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

public struct WeatherForecast: Equatable {
    public let location: ForecastLocation
    public let current: CurrentWeather
    public let forecastDays: [ForecastDay]
}

public struct ForecastLocation: Equatable {
    public let name: String
    public let region: String
    public let country: String
    public let latitude: Double
    public let longitude: Double
    public let timeZoneId: String
    public let localtimeEpoch: Int
    public let localtime: String
}

public struct CurrentWeather: Equatable {
    public let lastUpdatedEpoch: Int
    public let lastUpdated: String
    public let tempC: Double
    public let tempF: Double
    public let isDay: Bool
    public let condition: WeatherCondition
    public let windMph: Double
    public let windKph: Double
    public let humidity: Int
    public let feelsLikeC: Double
    public let ultravioletIndex: Double
}

public struct ForecastDay: Equatable, Identifiable {
    public var id: String { date }

    public let date: String
    public let dateEpoch: Int
    public let day: DaySummary
    public let astro: Astro
    public let hours: [HourForecast]
}

public struct DaySummary: Equatable {
    public let maxTempC: Double
    public let minTempC: Double
    public let avgTempC: Double
    public let maxWindKph: Double
    public let totalPrecipMm: Double
    public let avgHumidity: Int
    public let rainChance: Int
    public let snowChance: Int
    public let condition: WeatherCondition
    public let ultravioletIndex: Double
}

public struct Astro: Equatable {
    public let sunrise: String
    public let sunset: String
    public let moonPhase: String
    public let moonIllumination: Int
}

public struct HourForecast: Equatable, Identifiable {
    public var id: Int { timeEpoch }

    public let timeEpoch: Int
    public let time: String
    public let tempC: Double
    public let isDay: Bool
    public let condition: WeatherCondition
    public let chanceOfRain: Int
    public let chanceOfSnow: Int
    public let windKph: Double
    public let humidity: Int
    public let ultravioletIndex: Double
}

public struct WeatherCondition: Equatable {
    public let text: String
    public let iconPath: String
    public let code: Int
}

extension HourForecast {
    var displayHour: String {
        HourTimeFormatter.shared.format(time)
    }
}
