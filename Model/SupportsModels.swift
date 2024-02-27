//
//  SupportsModels.swift
//  WeatherApp
//
//  Created by Егор on 26.02.2024.
//

import Foundation

struct Coordinates: Decodable {
    let lon: Double
    let lat: Double
}
struct VisualWeather: Decodable {
    let main: String
    let icon: String
}
struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}
