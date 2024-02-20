//
//  WeatherPresenter.swift
//  WeatherApp
//
//  Created by Seda Şahin on 17.02.2024.
//

import Foundation

protocol WeatherPresenterProtocol {
    var router: WeatherRouterProtocol? {get set}
    var interactor: WeatherInteractorProtocol? {get set}
    var viewController: WeatherViewProtocol? {get set}
    func loadedWeather(result: Result<WeatherEntity, Error>)
    func loadedWeatherList(result: Result<WeatherList, Error>)
    func callLoadWeather(lat: String, lon: String)
    func callLoadWeatherList(lat: String, lon: String)
    func navigateToNextScreen(view: WeatherViewController, list: List)
}

class WeatherPresenter: WeatherPresenterProtocol {
    var router: WeatherRouterProtocol?
    var interactor: WeatherInteractorProtocol?
    
    func navigateToNextScreen(view: WeatherViewController, list: List) {
            router?.navigateToNextScreen(view: view, list: list)
    }
    
    func callLoadWeather(lat: String, lon: String) {
        interactor?.loadWeather(lat: lat, lon: lon)
    }
    func callLoadWeatherList(lat: String, lon: String) {
        interactor?.loadWeatherList(lat: lat, lon: lon)
    }
    var viewController: WeatherViewProtocol? {
        didSet {
            viewController?.presenter = self
        }
    }
    func loadedWeather(result: Result<WeatherEntity, Error>) {
        switch result {
        case .success(let weather):
            viewController?.updateWeather(with: weather)
        case .failure(_):
            viewController?.updateWeather(with: "Try again later")
        }
    }
    
    func loadedWeatherList(result: Result<WeatherList, Error>) {
        switch result {
        case .success(let weather):
            print("weatherList:")
            print(weather)
            viewController?.updateWeatherList(with: weather)
        case .failure(_):
            viewController?.updateWeatherList(with: "Try again later")
        }
    }
}
