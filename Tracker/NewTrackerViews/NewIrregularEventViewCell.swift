//
//  NewTrackerViewCell.swift
//  Tracker
//
//  Created by Алексей Непряхин on 16.06.2025.
//

import UIKit

final class NewIrregularEventViewCell: NewHabitViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewTitleLabel.text = "Новое нерегулярное событие"
        navigationalTableView.bottomAnchor.constraint(equalTo: navigationalTableView.topAnchor, constant: 75).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
