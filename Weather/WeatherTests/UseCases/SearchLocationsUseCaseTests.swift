//
//  SearchLocationsUseCaseTests.swift
//  WeatherTests
//
//  Created by Usuario.
//

import Testing
import Foundation
@testable import Weather

@Suite("SearchLocationsUseCase Tests")
@MainActor struct SearchLocationsUseCaseTests {
    
    // MARK: - Successful Search Tests
    
    @Test("Execute with valid query returns locations")
    func testExecuteWithValidQuery() async throws {
        let mockLocations = LocationFactory.createMockLocations()
        let repository = MockWeatherSearchRepository(mockResult: .success(mockLocations))
        let useCase = SearchLocationsUseCase(repository: repository)
        
        let result = try await useCase.execute(query: "London")
        
        #expect(result.count == 3)
        #expect(result == mockLocations)
        #expect(repository.searchCallCount == 1)
    }
    
    @Test("Execute with empty string returns empty array")
    func testExecuteWithEmptyString() async throws {
        let repository = MockWeatherSearchRepository(mockResult: .success([]))
        let useCase = SearchLocationsUseCase(repository: repository)
        
        let result = try await useCase.execute(query: "")
        
        #expect(result.isEmpty)
        #expect(repository.searchCallCount == 0)
    }
    
    @Test("Execute with whitespace only returns empty array")
    func testExecuteWithWhitespaceOnly() async throws {
        let repository = MockWeatherSearchRepository(mockResult: .success([]))
        let useCase = SearchLocationsUseCase(repository: repository)
        
        let result = try await useCase.execute(query: "   ")
        
        #expect(result.isEmpty)
        #expect(repository.searchCallCount == 0)
    }
    
    // MARK: - Query Trimming Tests
    
    @Test("Execute trims leading and trailing whitespace")
    func testExecuteTrimsWhitespace() async throws {
        let mockLocations = LocationFactory.createMockLocations()
        let repository = MockWeatherSearchRepository(mockResult: .success(mockLocations))
        let useCase = SearchLocationsUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "  London  ")
        
        #expect(repository.lastQuery == "London")
    }
    
    @Test("Execute preserves spaces within query")
    func testExecutePreservesInternalSpaces() async throws {
        let mockLocations = LocationFactory.createMockLocations()
        let repository = MockWeatherSearchRepository(mockResult: .success(mockLocations))
        let useCase = SearchLocationsUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "New York")
        
        #expect(repository.lastQuery == "New York")
    }
    
    // MARK: - Error Handling Tests
    
    @Test("Execute throws error when repository fails")
    func testExecuteThrowsErrorOnRepositoryFailure() async throws {
        let repository = MockWeatherSearchRepository(mockResult: .failure(MockError.networkError))
        let useCase = SearchLocationsUseCase(repository: repository)
        
        await #expect(throws: MockError.self) {
            try await useCase.execute(query: "London")
        }
    }
    
    @Test("Execute with no results returns empty array")
    func testExecuteWithNoResults() async throws {
        let repository = MockWeatherSearchRepository(mockResult: .success([]))
        let useCase = SearchLocationsUseCase(repository: repository)
        
        let result = try await useCase.execute(query: "NonExistentCity123")
        
        #expect(result.isEmpty)
    }
    
    // MARK: - Multiple Query Tests
    
    @Test("Execute handles multiple consecutive queries")
    func testExecuteMultipleQueries() async throws {
        let mockLocations = LocationFactory.createMockLocations()
        let repository = MockWeatherSearchRepository(mockResult: .success(mockLocations))
        let useCase = SearchLocationsUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "London")
        _ = try await useCase.execute(query: "Paris")
        _ = try await useCase.execute(query: "Tokyo")
        
        #expect(repository.searchCallCount == 3)
    }
    
    // MARK: - Special Characters Tests
    
    @Test("Execute handles queries with special characters")
    func testExecuteWithSpecialCharacters() async throws {
        let mockLocations = LocationFactory.createMockLocations()
        let repository = MockWeatherSearchRepository(mockResult: .success(mockLocations))
        let useCase = SearchLocationsUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "São Paulo")
        
        #expect(repository.lastQuery == "São Paulo")
        #expect(repository.searchCallCount == 1)
    }
    
    @Test("Execute handles queries with numbers")
    func testExecuteWithNumbers() async throws {
        let mockLocations = LocationFactory.createMockLocations()
        let repository = MockWeatherSearchRepository(mockResult: .success(mockLocations))
        let useCase = SearchLocationsUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "Route 66")
        
        #expect(repository.lastQuery == "Route 66")
    }
}

// MARK: - Mock Repository

final class MockWeatherSearchRepository: WeatherSearchRepository {
    var mockResult: Result<[Location], Error>
    var searchCallCount = 0
    var lastQuery: String?
    
    init(mockResult: Result<[Location], Error> = .success([])) {
        self.mockResult = mockResult
    }
    
    func searchLocations(query: String) async throws -> [Location] {
        searchCallCount += 1
        lastQuery = query
        
        switch mockResult {
        case .success(let locations):
            return locations
        case .failure(let error):
            throw error
        }
    }
}
