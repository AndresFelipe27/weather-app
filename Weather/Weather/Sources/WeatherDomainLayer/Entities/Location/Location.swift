//
//  Location.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Foundation

struct Location: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let region: String
    let country: String
    let latitude: Double
    let longitude: Double
    let url: String
}
