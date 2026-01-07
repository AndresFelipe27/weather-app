//
//  LocationSearchAPIResponseTests.swift
//  WeatherTests
//
//  Created by Usuario.
//

import Testing
import Foundation
@testable import Weather

@Suite("LocationSearchAPIResponse Tests")
@MainActor struct LocationSearchAPIResponseTests {
    
    // MARK: - Decoding Tests
    
    @Test("LocationSearchAPIResponse decodes from valid JSON")
    func testDecodeValidJSON() throws {
        let json = """
        {
            "id": 1,
            "name": "London",
            "region": "City of London, Greater London",
            "country": "United Kingdom",
            "lat": 51.52,
            "lon": -0.11,
            "url": "london-city-of-london-greater-london-united-kingdom"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let response = try decoder.decode(LocationSearchAPIResponse.self, from: data)
        
        #expect(response.id == 1)
        #expect(response.name == "London")
        #expect(response.region == "City of London, Greater London")
        #expect(response.country == "United Kingdom")
        #expect(response.lat == 51.52)
        #expect(response.lon == -0.11)
        #expect(response.url == "london-city-of-london-greater-london-united-kingdom")
    }
    
    @Test("LocationSearchAPIResponse decodes array from valid JSON")
    func testDecodeArrayFromJSON() throws {
        let json = """
        [
            {
                "id": 1,
                "name": "London",
                "region": "City of London",
                "country": "United Kingdom",
                "lat": 51.52,
                "lon": -0.11,
                "url": "london-uk"
            },
            {
                "id": 2,
                "name": "Paris",
                "region": "Ile-de-France",
                "country": "France",
                "lat": 48.8567,
                "lon": 2.3508,
                "url": "paris-france"
            }
        ]
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let responses = try decoder.decode([LocationSearchAPIResponse].self, from: data)
        
        #expect(responses.count == 2)
        #expect(responses[0].name == "London")
        #expect(responses[1].name == "Paris")
    }
    
    @Test("LocationSearchAPIResponse throws error on missing required field")
    func testDecodeMissingField() throws {
        let json = """
        {
            "id": 1,
            "name": "London",
            "region": "City of London",
            "lat": 51.52,
            "lon": -0.11,
            "url": "london-uk"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        #expect(throws: DecodingError.self) {
            try decoder.decode(LocationSearchAPIResponse.self, from: data)
        }
    }
    
    @Test("LocationSearchAPIResponse throws error on wrong type")
    func testDecodeWrongType() throws {
        let json = """
        {
            "id": "not_a_number",
            "name": "London",
            "region": "City of London",
            "country": "United Kingdom",
            "lat": 51.52,
            "lon": -0.11,
            "url": "london-uk"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        #expect(throws: DecodingError.self) {
            try decoder.decode(LocationSearchAPIResponse.self, from: data)
        }
    }
    
    // MARK: - Encoding Tests
    
    @Test("LocationSearchAPIResponse encodes to valid JSON")
    func testEncodeToJSON() throws {
        let response = LocationSearchAPIResponse(
            id: 1,
            name: "London",
            region: "City of London",
            country: "United Kingdom",
            lat: 51.52,
            lon: -0.11,
            url: "london-uk"
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(response)
        
        #expect(!data.isEmpty)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(LocationSearchAPIResponse.self, from: data)
        
        #expect(decoded.id == response.id)
        #expect(decoded.name == response.name)
    }
    
    // MARK: - Mapping to Model Tests
    
    @Test("mapToModel converts API response to Location model")
    func testMapToModel() {
        let apiResponse = LocationSearchAPIResponse(
            id: 1,
            name: "London",
            region: "City of London, Greater London",
            country: "United Kingdom",
            lat: 51.52,
            lon: -0.11,
            url: "london-city-of-london-greater-london-united-kingdom"
        )
        
        let location = apiResponse.mapToModel()
        
        #expect(location.id == 1)
        #expect(location.name == "London")
        #expect(location.region == "City of London, Greater London")
        #expect(location.country == "United Kingdom")
        #expect(location.latitude == 51.52)
        #expect(location.longitude == -0.11)
        #expect(location.url == "london-city-of-london-greater-london-united-kingdom")
    }
    
    @Test("mapToModel correctly maps latitude and longitude")
    func testMapToModelCoordinates() {
        let apiResponse = LocationSearchAPIResponse(
            id: 1,
            name: "Tokyo",
            region: "Tokyo",
            country: "Japan",
            lat: 35.6762,
            lon: 139.6503,
            url: "tokyo-japan"
        )
        
        let location = apiResponse.mapToModel()
        
        #expect(location.latitude == 35.6762)
        #expect(location.longitude == 139.6503)
    }
    
    @Test("mapToModel handles negative coordinates")
    func testMapToModelNegativeCoordinates() {
        let apiResponse = LocationSearchAPIResponse(
            id: 1,
            name: "Buenos Aires",
            region: "Buenos Aires",
            country: "Argentina",
            lat: -34.6037,
            lon: -58.3816,
            url: "buenos-aires"
        )
        
        let location = apiResponse.mapToModel()
        
        #expect(location.latitude == -34.6037)
        #expect(location.longitude == -58.3816)
    }
    
    // MARK: - Array Mapping Tests
    
    @Test("Array mapToModel converts all responses")
    func testArrayMapToModel() {
        let apiResponses = [
            LocationSearchAPIResponse(
                id: 1,
                name: "London",
                region: "City of London",
                country: "United Kingdom",
                lat: 51.52,
                lon: -0.11,
                url: "london-uk"
            ),
            LocationSearchAPIResponse(
                id: 2,
                name: "Paris",
                region: "Ile-de-France",
                country: "France",
                lat: 48.8567,
                lon: 2.3508,
                url: "paris-france"
            )
        ]
        
        let locations = apiResponses.mapToModel()
        
        #expect(locations.count == 2)
        #expect(locations[0].name == "London")
        #expect(locations[1].name == "Paris")
    }
    
    @Test("Array mapToModel handles empty array")
    func testArrayMapToModelEmpty() {
        let apiResponses: [LocationSearchAPIResponse] = []
        let locations = apiResponses.mapToModel()
        
        #expect(locations.isEmpty)
    }
    
    @Test("Array mapToModel preserves order")
    func testArrayMapToModelOrder() {
        let apiResponses = [
            LocationSearchAPIResponse(
                id: 3,
                name: "Tokyo",
                region: "Tokyo",
                country: "Japan",
                lat: 35.6762,
                lon: 139.6503,
                url: "tokyo"
            ),
            LocationSearchAPIResponse(
                id: 1,
                name: "London",
                region: "City of London",
                country: "United Kingdom",
                lat: 51.52,
                lon: -0.11,
                url: "london"
            ),
            LocationSearchAPIResponse(
                id: 2,
                name: "Paris",
                region: "Ile-de-France",
                country: "France",
                lat: 48.8567,
                lon: 2.3508,
                url: "paris"
            )
        ]
        
        let locations = apiResponses.mapToModel()
        
        #expect(locations[0].id == 3)
        #expect(locations[1].id == 1)
        #expect(locations[2].id == 2)
    }
    
    // MARK: - Special Characters Tests
    
    @Test("LocationSearchAPIResponse handles special characters in strings")
    func testSpecialCharacters() throws {
        let json = """
        {
            "id": 1,
            "name": "São Paulo",
            "region": "São Paulo",
            "country": "Brazil",
            "lat": -23.5505,
            "lon": -46.6333,
            "url": "sao-paulo-brazil"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let response = try decoder.decode(LocationSearchAPIResponse.self, from: data)
        
        #expect(response.name == "São Paulo")
        #expect(response.region == "São Paulo")
    }
    
    @Test("LocationSearchAPIResponse handles empty strings")
    func testEmptyStrings() throws {
        let json = """
        {
            "id": 1,
            "name": "",
            "region": "",
            "country": "",
            "lat": 0.0,
            "lon": 0.0,
            "url": ""
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let response = try decoder.decode(LocationSearchAPIResponse.self, from: data)
        
        #expect(response.name.isEmpty)
        #expect(response.region.isEmpty)
        #expect(response.country.isEmpty)
        #expect(response.url.isEmpty)
    }
}
