//
//  WeatherForecastAPIRepositoryTests.swift
//  WeatherTests
//
//  Created by Tests
//

import Testing
import Foundation
@testable import Weather

@Suite("WeatherForecastAPIRepository Tests")
@MainActor struct WeatherForecastAPIRepositoryTests {
    
    // MARK: - Successful Response Tests
    
    @Test("getForecast returns mapped forecast on success")
    func testGetForecastSuccess() async throws {
        let mockAPIResponse = WeatherForecastAPIResponseFactory.createMockAPIResponse()
        let mockNetworkService = MockWeatherForecastNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        let forecast = try await repository.getForecast(query: "London", days: 3)
        
        #expect(forecast.location.name == "London")
        #expect(forecast.current.tempC == 15.0)
        #expect(forecast.forecastDays.count == 3)
        #expect(mockNetworkService.requestCallCount == 1)
    }
    
    @Test("getForecast returns forecast with all properties mapped")
    func testGetForecastMapsAllProperties() async throws {
        let mockAPIResponse = WeatherForecastAPIResponseFactory.createMockAPIResponse()
        let mockNetworkService = MockWeatherForecastNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        let forecast = try await repository.getForecast(query: "Paris", days: 5)
        
        // Verify location
        #expect(forecast.location.name == "London")
        #expect(forecast.location.country == "United Kingdom")
        #expect(forecast.location.latitude == 51.52)
        
        // Verify current weather
        #expect(forecast.current.tempC == 15.0)
        #expect(forecast.current.humidity == 65)
        #expect(forecast.current.isDay == true)
        
        // Verify forecast days
        #expect(forecast.forecastDays.count == 3)
        #expect(forecast.forecastDays.first?.day.maxTempC == 18.0)
    }
    
    // MARK: - Query Parameter Tests
    
    @Test("getForecast sends correct query parameter")
    func testGetForecastSendsCorrectQuery() async throws {
        let mockAPIResponse = WeatherForecastAPIResponseFactory.createMockAPIResponse()
        let mockNetworkService = MockWeatherForecastNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        _ = try await repository.getForecast(query: "Tokyo Japan", days: 7)
        
        let capturedEndpoint = try #require(mockNetworkService.lastEndpoint as? WeatherForecastEndPoint)
        
        if case .forecast(let query, let days) = capturedEndpoint {
            #expect(query == "Tokyo Japan")
            #expect(days == 7)
        } else {
            Issue.record("Expected forecast endpoint with correct parameters")
        }
    }
    
    @Test("getForecast uses correct endpoint type")
    func testGetForecastUsesCorrectEndpoint() async throws {
        let mockAPIResponse = WeatherForecastAPIResponseFactory.createMockAPIResponse()
        let mockNetworkService = MockWeatherForecastNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        _ = try await repository.getForecast(query: "Berlin", days: 3)
        
        #expect(mockNetworkService.lastEndpoint is WeatherForecastEndPoint)
    }
    
    @Test("getForecast passes nil interceptor")
    func testGetForecastPassesNilInterceptor() async throws {
        let mockAPIResponse = WeatherForecastAPIResponseFactory.createMockAPIResponse()
        let mockNetworkService = MockWeatherForecastNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        _ = try await repository.getForecast(query: "Madrid", days: 3)
        
        #expect(mockNetworkService.lastInterceptor == nil)
    }
    
    // MARK: - Error Handling Tests
    
    @Test("getForecast throws URLError on network failure")
    func testGetForecastNetworkError() async throws {
        let networkError = URLError(.notConnectedToInternet)
        let mockNetworkService = MockWeatherForecastNetworkService(shouldThrowError: true, error: networkError)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        await #expect(throws: URLError.self) {
            try await repository.getForecast(query: "London", days: 3)
        }
        #expect(mockNetworkService.requestCallCount == 1)
    }
    
    @Test("getForecast throws error on bad server response")
    func testGetForecastBadServerResponse() async throws {
        let serverError = URLError(.badServerResponse)
        let mockNetworkService = MockWeatherForecastNetworkService(shouldThrowError: true, error: serverError)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        await #expect(throws: URLError.self) {
            try await repository.getForecast(query: "London", days: 3)
        }
    }
    
    @Test("getForecast throws error on timeout")
    func testGetForecastTimeout() async throws {
        let timeoutError = URLError(.timedOut)
        let mockNetworkService = MockWeatherForecastNetworkService(shouldThrowError: true, error: timeoutError)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        await #expect(throws: URLError.self) {
            try await repository.getForecast(query: "London", days: 3)
        }
    }
    
    @Test("getForecast throws error on decoding failure")
    func testGetForecastDecodingError() async throws {
        let invalidData = "invalid json".data(using: .utf8)!
        let mockNetworkService = MockWeatherForecastNetworkService(mockResponse: invalidData)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        await #expect(throws: (any Error).self) {
            try await repository.getForecast(query: "London", days: 3)
        }
    }
    
    // MARK: - Data Mapping Tests
    
    @Test("getForecast correctly maps temperature values")
    func testGetForecastTemperatureMapping() async throws {
        let mockAPIResponse = WeatherForecastAPIResponseFactory.createMockAPIResponse()
        let mockNetworkService = MockWeatherForecastNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        let forecast = try await repository.getForecast(query: "London", days: 3)
        
        #expect(forecast.current.tempC == 15.0)
        #expect(forecast.current.tempF == 59.0)
        #expect(forecast.current.feelsLikeC == 14.0)
    }
    
    @Test("getForecast correctly maps coordinates")
    func testGetForecastCoordinateMapping() async throws {
        let mockAPIResponse = WeatherForecastAPIResponseFactory.createMockAPIResponse()
        let mockNetworkService = MockWeatherForecastNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        let forecast = try await repository.getForecast(query: "London", days: 3)
        
        #expect(forecast.location.latitude == 51.52)
        #expect(forecast.location.longitude == -0.11)
    }
    
    @Test("getForecast correctly maps forecast days")
    func testGetForecastDaysMapping() async throws {
        let mockAPIResponse = WeatherForecastAPIResponseFactory.createMockAPIResponse()
        let mockNetworkService = MockWeatherForecastNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        let forecast = try await repository.getForecast(query: "London", days: 3)
        
        #expect(forecast.forecastDays.count == 3)
        #expect(forecast.forecastDays[0].date == "2026-01-06")
        #expect(forecast.forecastDays[0].day.maxTempC == 18.0)
        #expect(forecast.forecastDays[0].day.minTempC == 12.0)
    }
    
    @Test("getForecast correctly maps hourly forecasts")
    func testGetForecastHourlyMapping() async throws {
        let mockAPIResponse = WeatherForecastAPIResponseFactory.createMockAPIResponse()
        let mockNetworkService = MockWeatherForecastNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        let forecast = try await repository.getForecast(query: "London", days: 3)
        
        let firstDay = try #require(forecast.forecastDays.first)
        #expect(firstDay.hours.count == 1)
        
        let firstHour = try #require(firstDay.hours.first)
        #expect(firstHour.tempC == 15.0)
        #expect(firstHour.humidity == 65)
        #expect(firstHour.windKph == 16.1)
    }
    
    // MARK: - Multiple Calls Tests
    
    @Test("getForecast handles multiple consecutive calls")
    func testGetForecastMultipleCalls() async throws {
        let mockAPIResponse = WeatherForecastAPIResponseFactory.createMockAPIResponse()
        let mockNetworkService = MockWeatherForecastNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        _ = try await repository.getForecast(query: "London", days: 3)
        _ = try await repository.getForecast(query: "Paris", days: 5)
        _ = try await repository.getForecast(query: "Tokyo", days: 7)
        
        #expect(mockNetworkService.requestCallCount == 3)
    }
    
    // MARK: - Special Cases Tests
    
    @Test("getForecast handles different days parameter")
    func testGetForecastDifferentDays() async throws {
        let mockAPIResponse = WeatherForecastAPIResponseFactory.createMockAPIResponse()
        let mockNetworkService = MockWeatherForecastNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherForecastAPIRepository(networkService: mockNetworkService)
        
        _ = try await repository.getForecast(query: "London", days: 14)
        
        let capturedEndpoint = try #require(mockNetworkService.lastEndpoint as? WeatherForecastEndPoint)
        
        if case .forecast(_, let days) = capturedEndpoint {
            #expect(days == 14)
        }
    }
}

// MARK: - Mock Network Service

final class MockWeatherForecastNetworkService: NetworkServiceProtocol {
    var mockResponse: Any?
    var shouldThrowError: Bool
    var error: Error?
    var requestCallCount = 0
    var lastEndpoint: (any APIEndpoint)?
    var lastInterceptor: (any RequestInterceptor)?
    
    init(mockResponse: Any? = nil, shouldThrowError: Bool = false, error: Error? = nil) {
        self.mockResponse = mockResponse
        self.shouldThrowError = shouldThrowError
        self.error = error
    }
    
    func request<T: Decodable>(
        _ endpoint: any APIEndpoint,
        interceptor: (any RequestInterceptor)?,
        as type: T.Type,
        retryCount: Int = 0,
        maxRetries: Int = 2
    ) async throws -> T {
        requestCallCount += 1
        lastEndpoint = endpoint
        lastInterceptor = interceptor
        
        if shouldThrowError {
            throw error ?? URLError(.unknown)
        }
        
        if let data = mockResponse as? Data {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
        
        if let response = mockResponse as? T {
            return response
        }
        
        if let forecastResponse = mockResponse as? WeatherForecastAPIResponse {
            let encoder = JSONEncoder()
            let data = try encoder.encode(forecastResponse)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
        
        throw URLError(.cannotDecodeContentData)
    }
}

// MARK: - API Response Factory

struct WeatherForecastAPIResponseFactory {
    static func createMockAPIResponse() -> WeatherForecastAPIResponse {
        WeatherForecastAPIResponse(
            location: createMockLocationAPIResponse(),
            current: createMockCurrentWeatherAPIResponse(),
            forecast: createMockForecastAPIResponse()
        )
    }
    
    static func createMockLocationAPIResponse() -> ForecastLocationAPIResponse {
        ForecastLocationAPIResponse(
            name: "London",
            region: "England",
            country: "United Kingdom",
            lat: 51.52,
            lon: -0.11,
            tzId: "Europe/London",
            localtimeEpoch: 1704556800,
            localtime: "2026-01-06 12:00"
        )
    }
    
    static func createMockCurrentWeatherAPIResponse() -> CurrentWeatherAPIResponse {
        CurrentWeatherAPIResponse(
            lastUpdatedEpoch: 1704556800,
            lastUpdated: "2026-01-06 12:00",
            tempC: 15.0,
            tempF: 59.0,
            isDay: 1,
            condition: createMockConditionAPIResponse(),
            windMph: 10.0,
            windKph: 16.1,
            windDegree: 180,
            windDir: "S",
            pressureMb: 1013.0,
            pressureIn: 29.91,
            precipMm: 0.0,
            precipIn: 0.0,
            humidity: 65,
            cloud: 50,
            feelslikeC: 14.0,
            feelslikeF: 57.2,
            windchillC: 14.0,
            windchillF: 57.2,
            heatindexC: 15.0,
            heatindexF: 59.0,
            dewpointC: 8.0,
            dewpointF: 46.4,
            visKm: 10.0,
            visMiles: 6.0,
            ultravioletIndex: 3.0,
            gustMph: 12.0,
            gustKph: 19.3
        )
    }
    
    static func createMockForecastAPIResponse() -> ForecastAPIResponse {
        ForecastAPIResponse(
            forecastday: [
                createMockForecastDayAPIResponse(date: "2026-01-06"),
                createMockForecastDayAPIResponse(date: "2026-01-07"),
                createMockForecastDayAPIResponse(date: "2026-01-08")
            ]
        )
    }
    
    static func createMockForecastDayAPIResponse(date: String) -> ForecastDayAPIResponse {
        ForecastDayAPIResponse(
            date: date,
            dateEpoch: 1704556800,
            day: createMockDayAPIResponse(),
            astro: createMockAstroAPIResponse(),
            hour: [createMockHourAPIResponse()]
        )
    }
    
    static func createMockDayAPIResponse() -> DayAPIResponse {
        DayAPIResponse(
            maxtempC: 18.0,
            maxtempF: 64.4,
            mintempC: 12.0,
            mintempF: 53.6,
            avgtempC: 15.0,
            avgtempF: 59.0,
            maxwindMph: 12.5,
            maxwindKph: 20.0,
            totalprecipMm: 2.5,
            totalprecipIn: 0.1,
            totalsnowCm: 0.0,
            avgvisKm: 10.0,
            avgvisMiles: 6.0,
            avghumidity: 65,
            dailyWillItRain: 1,
            dailyChanceOfRain: 30,
            dailyWillItSnow: 0,
            dailyChanceOfSnow: 0,
            condition: createMockConditionAPIResponse(),
            ultravioletIndex: 3.0
        )
    }
    
    static func createMockAstroAPIResponse() -> AstroAPIResponse {
        AstroAPIResponse(
            sunrise: "07:30 AM",
            sunset: "04:30 PM",
            moonrise: "08:15 PM",
            moonset: "09:45 AM",
            moonPhase: "Waxing Gibbous",
            moonIllumination: 75,
            isMoonUp: 1,
            isSunUp: 1
        )
    }
    
    static func createMockHourAPIResponse() -> HourAPIResponse {
        HourAPIResponse(
            timeEpoch: 1704556800,
            time: "2026-01-06 12:00",
            tempC: 15.0,
            tempF: 59.0,
            isDay: 1,
            condition: createMockConditionAPIResponse(),
            windMph: 10.0,
            windKph: 16.1,
            windDegree: 180,
            windDir: "S",
            pressureMb: 1013.0,
            pressureIn: 29.91,
            precipMm: 0.0,
            precipIn: 0.0,
            snowCm: 0.0,
            humidity: 65,
            cloud: 50,
            feelslikeC: 14.0,
            feelslikeF: 57.2,
            windchillC: 14.0,
            windchillF: 57.2,
            heatindexC: 15.0,
            heatindexF: 59.0,
            dewpointC: 8.0,
            dewpointF: 46.4,
            willItRain: 0,
            chanceOfRain: 20,
            willItSnow: 0,
            chanceOfSnow: 0,
            visKm: 10.0,
            visMiles: 6.0,
            gustMph: 12.0,
            gustKph: 19.3,
            ultravioletIndex: 3.0
        )
    }
    
    static func createMockConditionAPIResponse() -> WeatherConditionAPIResponse {
        WeatherConditionAPIResponse(
            text: "Partly cloudy",
            icon: "//cdn.weatherapi.com/weather/64x64/day/116.png",
            code: 1003
        )
    }
}
