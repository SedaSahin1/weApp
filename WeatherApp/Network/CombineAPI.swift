//
//  CombineAPI.swift
//  WeatherApp
//
//  Created by Seda Şahin on 17.02.2024.
//

import Foundation
import Combine

protocol CombineAPI {
    var session: URLSession { get }
    func execute<T>(_ request: URLRequest,
                    decodingType: T.Type,
                    qualityOfService: DispatchQoS.QoSClass,
                    queue: DispatchQueue,
                    decoder: JSONDecoder,
                    retries: Int) -> AnyPublisher<T?, Error> where T: Decodable
}

extension CombineAPI {

    func execute<T>(_ request: URLRequest,
                    decodingType: T.Type,
                    qualityOfService: DispatchQoS.QoSClass = .default,
                    queue: DispatchQueue = .main,
                    decoder: JSONDecoder = .init(),
                    retries: Int = 2) -> AnyPublisher<T?, Error> where T: Decodable {
        // Check cacheable
              if let cachedResponse = URLCache.shared.cachedResponse(for: request),
                 let cachedObject = try? decoder.decode(T?.self, from: cachedResponse.data) {
                  return Just(cachedObject)
                      .setFailureType(to: Error.self)
                      .eraseToAnyPublisher()
              }
        return session.dataTaskPublisher(for: request)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    throw APIError.responseUnsuccessful

                }
                print(String(data: $0.data, encoding: .utf8))
                return $0.data
            }
            .handleEvents(receiveOutput: { data in
                            if
                               let url = request.url,
                               let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil) {
                                let cachedResponse = CachedURLResponse(response: httpResponse, data: data)
                                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                                UserDefaults.standard.set(data, forKey: String(describing: url.deletingQuery()))
                            }
                        })
                        .eraseToAnyPublisher()
            .subscribe(on: DispatchQueue.global(qos: qualityOfService))
            .receive(on: queue)
            .decode(type: T?.self, decoder: decoder)
            .retry(retries)
            .eraseToAnyPublisher()
    }
}


struct ResponseError: Error {
    let errorMessage: String
}

extension URL {
    func deletingQuery() -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.query = nil
        return components?.url
    }
}


