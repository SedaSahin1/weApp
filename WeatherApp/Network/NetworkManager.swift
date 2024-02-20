//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Seda Şahin on 18.02.2024.
//

import Foundation
import Combine

final class NetworkManager: CombineAPI {
    let session: URLSession
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration, delegate: UrlSessionDelegate(), delegateQueue: OperationQueue.main)
    }
    convenience init() {
        self.init(configuration: .default)
    }
    func currentWeather(_ requestEndpoint: NetworkManagerEndpoint) -> AnyPublisher<WeatherEntity?, Error> {
        return execute(requestEndpoint.request, decodingType: WeatherEntity.self, retries: 1)
    }
    func weatherList(_ requestEndpoint: NetworkManagerEndpoint) -> AnyPublisher<WeatherList?, Error> {
        return execute(requestEndpoint.request, decodingType: WeatherList.self, retries: 1)
    }
}

enum NetworkManagerEndpoint {
    case currentWeather(String, String)
    case weatherList(String, String)
}

extension NetworkManagerEndpoint: Endpoint {
    var quertyItems: [URLQueryItem] {
        switch self {
        case .currentWeather(let lat, let lon):
            return [
                .init(name: "lat", value: lat),
                .init(name: "lon", value: lon),
                .init(name: "appid", value: "b36d9a8ae00e35795522d24c2a45c371"),
                .init(name: "units", value: UserDefaults.standard.string(forKey: "unit"))
            ]
        case .weatherList(let lat, let lon):
            return [
                .init(name: "lat", value: lat),
                .init(name: "lon", value: lon),
                .init(name: "appid", value: "b36d9a8ae00e35795522d24c2a45c371"),
                .init(name: "units", value: UserDefaults.standard.string(forKey: "unit"))
            ]
        }
       
    }
    var httpMethod: String {
        "GET"
    }
    var baseUrl: String { "https://api.openweathermap.org" }
    var path: String {
        switch self {
        case .currentWeather:
                return "/data/2.5/weather"
        case .weatherList:
                return "/data/2.5/forecast"
        }
    }
}

