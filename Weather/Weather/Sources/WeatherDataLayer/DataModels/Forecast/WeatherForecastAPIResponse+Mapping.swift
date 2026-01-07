//
//  WeatherForecastAPIResponse+Mapping.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

public extension WeatherForecastAPIResponse {
    func mapToModel() -> WeatherForecast {
        WeatherForecast(
            location: location.mapToModel(),
            current: current.mapToModel(),
            forecastDays: forecast.forecastday.map { $0.mapToModel() }
        )
    }
}

public extension ForecastLocationAPIResponse {
    func mapToModel() -> ForecastLocation {
        ForecastLocation(
            name: name,
            region: region,
            country: country,
            latitude: lat,
            longitude: lon,
            timeZoneId: tzId,
            localtimeEpoch: localtimeEpoch,
            localtime: localtime
        )
    }
}

public extension CurrentWeatherAPIResponse {
    func mapToModel() -> CurrentWeather {
        CurrentWeather(
            lastUpdatedEpoch: lastUpdatedEpoch,
            lastUpdated: lastUpdated,
            tempC: tempC,
            tempF: tempF,
            isDay: isDay == .isDay,
            condition: condition.mapToModel(),
            windMph: windMph,
            windKph: windKph,
            humidity: humidity,
            feelsLikeC: feelslikeC,
            ultravioletIndex: ultravioletIndex
        )
    }
}

public extension ForecastDayAPIResponse {
    func mapToModel() -> ForecastDay {
        ForecastDay(
            date: date,
            dateEpoch: dateEpoch,
            day: day.mapToModel(),
            astro: astro.mapToModel(),
            hours: hour.map { $0.mapToModel() }
        )
    }
}

public extension DayAPIResponse {
    func mapToModel() -> DaySummary {
        DaySummary(
            maxTempC: maxtempC,
            minTempC: mintempC,
            avgTempC: avgtempC,
            maxWindKph: maxwindKph,
            totalPrecipMm: totalprecipMm,
            avgHumidity: avghumidity,
            rainChance: dailyChanceOfRain,
            snowChance: dailyChanceOfSnow,
            condition: condition.mapToModel(),
            ultravioletIndex: ultravioletIndex
        )
    }
}

public extension AstroAPIResponse {
    func mapToModel() -> Astro {
        Astro(
            sunrise: sunrise,
            sunset: sunset,
            moonPhase: moonPhase,
            moonIllumination: moonIllumination
        )
    }
}

public extension HourAPIResponse {
    func mapToModel() -> HourForecast {
        HourForecast(
            timeEpoch: timeEpoch,
            time: time,
            tempC: tempC,
            isDay: isDay == .isDay,
            condition: condition.mapToModel(),
            chanceOfRain: chanceOfRain,
            chanceOfSnow: chanceOfSnow,
            windKph: windKph,
            humidity: humidity,
            ultravioletIndex: Double(ultravioletIndex)
        )
    }
}

public extension WeatherConditionAPIResponse {
    func mapToModel() -> WeatherCondition {
        WeatherCondition(
            text: text.trimmingCharacters(in: .whitespacesAndNewlines),
            iconPath: icon,
            code: code
        )
    }
}

private extension Int {
    static let isDay: Int = 1
}
