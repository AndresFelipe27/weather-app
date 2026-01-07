//
//  RequestInterceptor.swift
//  Weather
//
//  Created by Usuario on 3/01/26.
//

import Foundation

public protocol RequestInterceptor {
    func adapt(_ urlRequest: URLRequest) async throws -> URLRequest
    func retry(_ request: URLRequest, for response: URLResponse?, with error: Error) async throws -> Bool
}
