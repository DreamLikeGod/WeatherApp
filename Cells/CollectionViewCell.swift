//
//  CollectionViewCell.swift
//  WeatherApp
//
//  Created by Егор on 27.02.2024.
//

import Foundation
import UIKit
import SnapKit

final class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static var identifier: String { "\(Self.self)" }
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var weatherImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Lifycycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.timeLabel.text = nil
        self.weatherImage.image = nil
        self.tempLabel.text = nil
    }
    
    // MARK: - Methods
    
    func configure(hour: Hour) {
        self.timeLabel.text = hour.hour
        self.weatherImage.image = UIImage(named: hour.condition)
        self.tempLabel.text = "\(hour.temp)"
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.weatherImage)
        self.contentView.addSubview(self.tempLabel)
        
        self.weatherImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(self.contentView.frame.size.height / 3)
        }
        
        self.timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.weatherImage.snp.top).offset(-Constants.cellOffset)
        }
        
        self.tempLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.weatherImage.snp.bottom).offset(Constants.cellOffset)
        }
    }
}
