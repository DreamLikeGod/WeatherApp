//
//  ViewController.swift
//  WeatherApp
//
//  Created by Егор on 26.02.2024.
//

import UIKit
import RxSwift
import RxRelay
import SnapKit
import CoreLocation

private extension CGFloat {
    static let cornerRadius: CGFloat = 4
    static let offset: CGFloat = 16
    static let bigOffset: CGFloat = 32
    static let biggestOffset: CGFloat = 64
    static let fontSize: CGFloat = 20
    static let fontDegree: CGFloat = 40
    static let fontCity: CGFloat = 35
}
class MainViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel: iWeather = WeatherViewModel()
    
    private var textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter other city"
        textfield.font = .systemFont(ofSize: .fontSize)
        textfield.layer.cornerRadius = .cornerRadius
        textfield.backgroundColor = .systemGray4
        return textfield
    }()
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: .fontCity)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    private var weatherIcon: UIImageView = {
        let img = UIImageView()
        return img
    }()
    private var degreeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: .fontDegree)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()
    private var descriptLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: .fontSize)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    private var minMaxTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: .fontSize)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        bind()
        viewModel.getWeather()
    }
    
    private func bind() {
        self.viewModel.relayCurrent.subscribe { weather in
            guard let current = weather.element else { return }
            DispatchQueue.main.async {
                self.cityLabel.text = current.name!
                self.degreeLabel.text = "\(current.main!.temp)℃"
                self.descriptLabel.text = current.weather![0].main
                self.minMaxTempLabel.text = "Max.:\(current.main!.temp_max)℃,min.:\(current.main!.temp_min)℃"
            }
        }.disposed(by: disposeBag)
        self.viewModel.relayWeatherIcon.subscribe { icon in
            DispatchQueue.main.async {
                if let weatherIcon = icon.element {
                    self.weatherIcon.image = weatherIcon
                }
            }
        }.disposed(by: disposeBag)
        self.viewModel.relayForecast.subscribe { weather in
            print(weather.element!)
        }.disposed(by: disposeBag)
    }
    private func configTextField() {
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.biggestOffset)
            make.left.equalToSuperview().offset(CGFloat.offset)
            make.right.equalToSuperview().inset(CGFloat.offset)
        }
    }
    private func configCityLabel() {
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(CGFloat.bigOffset)
            make.centerX.equalToSuperview()
        }
    }
    private func configIcon() {
        weatherIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(weatherIcon.snp.height)
            make.top.bottom.equalTo(degreeLabel)
        }
    }
    private func configDegreeLabel() {
        view.addSubview(weatherIcon)
        view.addSubview(degreeLabel)
        degreeLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(CGFloat.offset)
            make.centerX.equalToSuperview()
        }
    }
    private func configDescriptionLabel() {
        view.addSubview(descriptLabel)
        descriptLabel.snp.makeConstraints { make in
            make.top.equalTo(degreeLabel.snp.bottom).offset(CGFloat.offset)
            make.centerX.equalToSuperview()
        }
    }
    private func configMinMaxTempLabel() {
        view.addSubview(minMaxTempLabel)
        minMaxTempLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptLabel.snp.bottom).offset(CGFloat.offset)
            make.centerX.equalToSuperview()
        }
    }
    private func configureScreen() {
        configTextField()
        configCityLabel()
        configDegreeLabel()
        configIcon()
        configDescriptionLabel()
        configMinMaxTempLabel()
    }
}
extension MainViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = self.textField.text {
            viewModel.getWeatherIn(city: text)
        }
    }
}
