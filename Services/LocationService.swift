//
//  LocationService.swift
//  WeatherApp
//
//  Created by Егор on 27.02.2024.
//

import Foundation
import RxRelay
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    let relay = PublishRelay<String>()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationSafe = locations.last {
            locationManager.stopUpdatingLocation()
            CLGeocoder().reverseGeocodeLocation(locationSafe) { place, error in
                if error == nil,
                   let name = place?.last?.name {
                    self.relay.accept(name)
                } else {
                    print(error!.localizedDescription)
                }
            }
            
        }
    }
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            manager.requestLocation()
        case .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined:
            print("not Determined")
        case .restricted:
            print("restricted")
        case .denied:
            print("error, location denied")
        @unknown default:
            fatalError()
        }
    }
    
}
