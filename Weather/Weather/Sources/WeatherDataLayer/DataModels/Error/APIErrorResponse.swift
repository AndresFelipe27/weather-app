//
//  APIErrorResponse.swift
//  Weather
//
//  Created by Usuario on 3/01/26.
//

import Foundation

public struct APIErrorResponse: Codable, Error {
    public let code: String
    public let message: String

    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}
