//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Егор on 26.02.2024.
//

import Foundation

struct CurrentWeather: Decodable {
    let cod: Int
    let message: String?
    let name: String?
    let visibility: Int?
    let coord: Coordinates?
    let weather: [VisualWeather]?
    let main: Main?
}
