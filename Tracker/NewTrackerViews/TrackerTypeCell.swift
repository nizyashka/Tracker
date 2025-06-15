//
//  TrackerTypeCell.swift
//  Tracker
//
//  Created by Алексей Непряхин on 06.06.2025.
//

import UIKit

final class TrackerTypeCell: UITableViewCell {
    let typeLabel = UILabel()
    let imageViewArrow = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .ypGray30
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addTypeLabel()
        addImageView()
    }
    
    private func addTypeLabel() {
        typeLabel.font = UIFont.systemFont(ofSize: 17)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(typeLabel)
        
        NSLayoutConstraint.activate([
            typeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    private func addImageView() {
        imageViewArrow.image = UIImage(systemName: "chevron.right")
        imageViewArrow.tintColor = .lightGray
        imageViewArrow.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageViewArrow)
        
        NSLayoutConstraint.activate([
            imageViewArrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageViewArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
