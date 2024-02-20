//
//  WeatherEntity.swift
//  WeatherApp
//
//  Created by Seda Şahin on 17.02.2024.
//

import Foundation

struct WeatherList: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: City?
}

struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

struct List: Codable {
    let dt: Int?
    let main: MainValue?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let rain: RainValue?
    let sys: SysValue?
    let dtTxt: String?
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

struct MainValue: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct RainValue: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct SysValue: Codable {
    let pod: String?
}

struct Coord: Codable {
    let lat, lon: Double?
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int?
}

struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

struct WeatherEntity: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let rain: Rain?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Rain: Codable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

struct Sys: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

