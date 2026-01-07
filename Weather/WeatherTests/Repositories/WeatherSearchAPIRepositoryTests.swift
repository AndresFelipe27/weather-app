//
//  WeatherSearchAPIRepositoryTests.swift
//  WeatherTests
//
//  Created by Usuario.
//

import Testing
import Foundation
@testable import Weather

@Suite("WeatherSearchAPIRepository Tests")
@MainActor struct WeatherSearchAPIRepositoryTests {
    
    // MARK: - Successful Response Tests
    
    @Test("searchLocations returns mapped locations on success")
    func testSearchLocationsSuccess() async throws {
        let mockAPIResponse = [
            LocationSearchAPIResponse(
                id: 1,
                name: "London",
                region: "City of London, Greater London",
                country: "United Kingdom",
                lat: 51.52,
                lon: -0.11,
                url: "london-city-of-london-greater-london-united-kingdom"
            ),
            LocationSearchAPIResponse(
                id: 2,
                name: "London",
                region: "Ontario",
                country: "Canada",
                lat: 42.98,
                lon: -81.25,
                url: "london-ontario-canada"
            )
        ]
        
        let mockNetworkService = MockNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        let locations = try await repository.searchLocations(query: "London")
        
        #expect(locations.count == 2)
        #expect(locations[0].name == "London")
        #expect(locations[0].country == "United Kingdom")
        #expect(locations[0].latitude == 51.52)
        #expect(locations[0].longitude == -0.11)
        #expect(locations[1].country == "Canada")
        #expect(mockNetworkService.requestCallCount == 1)
    }
    
    @Test("searchLocations returns empty array when no results")
    func testSearchLocationsEmptyResponse() async throws {
        let mockAPIResponse: [LocationSearchAPIResponse] = []
        let mockNetworkService = MockNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        let locations = try await repository.searchLocations(query: "NonExistentCity")
        
        #expect(locations.isEmpty)
        #expect(mockNetworkService.requestCallCount == 1)
    }
    
    @Test("searchLocations maps single location correctly")
    func testSearchLocationsSingleResult() async throws {
        let mockAPIResponse = [
            LocationSearchAPIResponse(
                id: 12345,
                name: "Paris",
                region: "Ile-de-France",
                country: "France",
                lat: 48.8567,
                lon: 2.3508,
                url: "paris-ile-de-france-france"
            )
        ]
        
        let mockNetworkService = MockNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        let locations = try await repository.searchLocations(query: "Paris")
        
        #expect(locations.count == 1)
        let location = try #require(locations.first)
        #expect(location.id == 12345)
        #expect(location.name == "Paris")
        #expect(location.region == "Ile-de-France")
        #expect(location.country == "France")
        #expect(location.latitude == 48.8567)
        #expect(location.longitude == 2.3508)
        #expect(location.url == "paris-ile-de-france-france")
    }
    
    // MARK: - Error Handling Tests
    
    @Test("searchLocations throws URLError on network failure")
    func testSearchLocationsNetworkError() async throws {
        let networkError = URLError(.notConnectedToInternet)
        let mockNetworkService = MockNetworkService(shouldThrowError: true, error: networkError)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        await #expect(throws: URLError.self) {
            try await repository.searchLocations(query: "London")
        }
        #expect(mockNetworkService.requestCallCount == 1)
    }
    
    @Test("searchLocations throws error on bad server response")
    func testSearchLocationsBadServerResponse() async throws {
        let serverError = URLError(.badServerResponse)
        let mockNetworkService = MockNetworkService(shouldThrowError: true, error: serverError)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        await #expect(throws: URLError.self) {
            try await repository.searchLocations(query: "London")
        }
    }
    
    @Test("searchLocations throws error on timeout")
    func testSearchLocationsTimeout() async throws {
        let timeoutError = URLError(.timedOut)
        let mockNetworkService = MockNetworkService(shouldThrowError: true, error: timeoutError)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        await #expect(throws: URLError.self) {
            try await repository.searchLocations(query: "London")
        }
    }
    
    @Test("searchLocations throws error on decoding failure")
    func testSearchLocationsDecodingError() async throws {
        let invalidData = "invalid json".data(using: .utf8)!
        let mockNetworkService = MockNetworkService(mockResponse: invalidData)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        await #expect(throws: (any Error).self) {
            try await repository.searchLocations(query: "London")
        }
    }
    
    // MARK: - Query Parameter Tests
    
    @Test("searchLocations sends correct query parameter")
    func testSearchLocationsSendsCorrectQuery() async throws {
        let mockAPIResponse: [LocationSearchAPIResponse] = []
        let mockNetworkService = MockNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        _ = try await repository.searchLocations(query: "Tokyo")
        
        let capturedEndpoint = try #require(mockNetworkService.lastEndpoint as? WeatherSearchEndPoint)
        
        if case .search(let query) = capturedEndpoint {
            #expect(query == "Tokyo")
        } else {
            Issue.record("Expected search endpoint with query")
        }
    }
    
    @Test("searchLocations uses correct endpoint type")
    func testSearchLocationsUsesCorrectEndpoint() async throws {
        let mockAPIResponse: [LocationSearchAPIResponse] = []
        let mockNetworkService = MockNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        _ = try await repository.searchLocations(query: "New York")
        
        #expect(mockNetworkService.lastEndpoint is WeatherSearchEndPoint)
    }
    
    @Test("searchLocations passes nil interceptor")
    func testSearchLocationsPassesNilInterceptor() async throws {
        let mockAPIResponse: [LocationSearchAPIResponse] = []
        let mockNetworkService = MockNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        _ = try await repository.searchLocations(query: "Madrid")
        
        #expect(mockNetworkService.lastInterceptor == nil)
    }
    
    // MARK: - Data Mapping Tests
    
    @Test("searchLocations correctly maps latitude and longitude")
    func testSearchLocationsCoordinateMapping() async throws {
        let mockAPIResponse = [
            LocationSearchAPIResponse(
                id: 1,
                name: "Sydney",
                region: "New South Wales",
                country: "Australia",
                lat: -33.8688,
                lon: 151.2093,
                url: "sydney-australia"
            )
        ]
        
        let mockNetworkService = MockNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        let locations = try await repository.searchLocations(query: "Sydney")
        let location = try #require(locations.first)
        
        #expect(location.latitude == -33.8688)
        #expect(location.longitude == 151.2093)
    }
    
    @Test("searchLocations preserves all location fields")
    func testSearchLocationsPreservesAllFields() async throws {
        let mockAPIResponse = [
            LocationSearchAPIResponse(
                id: 999,
                name: "Test City",
                region: "Test Region",
                country: "Test Country",
                lat: 12.34,
                lon: 56.78,
                url: "test-city-url"
            )
        ]
        
        let mockNetworkService = MockNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        let locations = try await repository.searchLocations(query: "Test")
        let location = try #require(locations.first)
        
        #expect(location.id == 999)
        #expect(location.name == "Test City")
        #expect(location.region == "Test Region")
        #expect(location.country == "Test Country")
        #expect(location.latitude == 12.34)
        #expect(location.longitude == 56.78)
        #expect(location.url == "test-city-url")
    }
    
    // MARK: - Special Cases Tests
    
    @Test("searchLocations handles locations with special characters")
    func testSearchLocationsWithSpecialCharacters() async throws {
        let mockAPIResponse = [
            LocationSearchAPIResponse(
                id: 1,
                name: "São Paulo",
                region: "São Paulo",
                country: "Brazil",
                lat: -23.5505,
                lon: -46.6333,
                url: "sao-paulo-brazil"
            )
        ]
        
        let mockNetworkService = MockNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        let locations = try await repository.searchLocations(query: "São Paulo")
        
        #expect(locations.count == 1)
        #expect(locations[0].name == "São Paulo")
        #expect(locations[0].region == "São Paulo")
    }
    
    @Test("searchLocations handles locations at extreme coordinates")
    func testSearchLocationsExtremeCoordinates() async throws {
        let mockAPIResponse = [
            LocationSearchAPIResponse(
                id: 1,
                name: "North Pole",
                region: "Arctic",
                country: "International",
                lat: 90.0,
                lon: 0.0,
                url: "north-pole"
            ),
            LocationSearchAPIResponse(
                id: 2,
                name: "South Pole",
                region: "Antarctica",
                country: "International",
                lat: -90.0,
                lon: 0.0,
                url: "south-pole"
            )
        ]
        
        let mockNetworkService = MockNetworkService(mockResponse: mockAPIResponse)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        let locations = try await repository.searchLocations(query: "Pole")
        
        #expect(locations.count == 2)
        #expect(locations[0].latitude == 90.0)
        #expect(locations[1].latitude == -90.0)
    }
    
    // MARK: - Multiple Calls Tests
    
    @Test("searchLocations handles multiple consecutive calls")
    func testSearchLocationsMultipleCalls() async throws {
        let mockAPIResponse1 = [
            LocationSearchAPIResponse(
                id: 1,
                name: "London",
                region: "England",
                country: "UK",
                lat: 51.52,
                lon: -0.11,
                url: "london"
            )
        ]
        
        let mockAPIResponse2 = [
            LocationSearchAPIResponse(
                id: 2,
                name: "Paris",
                region: "France",
                country: "France",
                lat: 48.85,
                lon: 2.35,
                url: "paris"
            )
        ]
        
        let mockNetworkService = MockNetworkService(mockResponse: mockAPIResponse1)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        let locations1 = try await repository.searchLocations(query: "London")
        #expect(locations1.count == 1)
        #expect(locations1[0].name == "London")
        
        mockNetworkService.mockResponse = mockAPIResponse2
        
        let locations2 = try await repository.searchLocations(query: "Paris")
        #expect(locations2.count == 1)
        #expect(locations2[0].name == "Paris")
        
        #expect(mockNetworkService.requestCallCount == 2)
    }
    
    // MARK: - Large Dataset Tests
    
    @Test("searchLocations handles large response arrays")
    func testSearchLocationsLargeDataset() async throws {
        let largeResponse = (1...100).map { index in
            LocationSearchAPIResponse(
                id: index,
                name: "City \(index)",
                region: "Region \(index)",
                country: "Country \(index)",
                lat: Double(index),
                lon: Double(index),
                url: "city-\(index)"
            )
        }
        
        let mockNetworkService = MockNetworkService(mockResponse: largeResponse)
        let repository = WeatherSearchAPIRepository(networkService: mockNetworkService)
        
        let locations = try await repository.searchLocations(query: "City")
        
        #expect(locations.count == 100)
        #expect(locations.first?.id == 1)
        #expect(locations.last?.id == 100)
    }
}

// MARK: - Mock Network Service

final class MockNetworkService: NetworkServiceProtocol {
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
        
        if let responseArray = mockResponse as? [LocationSearchAPIResponse] {
            let encoder = JSONEncoder()
            let data = try encoder.encode(responseArray)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
        
        throw URLError(.cannotDecodeContentData)
    }
}
