//
//  LocationTests.swift
//  WeatherTests
//
//  Created by Usuario.
//

import Testing
import Foundation
@testable import Weather

@Suite("Location Model Tests")
@MainActor struct LocationTests {
    
    // MARK: - Initialization Tests
    
    @Test("Location initializes with all properties")
    func testLocationInitialization() {
        let location = Location(
            id: 1,
            name: "London",
            region: "City of London",
            country: "United Kingdom",
            latitude: 51.52,
            longitude: -0.11,
            url: "london-uk"
        )
        
        #expect(location.id == 1)
        #expect(location.name == "London")
        #expect(location.region == "City of London")
        #expect(location.country == "United Kingdom")
        #expect(location.latitude == 51.52)
        #expect(location.longitude == -0.11)
        #expect(location.url == "london-uk")
    }
    
    // MARK: - Equatable Tests
    
    @Test("Two identical locations are equal")
    func testLocationEquality() {
        let location1 = Location(
            id: 1,
            name: "London",
            region: "City of London",
            country: "United Kingdom",
            latitude: 51.52,
            longitude: -0.11,
            url: "london-uk"
        )
        
        let location2 = Location(
            id: 1,
            name: "London",
            region: "City of London",
            country: "United Kingdom",
            latitude: 51.52,
            longitude: -0.11,
            url: "london-uk"
        )
        
        #expect(location1 == location2)
    }
    
    @Test("Two locations with different IDs are not equal")
    func testLocationInequalityDifferentId() {
        let location1 = Location(
            id: 1,
            name: "London",
            region: "City of London",
            country: "United Kingdom",
            latitude: 51.52,
            longitude: -0.11,
            url: "london-uk"
        )
        
        let location2 = Location(
            id: 2,
            name: "London",
            region: "City of London",
            country: "United Kingdom",
            latitude: 51.52,
            longitude: -0.11,
            url: "london-uk"
        )
        
        #expect(location1 != location2)
    }
    
    @Test("Two locations with different names are not equal")
    func testLocationInequalityDifferentName() {
        let location1 = Location(
            id: 1,
            name: "London",
            region: "City of London",
            country: "United Kingdom",
            latitude: 51.52,
            longitude: -0.11,
            url: "london-uk"
        )
        
        let location2 = Location(
            id: 1,
            name: "Paris",
            region: "City of London",
            country: "United Kingdom",
            latitude: 51.52,
            longitude: -0.11,
            url: "london-uk"
        )
        
        #expect(location1 != location2)
    }
    
    // MARK: - Codable Tests
    
    @Test("Location encodes to JSON correctly")
    func testLocationEncoding() throws {
        let location = Location(
            id: 1,
            name: "London",
            region: "City of London",
            country: "United Kingdom",
            latitude: 51.52,
            longitude: -0.11,
            url: "london-uk"
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(location)
        
        #expect(!data.isEmpty)
    }
    
    @Test("Location decodes from JSON correctly")
    func testLocationDecoding() throws {
        let json = """
        {
            "id": 1,
            "name": "London",
            "region": "City of London",
            "country": "United Kingdom",
            "latitude": 51.52,
            "longitude": -0.11,
            "url": "london-uk"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let location = try decoder.decode(Location.self, from: data)
        
        #expect(location.id == 1)
        #expect(location.name == "London")
        #expect(location.region == "City of London")
        #expect(location.country == "United Kingdom")
        #expect(location.latitude == 51.52)
        #expect(location.longitude == -0.11)
        #expect(location.url == "london-uk")
    }
    
    @Test("Location encoding and decoding are symmetric")
    func testLocationEncodingDecodingSymmetry() throws {
        let originalLocation = Location(
            id: 1,
            name: "London",
            region: "City of London",
            country: "United Kingdom",
            latitude: 51.52,
            longitude: -0.11,
            url: "london-uk"
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalLocation)
        
        let decoder = JSONDecoder()
        let decodedLocation = try decoder.decode(Location.self, from: data)
        
        #expect(originalLocation == decodedLocation)
    }
    
    // MARK: - Identifiable Tests
    
    @Test("Location ID is accessible as Identifiable")
    func testLocationIdentifiable() {
        let location = Location(
            id: 12345,
            name: "London",
            region: "City of London",
            country: "United Kingdom",
            latitude: 51.52,
            longitude: -0.11,
            url: "london-uk"
        )
        
        #expect(location.id == 12345)
    }
    
    // MARK: - Coordinate Tests
    
    @Test("Location handles positive coordinates")
    func testLocationPositiveCoordinates() {
        let location = Location(
            id: 1,
            name: "Tokyo",
            region: "Tokyo",
            country: "Japan",
            latitude: 35.6762,
            longitude: 139.6503,
            url: "tokyo-japan"
        )
        
        #expect(location.latitude == 35.6762)
        #expect(location.longitude == 139.6503)
    }
    
    @Test("Location handles negative coordinates")
    func testLocationNegativeCoordinates() {
        let location = Location(
            id: 1,
            name: "Buenos Aires",
            region: "Buenos Aires",
            country: "Argentina",
            latitude: -34.6037,
            longitude: -58.3816,
            url: "buenos-aires-argentina"
        )
        
        #expect(location.latitude == -34.6037)
        #expect(location.longitude == -58.3816)
    }
    
    @Test("Location handles zero coordinates")
    func testLocationZeroCoordinates() {
        let location = Location(
            id: 1,
            name: "Null Island",
            region: "Atlantic Ocean",
            country: "None",
            latitude: 0.0,
            longitude: 0.0,
            url: "null-island"
        )
        
        #expect(location.latitude == 0.0)
        #expect(location.longitude == 0.0)
    }
}
