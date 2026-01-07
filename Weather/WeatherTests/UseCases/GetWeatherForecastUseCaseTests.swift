//
//  GetWeatherForecastUseCaseTests.swift
//  WeatherTests
//
//  Created by Tests
//

import Testing
import Foundation
@testable import Weather

@Suite("GetWeatherForecastUseCase Tests")
@MainActor struct GetWeatherForecastUseCaseTests {
    
    // MARK: - Successful Execution Tests
    
    @Test("Execute with valid query returns forecast")
    func testExecuteWithValidQuery() async throws {
        let mockForecast = WeatherTestFactory.createMockWeatherForecast()
        let repository = MockWeatherForecastRepository(mockResult: .success(mockForecast))
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        let result = try await useCase.execute(query: "London England UK", days: 3)
        
        #expect(result.location.name == "London")
        #expect(result.forecastDays.count == 3)
        #expect(repository.getForecastCallCount == 1)
    }
    
    @Test("Execute with valid query and different days")
    func testExecuteWithDifferentDays() async throws {
        let mockForecast = WeatherTestFactory.createMockWeatherForecast()
        let repository = MockWeatherForecastRepository(mockResult: .success(mockForecast))
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "Paris", days: 5)
        
        #expect(repository.lastDays == 5)
    }
    
    // MARK: - Query Validation Tests
    
    @Test("Execute with empty query throws error")
    func testExecuteWithEmptyQuery() async throws {
        let repository = MockWeatherForecastRepository()
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        await #expect(throws: ForecastError.self) {
            try await useCase.execute(query: "", days: 3)
        }
        
        #expect(repository.getForecastCallCount == 0)
    }
    
    @Test("Execute with whitespace only query throws error")
    func testExecuteWithWhitespaceOnly() async throws {
        let repository = MockWeatherForecastRepository()
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        await #expect(throws: ForecastError.self) {
            try await useCase.execute(query: "   ", days: 3)
        }
        
        #expect(repository.getForecastCallCount == 0)
    }
    
    // MARK: - Query Trimming Tests
    
    @Test("Execute trims leading and trailing whitespace")
    func testExecuteTrimsWhitespace() async throws {
        let mockForecast = WeatherTestFactory.createMockWeatherForecast()
        let repository = MockWeatherForecastRepository(mockResult: .success(mockForecast))
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "  London  ", days: 3)
        
        #expect(repository.lastQuery == "  London  ")
    }
    
    @Test("Execute preserves internal spaces in query")
    func testExecutePreservesInternalSpaces() async throws {
        let mockForecast = WeatherTestFactory.createMockWeatherForecast()
        let repository = MockWeatherForecastRepository(mockResult: .success(mockForecast))
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        let query = "New York City"
        _ = try await useCase.execute(query: query, days: 3)
        
        #expect(repository.lastQuery == query)
    }
    
    // MARK: - Error Handling Tests
    
    @Test("Execute throws error when repository fails")
    func testExecuteThrowsRepositoryError() async throws {
        let apiError = APIErrorResponse(error: ErrorDetails(code: 400, message: "Invalid location"))
        let repository = MockWeatherForecastRepository(mockResult: .failure(apiError))
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        await #expect(throws: APIErrorResponse.self) {
            try await useCase.execute(query: "InvalidLocation", days: 3)
        }
    }
    
    @Test("Execute throws network error")
    func testExecuteThrowsNetworkError() async throws {
        let networkError = URLError(.notConnectedToInternet)
        let repository = MockWeatherForecastRepository(mockResult: .failure(networkError))
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        await #expect(throws: URLError.self) {
            try await useCase.execute(query: "London", days: 3)
        }
    }
    
    // MARK: - Multiple Calls Tests
    
    @Test("Execute handles multiple consecutive calls")
    func testExecuteMultipleCalls() async throws {
        let mockForecast = WeatherTestFactory.createMockWeatherForecast()
        let repository = MockWeatherForecastRepository(mockResult: .success(mockForecast))
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "London", days: 3)
        _ = try await useCase.execute(query: "Paris", days: 3)
        _ = try await useCase.execute(query: "Tokyo", days: 3)
        
        #expect(repository.getForecastCallCount == 3)
    }
    
    // MARK: - Days Parameter Tests
    
    @Test("Execute passes days parameter correctly")
    func testExecutePassesDaysParameter() async throws {
        let mockForecast = WeatherTestFactory.createMockWeatherForecast()
        let repository = MockWeatherForecastRepository(mockResult: .success(mockForecast))
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "London", days: 7)
        
        #expect(repository.lastDays == 7)
    }
    
    @Test("Execute with minimum days value")
    func testExecuteWithMinimumDays() async throws {
        let mockForecast = WeatherTestFactory.createMockWeatherForecast()
        let repository = MockWeatherForecastRepository(mockResult: .success(mockForecast))
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "London", days: 1)
        
        #expect(repository.lastDays == 1)
    }
    
    @Test("Execute with maximum days value")
    func testExecuteWithMaximumDays() async throws {
        let mockForecast = WeatherTestFactory.createMockWeatherForecast()
        let repository = MockWeatherForecastRepository(mockResult: .success(mockForecast))
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "London", days: 14)
        
        #expect(repository.lastDays == 14)
    }
    
    // MARK: - Special Characters Tests
    
    @Test("Execute handles queries with special characters")
    func testExecuteWithSpecialCharacters() async throws {
        let mockForecast = WeatherTestFactory.createMockWeatherForecast()
        let repository = MockWeatherForecastRepository(mockResult: .success(mockForecast))
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "São Paulo", days: 3)
        
        #expect(repository.lastQuery == "São Paulo")
    }
    
    @Test("Execute handles queries with coordinates")
    func testExecuteWithCoordinates() async throws {
        let mockForecast = WeatherTestFactory.createMockWeatherForecast()
        let repository = MockWeatherForecastRepository(mockResult: .success(mockForecast))
        let useCase = GetWeatherForecastUseCase(repository: repository)
        
        _ = try await useCase.execute(query: "48.8567,2.3508", days: 3)
        
        #expect(repository.lastQuery == "48.8567,2.3508")
    }
}

// MARK: - Mock Repository

final class MockWeatherForecastRepository: WeatherForecastRepository {
    var mockResult: Result<WeatherForecast, Error>
    var getForecastCallCount = 0
    var lastQuery: String?
    var lastDays: Int?
    
    init(mockResult: Result<WeatherForecast, Error> = .success(WeatherTestFactory.createMockWeatherForecast())) {
        self.mockResult = mockResult
    }
    
    func getForecast(query: String, days: Int) async throws -> WeatherForecast {
        getForecastCallCount += 1
        lastQuery = query
        lastDays = days
        
        switch mockResult {
        case .success(let forecast):
            return forecast
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - API Error Response

struct APIErrorResponse: Error, Codable {
    let error: ErrorDetails
    
    var message: String {
        error.message
    }
}

struct ErrorDetails: Codable {
    let code: Int
    let message: String
}
