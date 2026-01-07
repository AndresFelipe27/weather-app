//
//  WeatherForecastAPIResponse.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

public struct WeatherForecastAPIResponse: Codable {
    public let location: ForecastLocationAPIResponse
    public let current: CurrentWeatherAPIResponse
    public let forecast: ForecastAPIResponse
}

public struct ForecastLocationAPIResponse: Codable {
    public let name: String
    public let region: String
    public let country: String
    public let lat: Double
    public let lon: Double
    public let tzId: String
    public let localtimeEpoch: Int
    public let localtime: String

    private enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon, localtime
        case tzId = "tz_id"
        case localtimeEpoch = "localtime_epoch"
    }
}

public struct CurrentWeatherAPIResponse: Codable {
    public let lastUpdatedEpoch: Int
    public let lastUpdated: String
    public let tempC: Double
    public let tempF: Double
    public let isDay: Int
    public let condition: WeatherConditionAPIResponse
    public let windMph: Double
    public let windKph: Double
    public let windDegree: Int
    public let windDir: String
    public let pressureMb: Double
    public let pressureIn: Double
    public let precipMm: Double
    public let precipIn: Double
    public let humidity: Int
    public let cloud: Int
    public let feelslikeC: Double
    public let feelslikeF: Double
    public let windchillC: Double
    public let windchillF: Double
    public let heatindexC: Double
    public let heatindexF: Double
    public let dewpointC: Double
    public let dewpointF: Double
    public let visKm: Double
    public let visMiles: Double
    public let ultravioletIndex: Double
    public let gustMph: Double
    public let gustKph: Double

    private enum CodingKeys: String, CodingKey {
        case condition, humidity, cloud
        case ultravioletIndex = "uv"
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMb = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case visKm = "vis_km"
        case visMiles = "vis_miles"
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
    }
}

public struct ForecastAPIResponse: Codable {
    public let forecastday: [ForecastDayAPIResponse]
}

public struct ForecastDayAPIResponse: Codable {
    public let date: String
    public let dateEpoch: Int
    public let day: DayAPIResponse
    public let astro: AstroAPIResponse
    public let hour: [HourAPIResponse]

    private enum CodingKeys: String, CodingKey {
        case date, day, astro, hour
        case dateEpoch = "date_epoch"
    }
}

public struct DayAPIResponse: Codable {
    public let maxtempC: Double
    public let maxtempF: Double
    public let mintempC: Double
    public let mintempF: Double
    public let avgtempC: Double
    public let avgtempF: Double
    public let maxwindMph: Double
    public let maxwindKph: Double
    public let totalprecipMm: Double
    public let totalprecipIn: Double
    public let totalsnowCm: Double
    public let avgvisKm: Double
    public let avgvisMiles: Double
    public let avghumidity: Int
    public let dailyWillItRain: Int
    public let dailyChanceOfRain: Int
    public let dailyWillItSnow: Int
    public let dailyChanceOfSnow: Int
    public let condition: WeatherConditionAPIResponse
    public let ultravioletIndex: Double

    private enum CodingKeys: String, CodingKey {
        case avghumidity, condition
        case ultravioletIndex = "uv"
        case maxtempC = "maxtemp_c"
        case maxtempF = "maxtemp_f"
        case mintempC = "mintemp_c"
        case mintempF = "mintemp_f"
        case avgtempC = "avgtemp_c"
        case avgtempF = "avgtemp_f"
        case maxwindMph = "maxwind_mph"
        case maxwindKph = "maxwind_kph"
        case totalprecipMm = "totalprecip_mm"
        case totalprecipIn = "totalprecip_in"
        case totalsnowCm = "totalsnow_cm"
        case avgvisKm = "avgvis_km"
        case avgvisMiles = "avgvis_miles"
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfSnow = "daily_chance_of_snow"
    }
}

public struct AstroAPIResponse: Codable {
    public let sunrise: String
    public let sunset: String
    public let moonrise: String
    public let moonset: String
    public let moonPhase: String
    public let moonIllumination: Int
    public let isMoonUp: Int
    public let isSunUp: Int

    private enum CodingKeys: String, CodingKey {
        case sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case moonIllumination = "moon_illumination"
        case isMoonUp = "is_moon_up"
        case isSunUp = "is_sun_up"
    }
}

public struct HourAPIResponse: Codable {
    public let timeEpoch: Int
    public let time: String
    public let tempC: Double
    public let tempF: Double
    public let isDay: Int
    public let condition: WeatherConditionAPIResponse
    public let windMph: Double
    public let windKph: Double
    public let windDegree: Int
    public let windDir: String
    public let pressureMb: Double
    public let pressureIn: Double
    public let precipMm: Double
    public let precipIn: Double
    public let snowCm: Double
    public let humidity: Int
    public let cloud: Int
    public let feelslikeC: Double
    public let feelslikeF: Double
    public let windchillC: Double
    public let windchillF: Double
    public let heatindexC: Double
    public let heatindexF: Double
    public let dewpointC: Double
    public let dewpointF: Double
    public let willItRain: Int
    public let chanceOfRain: Int
    public let willItSnow: Int
    public let chanceOfSnow: Int
    public let visKm: Double
    public let visMiles: Double
    public let gustMph: Double
    public let gustKph: Double
    public let ultravioletIndex: Double

    private enum CodingKeys: String, CodingKey {
        case time, condition, humidity, cloud
        case ultravioletIndex = "uv"
        case timeEpoch = "time_epoch"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMb = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case snowCm = "snow_cm"
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case willItRain = "will_it_rain"
        case chanceOfRain = "chance_of_rain"
        case willItSnow = "will_it_snow"
        case chanceOfSnow = "chance_of_snow"
        case visKm = "vis_km"
        case visMiles = "vis_miles"
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
    }
}

public struct WeatherConditionAPIResponse: Codable {
    public let text: String
    public let icon: String
    public let code: Int
}
