//
//  ForecastViewModelTests.swift
//  WeatherTests
//
//  Created by Tests
//

import Testing
import Combine
import Foundation
@testable import Weather

@Suite("ForecastViewModel Tests")
@MainActor struct ForecastViewModelTests {
    
    // MARK: - Initial State Tests
    
    @Test("ViewModel initializes with correct default state")
    func testInitialState() async {
        let location = WeatherTestFactory.createMockLocation()
        let coordinator = MockNavigationCoordinator()
        let getForecastUseCase = MockGetWeatherForecastUseCase()
        let isFavoriteUseCase = MockIsFavoriteUseCase(isFavorite: false)
        let toggleFavoriteUseCase = MockToggleFavoriteUseCase()
        
        let viewModel = ForecastViewModel(
            selectedLocation: location,
            coordinator: coordinator,
            getForecastUseCase: getForecastUseCase,
            isFavoriteUseCase: isFavoriteUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
        
        #expect(viewModel.state == .idle)
        #expect(viewModel.isFavorite == false)
        #expect(viewModel.selectedLocation.id == location.id)
        #expect(viewModel.title == location.name)
    }
    
    @Test("ViewModel title returns location name")
    func testTitleReturnsLocationName() async {
        let location = WeatherTestFactory.createMockLocation(name: "Tokyo")
        let coordinator = MockNavigationCoordinator()
        let viewModel = ForecastViewModel(
            selectedLocation: location,
            coordinator: coordinator,
            getForecastUseCase: MockGetWeatherForecastUseCase(),
            isFavoriteUseCase: MockIsFavoriteUseCase(),
            toggleFavoriteUseCase: MockToggleFavoriteUseCase()
        )
        
        #expect(viewModel.title == "Tokyo")
    }
    
    // MARK: - OnAppear Tests
    
    @Test("onAppear checks if location is favorite and fetches forecast")
    func testOnAppearChecksFavoriteAndFetches() async throws {
        let location = WeatherTestFactory.createMockLocation()
        let coordinator = MockNavigationCoordinator()
        let mockForecast = WeatherTestFactory.createMockWeatherForecast()
        let getForecastUseCase = MockGetWeatherForecastUseCase(mockResult: .success(mockForecast))
        let isFavoriteUseCase = MockIsFavoriteUseCase(isFavorite: true)
        let toggleFavoriteUseCase = MockToggleFavoriteUseCase()
        
        let viewModel = ForecastViewModel(
            selectedLocation: location,
            coordinator: coordinator,
            getForecastUseCase: getForecastUseCase,
            isFavoriteUseCase: isFavoriteUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
        
        viewModel.onAppear()
        
        try await Task.sleep(for: .milliseconds(100))
        
        #expect(viewModel.isFavorite == true)
        #expect(isFavoriteUseCase.executeCallCount == 1)
        #expect(getForecastUseCase.executeCallCount == 1)
        
        if case .loaded(let forecast) = viewModel.state {
            #expect(forecast.location.name == mockForecast.location.name)
        } else {
            Issue.record("Expected loaded state")
        }
    }
    
    @Test("onAppear sets loading state before fetching")
    func testOnAppearSetsLoadingState() async throws {
        let location = WeatherTestFactory.createMockLocation()
        let coordinator = MockNavigationCoordinator()
        let getForecastUseCase = MockGetWeatherForecastUseCase(delay: 500)
        
        let viewModel = ForecastViewModel(
            selectedLocation: location,
            coordinator: coordinator,
            getForecastUseCase: getForecastUseCase,
            isFavoriteUseCase: MockIsFavoriteUseCase(),
            toggleFavoriteUseCase: MockToggleFavoriteUseCase()
        )
        
        viewModel.onAppear()
        
        try await Task.sleep(for: .milliseconds(50))
        
        #expect(viewModel.state == .loading)
    }
    
    // MARK: - Fetch Success Tests
    
    @Test("Fetch successfully loads forecast data")
    func testFetchSuccessLoadsData() async throws {
        let location = WeatherTestFactory.createMockLocation()
        let coordinator = MockNavigationCoordinator()
        let mockForecast = WeatherTestFactory.createMockWeatherForecast()
        let getForecastUseCase = MockGetWeatherForecastUseCase(mockResult: .success(mockForecast))
        
        let viewModel = ForecastViewModel(
            selectedLocation: location,
            coordinator: coordinator,
            getForecastUseCase: getForecastUseCase,
            isFavoriteUseCase: MockIsFavoriteUseCase(),
            toggleFavoriteUseCase: MockToggleFavoriteUseCase()
        )
        
        viewModel.onAppear()
        
        try await Task.sleep(for: .milliseconds(100))
        
        if case .loaded(let forecast) = viewModel.state {
            #expect(forecast.current.tempC == mockForecast.current.tempC)
            #expect(forecast.forecastDays.count == mockForecast.forecastDays.count)
        } else {
            Issue.record("Expected loaded state")
        }
    }
    
    @Test("Fetch uses correct query format")
    func testFetchUsesCorrectQueryFormat() async throws {
        let location = WeatherTestFactory.createMockLocation(
            name: "London",
            region: "England",
            country: "United Kingdom"
        )
        let coordinator = MockNavigationCoordinator()
        let getForecastUseCase = MockGetWeatherForecastUseCase(
            mockResult: .success(WeatherTestFactory.createMockWeatherForecast())
        )
        
        let viewModel = ForecastViewModel(
            selectedLocation: location,
            coordinator: coordinator,
            getForecastUseCase: getForecastUseCase,
            isFavoriteUseCase: MockIsFavoriteUseCase(),
            toggleFavoriteUseCase: MockToggleFavoriteUseCase()
        )
        
        viewModel.onAppear()
        
        try await Task.sleep(for: .milliseconds(100))
        
        let expectedQuery = "London England United Kingdom"
        #expect(getForecastUseCase.lastQuery == expectedQuery)
        #expect(getForecastUseCase.lastDays == 3)
    }
    
    // MARK: - Error Handling Tests
    
//    @Test("Fetch handles API error response")
//    func testFetchHandlesAPIError() async throws {
//        let location = WeatherTestFactory.createMockLocation()
//        let coordinator = MockNavigationCoordinator()
//        let apiError = APIErrorResponse(error: ErrorDetails(code: 400, message: "Invalid location"))
//        let getForecastUseCase = MockGetWeatherForecastUseCase(mockResult: .failure(apiError))
//        
//        let viewModel = ForecastViewModel(
//            selectedLocation: location,
//            coordinator: coordinator,
//            getForecastUseCase: getForecastUseCase,
//            isFavoriteUseCase: MockIsFavoriteUseCase(),
//            toggleFavoriteUseCase: MockToggleFavoriteUseCase()
//        )
//        
//        viewModel.onAppear()
//        
//        try await Task.sleep(for: .milliseconds(100))
//        
//        if case .error(let message) = viewModel.state {
//            #expect(message == "Invalid location")
//        } else {
//            Issue.record("Expected error state")
//        }
//    }
    
    @Test("Fetch handles unknown error")
    func testFetchHandlesUnknownError() async throws {
        let location = WeatherTestFactory.createMockLocation()
        let coordinator = MockNavigationCoordinator()
        let unknownError = URLError(.timedOut)
        let getForecastUseCase = MockGetWeatherForecastUseCase(mockResult: .failure(unknownError))
        
        let viewModel = ForecastViewModel(
            selectedLocation: location,
            coordinator: coordinator,
            getForecastUseCase: getForecastUseCase,
            isFavoriteUseCase: MockIsFavoriteUseCase(),
            toggleFavoriteUseCase: MockToggleFavoriteUseCase()
        )
        
        viewModel.onAppear()
        
        try await Task.sleep(for: .milliseconds(100))
        
        if case .error(let message) = viewModel.state {
            #expect(message == "Unknown error")
        } else {
            Issue.record("Expected error state")
        }
    }
    
    // MARK: - Favorite Toggle Tests
    
    @Test("onToggleFavorite changes favorite state")
    func testToggleFavorite() async throws {
        let location = WeatherTestFactory.createMockLocation()
        let coordinator = MockNavigationCoordinator()
        let toggleFavoriteUseCase = MockToggleFavoriteUseCase(toggledState: false)
        
        let viewModel = ForecastViewModel(
            selectedLocation: location,
            coordinator: coordinator,
            getForecastUseCase: MockGetWeatherForecastUseCase(),
            isFavoriteUseCase: MockIsFavoriteUseCase(isFavorite: false),
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
        
        #expect(toggleFavoriteUseCase.toggledState == false)
        #expect(viewModel.isFavorite == false)
        
        viewModel.onToggleFavorite()
        
        #expect(toggleFavoriteUseCase.toggledState == true)
        #expect(viewModel.isFavorite == true)
        #expect(toggleFavoriteUseCase.executeCallCount == 1)
    }
    
    @Test("onToggleFavorite can toggle multiple times")
    func testToggleFavoriteMultipleTimes() async {
        let location = WeatherTestFactory.createMockLocation()
        let coordinator = MockNavigationCoordinator()
        let toggleFavoriteUseCase = MockToggleFavoriteUseCase()
        
        let viewModel = ForecastViewModel(
            selectedLocation: location,
            coordinator: coordinator,
            getForecastUseCase: MockGetWeatherForecastUseCase(),
            isFavoriteUseCase: MockIsFavoriteUseCase(isFavorite: false),
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
        
        viewModel.onToggleFavorite()
        #expect(toggleFavoriteUseCase.executeCallCount == 1)
        
        viewModel.onToggleFavorite()
        #expect(toggleFavoriteUseCase.executeCallCount == 2)
        
        viewModel.onToggleFavorite()
        #expect(toggleFavoriteUseCase.executeCallCount == 3)
    }
    
    // MARK: - Navigation Tests
    
    @Test("onTapBack triggers coordinator pop")
    func testOnTapBackTriggersCoordinatorPop() async {
        let location = WeatherTestFactory.createMockLocation()
        let coordinator = MockNavigationCoordinator()
        
        let viewModel = ForecastViewModel(
            selectedLocation: location,
            coordinator: coordinator,
            getForecastUseCase: MockGetWeatherForecastUseCase(),
            isFavoriteUseCase: MockIsFavoriteUseCase(),
            toggleFavoriteUseCase: MockToggleFavoriteUseCase()
        )
        
        viewModel.onTapBack()
        
        #expect(coordinator.popCallCount == 1)
    }
    
    // MARK: - OnDisappear Tests
    
    @Test("onDisappear cancels ongoing task")
    func testOnDisappearCancelsTask() async throws {
        let location = WeatherTestFactory.createMockLocation()
        let coordinator = MockNavigationCoordinator()
        let getForecastUseCase = MockGetWeatherForecastUseCase(delay: 1000)
        
        let viewModel = ForecastViewModel(
            selectedLocation: location,
            coordinator: coordinator,
            getForecastUseCase: getForecastUseCase,
            isFavoriteUseCase: MockIsFavoriteUseCase(),
            toggleFavoriteUseCase: MockToggleFavoriteUseCase()
        )
        
        viewModel.onAppear()
        try await Task.sleep(for: .milliseconds(50))
        
        #expect(viewModel.state == .loading)
        
        viewModel.onDisappear()
        try await Task.sleep(for: .milliseconds(100))
        
        #expect(viewModel.state != .loading)
    }
    
    // MARK: - State Equatable Tests
    
    @Test("State enum equality works correctly")
    func testStateEquality() {
        let forecast1 = WeatherTestFactory.createMockWeatherForecast()
        let forecast2 = WeatherTestFactory.createMockWeatherForecast()
        
        #expect(ForecastViewModel.State.idle == .idle)
        #expect(ForecastViewModel.State.loading == .loading)
        #expect(ForecastViewModel.State.loaded(forecast1) == .loaded(forecast2))
        #expect(ForecastViewModel.State.error(message: "Test") == .error(message: "Test"))
        
        #expect(ForecastViewModel.State.idle != .loading)
        #expect(ForecastViewModel.State.error(message: "Error 1") != .error(message: "Error 2"))
    }
}

// MARK: - Mock Use Cases

final class MockGetWeatherForecastUseCase: GetWeatherForecastUseCaseType {
    var mockResult: Result<WeatherForecast, Error>
    var executeCallCount = 0
    var lastQuery: String?
    var lastDays: Int?
    var delay: Int = 0
    
    init(mockResult: Result<WeatherForecast, Error> = .success(WeatherTestFactory.createMockWeatherForecast()), delay: Int = 0) {
        self.mockResult = mockResult
        self.delay = delay
    }
    
    func execute(query: String, days: Int) async throws -> WeatherForecast {
        executeCallCount += 1
        lastQuery = query
        lastDays = days
        
        if delay > 0 {
            try? await Task.sleep(for: .milliseconds(delay))
        }
        
        switch mockResult {
        case .success(let forecast):
            return forecast
        case .failure(let error):
            throw error
        }
    }
}

final class MockIsFavoriteUseCase: IsFavoriteUseCaseType {
    var isFavorite: Bool
    var executeCallCount = 0
    
    init(isFavorite: Bool = false) {
        self.isFavorite = isFavorite
    }
    
    func execute(location: Location) -> Bool {
        executeCallCount += 1
        return isFavorite
    }
}

final class MockToggleFavoriteUseCase: ToggleFavoriteUseCaseType {
    var executeCallCount = 0
    var toggledState: Bool
    
    init(toggledState: Bool = false) {
        self.toggledState = toggledState
    }
    
    func execute(location: Location) -> Bool {
        executeCallCount += 1
        toggledState.toggle()
        return toggledState
    }
}

// MARK: - Test Factory

struct WeatherTestFactory {
    static func createMockLocation(
        id: Int = 1,
        name: String = "London",
        region: String = "England",
        country: String = "United Kingdom",
        latitude: Double = 51.52,
        longitude: Double = -0.11,
        url: String = "london-uk"
    ) -> Location {
        Location(
            id: id,
            name: name,
            region: region,
            country: country,
            latitude: latitude,
            longitude: longitude,
            url: url
        )
    }
    
    static func createMockWeatherForecast() -> WeatherForecast {
        WeatherForecast(
            location: createMockForecastLocation(),
            current: createMockCurrentWeather(),
            forecastDays: [
                createMockForecastDay(date: "2026-01-06"),
                createMockForecastDay(date: "2026-01-07"),
                createMockForecastDay(date: "2026-01-08")
            ]
        )
    }
    
    static func createMockForecastLocation() -> ForecastLocation {
        ForecastLocation(
            name: "London",
            region: "England",
            country: "United Kingdom",
            latitude: 51.52,
            longitude: -0.11,
            timeZoneId: "Europe/London",
            localtimeEpoch: 1704556800,
            localtime: "2026-01-06 12:00"
        )
    }
    
    static func createMockCurrentWeather() -> CurrentWeather {
        CurrentWeather(
            lastUpdatedEpoch: 1704556800,
            lastUpdated: "2026-01-06 12:00",
            tempC: 15.0,
            tempF: 59.0,
            isDay: true,
            condition: createMockWeatherCondition(),
            windMph: 10.0,
            windKph: 16.1,
            humidity: 65,
            feelsLikeC: 14.0,
            ultravioletIndex: 3.0
        )
    }
    
    static func createMockForecastDay(date: String = "2026-01-06") -> ForecastDay {
        ForecastDay(
            date: date,
            dateEpoch: 1704556800,
            day: createMockDaySummary(),
            astro: createMockAstro(),
            hours: [createMockHourForecast()]
        )
    }
    
    static func createMockDaySummary() -> DaySummary {
        DaySummary(
            maxTempC: 18.0,
            minTempC: 12.0,
            avgTempC: 15.0,
            maxWindKph: 20.0,
            totalPrecipMm: 2.5,
            avgHumidity: 65,
            rainChance: 30,
            snowChance: 0,
            condition: createMockWeatherCondition(),
            ultravioletIndex: 3.0
        )
    }
    
    static func createMockAstro() -> Astro {
        Astro(
            sunrise: "07:30 AM",
            sunset: "04:30 PM",
            moonPhase: "Waxing Gibbous",
            moonIllumination: 75
        )
    }
    
    static func createMockHourForecast() -> HourForecast {
        HourForecast(
            timeEpoch: 1704556800,
            time: "2026-01-06 12:00",
            tempC: 15.0,
            isDay: true,
            condition: createMockWeatherCondition(),
            chanceOfRain: 20,
            chanceOfSnow: 0,
            windKph: 16.1,
            humidity: 65,
            ultravioletIndex: 3.0
        )
    }
    
    static func createMockWeatherCondition() -> WeatherCondition {
        WeatherCondition(
            text: "Partly cloudy",
            iconPath: "//cdn.weatherapi.com/weather/64x64/day/116.png",
            code: 1003
        )
    }
}
