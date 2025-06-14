//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Алексей Непряхин on 09.06.2025.
//

import Foundation
import UIKit

final class ScheduleCell: UITableViewCell {
    let dayLabel = UILabel()
    let switcher = UISwitch()
    
    var delegate: ScheduleCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .ypGray30
        
        addDayLabel()
        addSwitcher()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addDayLabel() {
        dayLabel.font = UIFont.systemFont(ofSize: 17)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func addSwitcher() {
        switcher.addTarget(self, action: #selector(switcherTapped), for: .valueChanged)
        switcher.isOn = true
        switcher.onTintColor = .ypBlueSwitch
        switcher.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(switcher)
        
        NSLayoutConstraint.activate([
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc func switcherTapped() {
        guard let weekday = dayLabel.text else {
            print("[ScheduleCell]: switcherTapped - dayLebel has no text.")
            return
        }
        
        delegate?.changeWeekday(isOn: switcher.isOn, weekday: weekday)
    }
}
