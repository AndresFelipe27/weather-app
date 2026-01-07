//
//  WeatherForecastModelTests.swift
//  WeatherTests
//
//  Created by Tests
//

import Testing
import Foundation
@testable import Weather

@Suite("WeatherForecast Model Tests")
@MainActor struct WeatherForecastModelTests {
    
    // MARK: - WeatherForecast Tests
    
    @Test("WeatherForecast initializes correctly")
    func testWeatherForecastInitialization() {
        let location = WeatherTestFactory.createMockForecastLocation()
        let current = WeatherTestFactory.createMockCurrentWeather()
        let forecastDays = [WeatherTestFactory.createMockForecastDay()]
        
        let forecast = WeatherForecast(
            location: location,
            current: current,
            forecastDays: forecastDays
        )
        
        #expect(forecast.location.name == "London")
        #expect(forecast.current.tempC == 15.0)
        #expect(forecast.forecastDays.count == 1)
    }
    
    @Test("WeatherForecast equality works correctly")
    func testWeatherForecastEquality() {
        let forecast1 = WeatherTestFactory.createMockWeatherForecast()
        let forecast2 = WeatherTestFactory.createMockWeatherForecast()
        
        #expect(forecast1 == forecast2)
    }
    
    // MARK: - ForecastLocation Tests
    
    @Test("ForecastLocation initializes with all properties")
    func testForecastLocationInitialization() {
        let location = ForecastLocation(
            name: "Paris",
            region: "Ile-de-France",
            country: "France",
            latitude: 48.8567,
            longitude: 2.3508,
            timeZoneId: "Europe/Paris",
            localtimeEpoch: 1704556800,
            localtime: "2026-01-06 13:00"
        )
        
        #expect(location.name == "Paris")
        #expect(location.region == "Ile-de-France")
        #expect(location.country == "France")
        #expect(location.latitude == 48.8567)
        #expect(location.longitude == 2.3508)
        #expect(location.timeZoneId == "Europe/Paris")
    }
    
    @Test("ForecastLocation handles negative coordinates")
    func testForecastLocationNegativeCoordinates() {
        let location = ForecastLocation(
            name: "Sydney",
            region: "New South Wales",
            country: "Australia",
            latitude: -33.8688,
            longitude: 151.2093,
            timeZoneId: "Australia/Sydney",
            localtimeEpoch: 1704556800,
            localtime: "2026-01-07 01:00"
        )
        
        #expect(location.latitude == -33.8688)
        #expect(location.longitude == 151.2093)
    }
    
    // MARK: - CurrentWeather Tests
    
    @Test("CurrentWeather initializes correctly")
    func testCurrentWeatherInitialization() {
        let condition = WeatherTestFactory.createMockWeatherCondition()
        let current = CurrentWeather(
            lastUpdatedEpoch: 1704556800,
            lastUpdated: "2026-01-06 12:00",
            tempC: 20.5,
            tempF: 68.9,
            isDay: true,
            condition: condition,
            windMph: 12.0,
            windKph: 19.3,
            humidity: 70,
            feelsLikeC: 19.0,
            ultravioletIndex: 5.0
        )
        
        #expect(current.tempC == 20.5)
        #expect(current.tempF == 68.9)
        #expect(current.isDay == true)
        #expect(current.humidity == 70)
        #expect(current.ultravioletIndex == 5.0)
    }
    
    @Test("CurrentWeather handles negative temperatures")
    func testCurrentWeatherNegativeTemperatures() {
        let current = CurrentWeather(
            lastUpdatedEpoch: 1704556800,
            lastUpdated: "2026-01-06 12:00",
            tempC: -10.0,
            tempF: 14.0,
            isDay: false,
            condition: WeatherTestFactory.createMockWeatherCondition(),
            windMph: 15.0,
            windKph: 24.1,
            humidity: 80,
            feelsLikeC: -15.0,
            ultravioletIndex: 0.0
        )
        
        #expect(current.tempC == -10.0)
        #expect(current.feelsLikeC == -15.0)
        #expect(current.isDay == false)
    }
    
    // MARK: - ForecastDay Tests
    
    @Test("ForecastDay is identifiable by date")
    func testForecastDayIdentifiable() {
        let day1 = WeatherTestFactory.createMockForecastDay(date: "2026-01-06")
        let day2 = WeatherTestFactory.createMockForecastDay(date: "2026-01-07")
        
        #expect(day1.id == "2026-01-06")
        #expect(day2.id == "2026-01-07")
        #expect(day1.id != day2.id)
    }
    
    @Test("ForecastDay contains all required components")
    func testForecastDayComponents() {
        let day = WeatherTestFactory.createMockForecastDay()
        
        #expect(day.date == "2026-01-06")
        #expect(day.day.maxTempC == 18.0)
        #expect(day.astro.sunrise == "07:30 AM")
        #expect(day.hours.count == 1)
    }
    
    // MARK: - DaySummary Tests
    
    @Test("DaySummary initializes with all weather data")
    func testDaySummaryInitialization() {
        let condition = WeatherTestFactory.createMockWeatherCondition()
        let summary = DaySummary(
            maxTempC: 25.0,
            minTempC: 15.0,
            avgTempC: 20.0,
            maxWindKph: 30.0,
            totalPrecipMm: 5.5,
            avgHumidity: 65,
            rainChance: 40,
            snowChance: 0,
            condition: condition,
            ultravioletIndex: 6.0
        )
        
        #expect(summary.maxTempC == 25.0)
        #expect(summary.minTempC == 15.0)
        #expect(summary.avgTempC == 20.0)
        #expect(summary.rainChance == 40)
        #expect(summary.snowChance == 0)
    }
    
    // MARK: - Astro Tests
    
    @Test("Astro initializes with astronomical data")
    func testAstroInitialization() {
        let astro = Astro(
            sunrise: "06:45 AM",
            sunset: "05:30 PM",
            moonPhase: "Full Moon",
            moonIllumination: 100
        )
        
        #expect(astro.sunrise == "06:45 AM")
        #expect(astro.sunset == "05:30 PM")
        #expect(astro.moonPhase == "Full Moon")
        #expect(astro.moonIllumination == 100)
    }
    
    // MARK: - HourForecast Tests
    
    @Test("HourForecast is identifiable by timeEpoch")
    func testHourForecastIdentifiable() {
        let hour1 = HourForecast(
            timeEpoch: 1704556800,
            time: "2026-01-06 12:00",
            tempC: 15.0,
            isDay: true,
            condition: WeatherTestFactory.createMockWeatherCondition(),
            chanceOfRain: 20,
            chanceOfSnow: 0,
            windKph: 16.1,
            humidity: 65,
            ultravioletIndex: 3.0
        )
        
        let hour2 = HourForecast(
            timeEpoch: 1704560400,
            time: "2026-01-06 13:00",
            tempC: 16.0,
            isDay: true,
            condition: WeatherTestFactory.createMockWeatherCondition(),
            chanceOfRain: 15,
            chanceOfSnow: 0,
            windKph: 17.5,
            humidity: 60,
            ultravioletIndex: 4.0
        )
        
        #expect(hour1.id == 1704556800)
        #expect(hour2.id == 1704560400)
        #expect(hour1.id != hour2.id)
    }
    
    @Test("HourForecast initializes with all properties")
    func testHourForecastInitialization() {
        let hour = HourForecast(
            timeEpoch: 1704556800,
            time: "2026-01-06 14:00",
            tempC: 17.5,
            isDay: true,
            condition: WeatherTestFactory.createMockWeatherCondition(),
            chanceOfRain: 25,
            chanceOfSnow: 5,
            windKph: 20.0,
            humidity: 70,
            ultravioletIndex: 4.5
        )
        
        #expect(hour.timeEpoch == 1704556800)
        #expect(hour.tempC == 17.5)
        #expect(hour.chanceOfRain == 25)
        #expect(hour.chanceOfSnow == 5)
        #expect(hour.windKph == 20.0)
    }
    
    // MARK: - WeatherCondition Tests
    
    @Test("WeatherCondition initializes correctly")
    func testWeatherConditionInitialization() {
        let condition = WeatherCondition(
            text: "Sunny",
            iconPath: "//cdn.weatherapi.com/weather/64x64/day/113.png",
            code: 1000
        )
        
        #expect(condition.text == "Sunny")
        #expect(condition.iconPath == "//cdn.weatherapi.com/weather/64x64/day/113.png")
        #expect(condition.code == 1000)
    }
    
    @Test("WeatherCondition equality works")
    func testWeatherConditionEquality() {
        let condition1 = WeatherCondition(text: "Cloudy", iconPath: "icon.png", code: 1003)
        let condition2 = WeatherCondition(text: "Cloudy", iconPath: "icon.png", code: 1003)
        let condition3 = WeatherCondition(text: "Rainy", iconPath: "icon2.png", code: 1063)
        
        #expect(condition1 == condition2)
        #expect(condition1 != condition3)
    }
    
    // MARK: - Complex Structure Tests
    
    @Test("WeatherForecast with multiple days")
    func testWeatherForecastMultipleDays() {
        let forecast = WeatherForecast(
            location: WeatherTestFactory.createMockForecastLocation(),
            current: WeatherTestFactory.createMockCurrentWeather(),
            forecastDays: [
                WeatherTestFactory.createMockForecastDay(date: "2026-01-06"),
                WeatherTestFactory.createMockForecastDay(date: "2026-01-07"),
                WeatherTestFactory.createMockForecastDay(date: "2026-01-08")
            ]
        )
        
        #expect(forecast.forecastDays.count == 3)
        #expect(forecast.forecastDays[0].date == "2026-01-06")
        #expect(forecast.forecastDays[1].date == "2026-01-07")
        #expect(forecast.forecastDays[2].date == "2026-01-08")
    }
    
    @Test("ForecastDay with multiple hours")
    func testForecastDayMultipleHours() {
        let hours = [
            HourForecast(
                timeEpoch: 1704556800,
                time: "2026-01-06 00:00",
                tempC: 12.0,
                isDay: false,
                condition: WeatherTestFactory.createMockWeatherCondition(),
                chanceOfRain: 10,
                chanceOfSnow: 0,
                windKph: 15.0,
                humidity: 70,
                ultravioletIndex: 0.0
            ),
            HourForecast(
                timeEpoch: 1704560400,
                time: "2026-01-06 12:00",
                tempC: 18.0,
                isDay: true,
                condition: WeatherTestFactory.createMockWeatherCondition(),
                chanceOfRain: 20,
                chanceOfSnow: 0,
                windKph: 20.0,
                humidity: 60,
                ultravioletIndex: 5.0
            )
        ]
        
        let day = ForecastDay(
            date: "2026-01-06",
            dateEpoch: 1704556800,
            day: WeatherTestFactory.createMockDaySummary(),
            astro: WeatherTestFactory.createMockAstro(),
            hours: hours
        )
        
        #expect(day.hours.count == 2)
        #expect(day.hours[0].isDay == false)
        #expect(day.hours[1].isDay == true)
    }
}
