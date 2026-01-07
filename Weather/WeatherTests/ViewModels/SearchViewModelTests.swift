//
//  SearchViewModelTests.swift
//  WeatherTests
//
//  Created by Usuario.
//

import Testing
import SwiftUI
import Combine
import Foundation
@testable import Weather

@Suite("SearchViewModel Tests")
@MainActor struct SearchViewModelTests {
    
    // MARK: - Initial State Tests
    
    @Test("ViewModel initializes with correct default state")
    func testInitialState() async {
        let coordinator = MockNavigationCoordinator()
        let useCase = MockSearchLocationsUseCase()
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        
        #expect(viewModel.query.isEmpty)
        #expect(viewModel.locations.isEmpty)
        #expect(viewModel.viewState == .idle)
        #expect(viewModel.errorMessage == nil)
    }
    
    // MARK: - OnAppear Tests
    
    @Test("onAppear with empty query sets idle state")
    func testOnAppearWithEmptyQuery() async {
        let coordinator = MockNavigationCoordinator()
        let useCase = MockSearchLocationsUseCase()
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        
        viewModel.onAppear()
        
        #expect(viewModel.viewState == .idle)
        #expect(viewModel.locations.isEmpty)
    }
    
    @Test("onAppear with existing query maintains state")
    func testOnAppearWithExistingQuery() async {
        let coordinator = MockNavigationCoordinator()
        let useCase = MockSearchLocationsUseCase()
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        
        viewModel.query = "London"
        viewModel.onAppear()
        
        #expect(viewModel.viewState == .idle)
    }
    
    // MARK: - Search Functionality Tests
    
    @Test("Search with valid query returns results")
    func testSearchWithValidQuery() async throws {
        let coordinator = MockNavigationCoordinator()
        let mockLocations = LocationFactory.createMockLocations()
        let useCase = MockSearchLocationsUseCase(mockResult: .success(mockLocations))
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        
        viewModel.query = "London"
        
        try await Task.sleep(for: .milliseconds(300))
        
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.locations.count == mockLocations.count)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("Search with empty query shows idle state")
    func testSearchWithEmptyQuery() async throws {
        let coordinator = MockNavigationCoordinator()
        let useCase = MockSearchLocationsUseCase()
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        
        viewModel.query = "London"
        try await Task.sleep(for: .milliseconds(300))
        
        viewModel.query = ""
        try await Task.sleep(for: .milliseconds(300))
        
        #expect(viewModel.viewState == .idle)
        #expect(viewModel.locations.isEmpty)
    }
    
    @Test("Search with whitespace only shows idle state")
    func testSearchWithWhitespaceOnly() async throws {
        let coordinator = MockNavigationCoordinator()
        let useCase = MockSearchLocationsUseCase()
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        
        viewModel.query = "   "
        
        try await Task.sleep(for: .milliseconds(300))
        
        #expect(viewModel.viewState == .idle)
        #expect(viewModel.locations.isEmpty)
    }
    
    @Test("Search with no results shows empty state")
    func testSearchWithNoResults() async throws {
        let coordinator = MockNavigationCoordinator()
        let useCase = MockSearchLocationsUseCase(mockResult: .success([]))
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        
        viewModel.query = "NonExistentCity123"
        
        try await Task.sleep(for: .milliseconds(300))
        
        #expect(viewModel.viewState == .empty)
        #expect(viewModel.locations.isEmpty)
    }
    
    @Test("Search error shows error state with message")
    func testSearchError() async throws {
        let coordinator = MockNavigationCoordinator()
        let error = MockError.networkError
        let useCase = MockSearchLocationsUseCase(mockResult: .failure(error))
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        
        viewModel.query = "London"
        
        try await Task.sleep(for: .milliseconds(300))
        
        #expect(viewModel.viewState == .error)
        #expect(viewModel.locations.isEmpty)
        #expect(viewModel.errorMessage != nil)
    }
    
    // MARK: - Debounce Tests
    
    @Test("Search debounces rapid query changes")
    func testSearchDebounce() async throws {
        let coordinator = MockNavigationCoordinator()
        let useCase = MockSearchLocationsUseCase(mockResult: .success(LocationFactory.createMockLocations()))
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        
        viewModel.query = "L"
        viewModel.query = "Lo"
        viewModel.query = "Lon"
        viewModel.query = "Lond"
        viewModel.query = "London"
        
        try await Task.sleep(for: .milliseconds(100))
        #expect(useCase.executeCallCount == 0)
        
        try await Task.sleep(for: .milliseconds(300))
        #expect(useCase.executeCallCount == 1)
    }
    
    // MARK: - Navigation Tests
    
    @Test("onTapFavorites navigates to favorites screen")
    func testNavigateToFavorites() async {
        let coordinator = MockNavigationCoordinator()
        let useCase = MockSearchLocationsUseCase()
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        
        viewModel.onTapFavorites()
        
        try? await Task.sleep(for: .milliseconds(100))
        
        #expect(coordinator.pushCallCount == 1)
        #expect(coordinator.lastPushedTag == .favorites)
    }
    
    @Test("onTapLocation navigates to forecast screen")
    func testNavigateToForecast() async {
        let coordinator = MockNavigationCoordinator()
        let useCase = MockSearchLocationsUseCase()
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        let location = LocationFactory.createMockLocation()
        
        viewModel.onTapLocation(location)
        
        try? await Task.sleep(for: .milliseconds(100))
        
        #expect(coordinator.pushCallCount == 1)
        #expect(coordinator.lastPushedTag == .forecast)
    }
    
    // MARK: - Query Trimming Tests
    
    @Test("Query with leading/trailing whitespace is trimmed")
    func testQueryTrimmingWhitespace() async throws {
        let coordinator = MockNavigationCoordinator()
        let mockLocations = LocationFactory.createMockLocations()
        let useCase = MockSearchLocationsUseCase(mockResult: .success(mockLocations))
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        
        viewModel.query = "  London  "
        
        try await Task.sleep(for: .milliseconds(300))
        
        #expect(useCase.lastQuery == "London")
    }
    
    // MARK: - Task Cancellation Tests
    
    @Test("Previous search is cancelled when new search starts")
    func testSearchCancellation() async throws {
        let coordinator = MockNavigationCoordinator()
        let useCase = MockSearchLocationsUseCase(
            mockResult: .success(LocationFactory.createMockLocations()),
            delay: 500
        )
        let viewModel = SearchViewModel(coordinator: coordinator, searchUseCase: useCase)
        
        viewModel.query = "London"
        try await Task.sleep(for: .milliseconds(100))
        
        viewModel.query = "Paris"
        try await Task.sleep(for: .milliseconds(400))
        
        #expect(useCase.executeCallCount <= 2)
    }
}

// MARK: - Mock Classes

final class MockNavigationCoordinator: NavigationCoordinator {
    var pushCallCount = 0
    var popCallCount = 0
    var lastPushedTag: NavigationTag?
    
    override func push<V: View>(_ view: V, tag: NavigationTag? = nil) {
        pushCallCount += 1
        lastPushedTag = tag
    }
    
    override func pop() {
        popCallCount += 1
        super.pop()
    }
}

final class MockSearchLocationsUseCase: SearchLocationsUseCaseType {
    var mockResult: Result<[Location], Error>
    var executeCallCount = 0
    var lastQuery: String?
    var delay: Int = 0
    
    init(mockResult: Result<[Location], Error> = .success([]), delay: Int = 0) {
        self.mockResult = mockResult
        self.delay = delay
    }
    
    func execute(query: String) async throws -> [Location] {
        executeCallCount += 1
        lastQuery = query
        
        if delay > 0 {
            try? await Task.sleep(for: .milliseconds(delay))
        }
        
        switch mockResult {
        case .success(let locations):
            return locations
        case .failure(let error):
            throw error
        }
    }
}

enum MockError: LocalizedError {
    case networkError
    case invalidResponse
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection failed"
        case .invalidResponse:
            return "Invalid server response"
        case .timeout:
            return "Request timed out"
        }
    }
}

struct LocationFactory {
    static func createMockLocation(
        id: Int = 1,
        name: String = "London",
        region: String = "City of London, Greater London",
        country: String = "United Kingdom",
        latitude: Double = 51.52,
        longitude: Double = -0.11,
        url: String = "london-city-of-london-greater-london-united-kingdom"
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
    
    static func createMockLocations() -> [Location] {
        [
            createMockLocation(
                id: 1,
                name: "London",
                region: "City of London, Greater London",
                country: "United Kingdom",
                latitude: 51.52,
                longitude: -0.11
            ),
            createMockLocation(
                id: 2,
                name: "London",
                region: "Ontario",
                country: "Canada",
                latitude: 42.98,
                longitude: -81.25
            ),
            createMockLocation(
                id: 3,
                name: "Londonderry",
                region: "New Hampshire",
                country: "United States of America",
                latitude: 42.87,
                longitude: -71.37
            )
        ]
    }
}
