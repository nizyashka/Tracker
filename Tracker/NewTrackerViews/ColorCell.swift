//
//  ColorCell.swift
//  Tracker
//
//  Created by Алексей Непряхин on 16.06.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    let roundedColorRect = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureRoundedColorRect()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureRoundedColorRect() {
        roundedColorRect.isEnabled = false
        roundedColorRect.layer.cornerRadius = 8
        roundedColorRect.layer.masksToBounds = true
        roundedColorRect.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(roundedColorRect)
        
        NSLayoutConstraint.activate([
            roundedColorRect.widthAnchor.constraint(equalToConstant: 40),
            roundedColorRect.heightAnchor.constraint(equalToConstant: 40),
            roundedColorRect.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            roundedColorRect.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
