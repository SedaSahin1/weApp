//
//  BaseResponse.swift
//  WeatherApp
//
//  Created by Seda Şahin on 18.02.2024.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let data: T?
}
