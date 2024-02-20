//
//  WeatherInteractor.swift
//  WeatherApp
//
//  Created by Seda Şahin on 17.02.2024.
//

import Foundation
import Combine

protocol WeatherInteractorProtocol {
    var presenter: WeatherPresenterProtocol? {get set}
    func loadWeather(lat: String, lon: String)
    func loadWeatherList(lat: String, lon: String)
}

class WeatherInteractor: WeatherInteractorProtocol {
    var presenter: WeatherPresenterProtocol?
    private let networkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    func loadWeather(lat: String, lon: String) {
        networkManager.currentWeather(.currentWeather(lat, lon))
            .sink(receiveCompletion: { response in
                switch response {
                case .failure(let error):
                    print(error)
                    self.loadOfflineData()
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.presenter?.loadedWeather(result: .success((response)!))
            })
            .store(in: &cancellables)
    }
    
    func loadWeatherList(lat: String, lon: String) {
        networkManager.weatherList(.weatherList(lat, lon))
            .sink(receiveCompletion: { response in
                switch response {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.presenter?.loadedWeatherList(result: .success((response)!))
            })
            .store(in: &cancellables)
    }
    
    private func loadOfflineData() {
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather"),
           let cachedData = UserDefaults.standard.data(forKey: url.absoluteString) {
            if let weatherEntity = try? JSONDecoder().decode(WeatherEntity.self, from: cachedData) {
                self.presenter?.loadedWeather(result: .success((weatherEntity)))
            }
        }
    }
}
