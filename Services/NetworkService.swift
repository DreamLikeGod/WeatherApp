//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Егор on 26.02.2024.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation

private enum ApiKeys: String {
    case current = "&appid=630a5c73726a91b9df5f3d5f0f1b30b6"
}
private enum Endpoints: String {
    case current = "/weather?"
    case forecast = "/forecast?"
}
private enum Body: String {
    case units = "&units=metric"
}
protocol iNetworkService {
    func getCurrentWeather(in city: String)
    func getForecastWeather(in city: String)
    func getWeatherXYI(lat: Double, lon: Double)
    func getRelayCurrent() -> PublishRelay<CurrentWeather>
    func getRelayForecast() -> PublishRelay<Forecast>
    func getRelayIcon() -> PublishRelay<UIImage>
}
final class NetworkService: iNetworkService {
    
    private var relayCurrentWeather = PublishRelay<CurrentWeather>()
    private var relayForecastWeather = PublishRelay<Forecast>()
    private var relayWeatherIcon = PublishRelay<UIImage>()
    
    private let baseUrl = "https://api.openweathermap.org/data/2.5"
    private let imgUrl = "https://openweathermap.org/img/wn"
    
    private func getCoordinate(from city: String, completion: @escaping (CLLocationCoordinate2D) -> (Void)) {
        CLGeocoder().geocodeAddressString(city) { placemark, error in
            if error == nil,
               let location = placemark?.first?.location {
                completion(location.coordinate)
            }
        }
    }
    private func sendRequest(type: Endpoints, with lat: Double, and lon: Double, completion: @escaping (Data) -> (Void)) {
        guard let url = URL(string: baseUrl + type.rawValue + "lat=\(lat)&lon=\(lon)" + Body.units.rawValue + ApiKeys.current.rawValue) else { return }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if error == nil,
               let data {
                completion(data)
            }
        }.resume()
    }
    private func parseData<T: Decodable>(from data: Data, in type: T.Type, completion: @escaping (T) -> (Void)) {
        if let json = try? JSONDecoder().decode(type, from: data) {
            completion(json)
        } else {
            print("Error")
        }
    }
    private func getIcon(with name: String) {
        guard let url = URL(string: imgUrl + "/\(name)@4x.png") else { return }
        let req = URLRequest(url: url)
        URLSession.shared.dataTask(with: req) { data, _, error in
            if error == nil,
               let data {
                guard let weatherIcon = UIImage(data: data) else {return}
                self.relayWeatherIcon.accept(weatherIcon)
            }
        }.resume()
    }
    func getCurrentWeather(in city: String) {
        getCoordinate(from: city) { [weak self] location in
            self?.sendRequest(type: .current, with: location.latitude, and: location.longitude) { [weak self] data in
                self?.parseData(from: data, in: CurrentWeather.self, completion: { weather in
                    guard let icon = weather.weather?[0].icon else { return }
                    self?.getIcon(with: icon)
                    self?.relayCurrentWeather.accept(weather)
                })
            }
        }
    }
    func getForecastWeather(in city: String) {
        getCoordinate(from: city) { [weak self] location in
            self?.sendRequest(type: .forecast, with: location.latitude, and: location.longitude, completion: { [weak self] data in
                self?.parseData(from: data, in: Forecast.self, completion: { weather in
                    var forecast = weather
                    forecast.list = weather.list?.filter({
                        $0.dt_txt.contains("12:00:00")
                    })
                    self?.relayForecastWeather.accept(forecast)
                })
            })
        }
    }
    func getWeatherXYI(lat: Double, lon: Double) {
        
    }
    func getRelayCurrent() -> PublishRelay<CurrentWeather> {
        self.relayCurrentWeather
    }
    func getRelayForecast() -> PublishRelay<Forecast> {
        self.relayForecastWeather
    }
    func getRelayIcon() -> PublishRelay<UIImage> {
        self.relayWeatherIcon
    }
}
