//
//  MainTableViewCell.swift
//  WeatherApp
//
//  Created by Егор on 27.02.2024.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static var indentifier: String { "\(Self.self)" }
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.dayLabel.text = nil
        self.weatherImage.image = nil
        self.tempLabel.text = nil
    }
    
    // MARK: - Methods
    
    func configure(forecast: Forecast?) {
        guard let forecast else { return }
        
        self.dayLabel.text = self.getDayFromDate(time: forecast.dateTS)
        self.weatherImage.image = UIImage(named: forecast.parts.evening.condition)
        self.tempLabel.text = "\(forecast.parts.evening.tempAVG)"
    }
    
    private func getDayFromDate(time: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(time))
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.dayLabel)
        self.contentView.addSubview(self.weatherImage)
        self.contentView.addSubview(self.tempLabel)
        
        self.dayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.offset)
            make.centerY.equalToSuperview()
        }
        
        self.weatherImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(self.contentView.frame.size.height / 1.5)
        }
        
        self.tempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Constants.offset)
            make.centerY.equalToSuperview()
        }
    }
}
