//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Егор on 27.02.2024.
//

import Foundation
import RxSwift
import RxRelay

protocol iWeather {
    var relayCurrent: PublishRelay<CurrentWeather> { get }
    var relayForecast: PublishRelay<Forecast> { get }
    var relayWeatherIcon: PublishRelay<UIImage> { get }
    func getWeather()
    func getWeatherIn(city: String)
}
final class WeatherViewModel: iWeather {
    
    private let disposeBag = DisposeBag()
    private var service: iNetworkService
    private var location: LocationService
    
    let relayCurrent = PublishRelay<CurrentWeather>()
    let relayForecast = PublishRelay<Forecast>()
    let relayWeatherIcon = PublishRelay<UIImage>()
    
    init() {
        self.service = NetworkService()
        self.location = LocationService()
        
        self.service.getRelayCurrent().subscribe { [weak self] event in
            if let current = event.element {
                self?.relayCurrent.accept(current)
            }
        }.disposed(by: disposeBag)
        self.service.getRelayForecast().subscribe { [weak self] event in
            if let forecast = event.element {
                self?.relayForecast.accept(forecast)
            }
        }.disposed(by: disposeBag)
        self.service.getRelayIcon().subscribe { [weak self] event in
            if let icon = event.element {
                self?.relayWeatherIcon.accept(icon)
            }
        }.disposed(by: disposeBag)
    }
    func getWeather() {
        location.relay.subscribe { [weak self] event in
            if let city = event.element {
                self?.service.getCurrentWeather(in: city)
                self?.service.getForecastWeather(in: city)
            }
        }.disposed(by: disposeBag)
    }
    func getWeatherIn(city: String) {
        service.getCurrentWeather(in: city)
        service.getForecastWeather(in: city)
    }
    func getWeatherXYI(lat: Double, lon: Double) {
        service.getWeatherXYI(lat: lat, lon: lon)
    }
}
