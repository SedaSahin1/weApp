//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Seda Şahin on 18.02.2024.
//

import Foundation

protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var httpMethod: String { get }
    var quertyItems: [URLQueryItem] { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: baseUrl)!
        components.queryItems = quertyItems
        components.path = path
        return components
    }

    var request: URLRequest {
        let url = urlComponents.url!
        var req = URLRequest(url: url)
        req.httpMethod = httpMethod
        return req
    }
}

