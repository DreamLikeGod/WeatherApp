//
//  Forecast.swift
//  WeatherApp
//
//  Created by Егор on 26.02.2024.
//

import Foundation

struct Forecast: Decodable {
    let cod: String
    let message: Int
    let list: [ListElem]?
    let city: City?
}
struct City: Decodable {
    let name: String
    let coord: Coordinates
}
struct ListElem: Decodable {
    let main: Main?
    let weather: [VisualWeather]?
    let visibility: Int?
}
