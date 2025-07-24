//
//  FilterCell.swift
//  Tracker
//
//  Created by Алексей Непряхин on 19.07.2025.
//

import UIKit

final class FilterCell: UITableViewCell {
    let filterNameLabel = UILabel()
    let checkmarkImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .ypGray30
        
        configureFilterNameLabel()
        configureCheckmarkImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFilterNameLabel() {
        filterNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        filterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(filterNameLabel)
        
        NSLayoutConstraint.activate([
            filterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            filterNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func configureCheckmarkImageView() {
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.isHidden = true
        checkmarkImageView.tintColor = .systemBlue
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
