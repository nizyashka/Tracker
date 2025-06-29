//
//  TrackerCell.swift
//  Tracker
//
//  Created by Алексей Непряхин on 01.06.2025.
//

import Foundation
import UIKit

final class TrackerCell: UICollectionViewCell {
    let trackerCard = UIButton()
    let trackerNameLabel = UILabel()
    let circleView = UIView()
    let trackerEmojiSticker = UILabel()
    let trackerDayCounterLabel = UILabel()
    let trackerCompleteButton = UIButton()
    
    let dataProvider = DataProvider.shared
    
    weak var trackerCellDelegate: TrackerCellDelegate?
    
    var indexPath: IndexPath?
    var trackerID: UUID?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTrackerCard()
        addTrackerNameLabel()
        addEmojiSticker()
        addTrackerDayCounterLabel()
        addTrackerCompleteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTrackerCard() {
        trackerCard.backgroundColor = .ypGreen
        trackerCard.layer.cornerRadius = 15
        trackerCard.clipsToBounds = true
        trackerCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trackerCard)
        
        NSLayoutConstraint.activate([
            trackerCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerCard.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func addTrackerNameLabel() {
        trackerNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        trackerNameLabel.textColor = .white
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerCard.addSubview(trackerNameLabel)
        
        NSLayoutConstraint.activate([
            trackerNameLabel.bottomAnchor.constraint(equalTo: trackerCard.bottomAnchor, constant: -12),
            trackerNameLabel.leadingAnchor.constraint(equalTo: trackerCard.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: trackerCard.trailingAnchor, constant: -12)
        ])
    }
    
    private func addEmojiSticker() {
        circleView.backgroundColor = .white.withAlphaComponent(0.3)
        circleView.layer.cornerRadius = 12
        circleView.clipsToBounds = true
        circleView.translatesAutoresizingMaskIntoConstraints = false
        trackerCard.addSubview(circleView)
        
        trackerEmojiSticker.font = UIFont.systemFont(ofSize: 13)
        trackerEmojiSticker.translatesAutoresizingMaskIntoConstraints = false
        circleView.addSubview(trackerEmojiSticker)
        
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: 24),
            circleView.heightAnchor.constraint(equalToConstant: 24),
            circleView.topAnchor.constraint(equalTo: trackerCard.topAnchor, constant: 12),
            circleView.leadingAnchor.constraint(equalTo: trackerCard.leadingAnchor, constant: 12),
            
            trackerEmojiSticker.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            trackerEmojiSticker.centerYAnchor.constraint(equalTo: circleView.centerYAnchor)
        ])
    }
    
    private func addTrackerDayCounterLabel() {
        trackerDayCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        trackerDayCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trackerDayCounterLabel)
        
        NSLayoutConstraint.activate([
            trackerDayCounterLabel.topAnchor.constraint(equalTo: trackerCard.bottomAnchor, constant: 16),
            trackerDayCounterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
    }
    
    private func addTrackerCompleteButton() {
        trackerCompleteButton.addTarget(self, action: #selector(trackerCompleteButtonTapped), for: .touchUpInside)
        trackerCompleteButton.layer.cornerRadius = 17
        trackerCompleteButton.clipsToBounds = true
        trackerCompleteButton.backgroundColor = .ypGreen
        trackerCompleteButton.tintColor = .white
        trackerCompleteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trackerCompleteButton)
        
        NSLayoutConstraint.activate([
            trackerCompleteButton.widthAnchor.constraint(equalToConstant: 34),
            trackerCompleteButton.heightAnchor.constraint(equalToConstant: 34),
            trackerCompleteButton.topAnchor.constraint(equalTo: trackerCard.bottomAnchor, constant: 8),
            trackerCompleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            trackerCompleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    @objc private func trackerCompleteButtonTapped() {
        guard let currentDate = trackerCellDelegate?.getCurrentDate(),
              let datePickerDate = trackerCellDelegate?.getDatePickerDate(),
              let indexPath,
              let trackerID,
              let tracker = dataProvider.getTrackerByID(id: trackerID) else {
            print("[TrackerCell]: trackerCompleteButtonTapped - Unable to get a value.")
            return
        }
        
        if trackerCompleteButton.currentImage == UIImage(systemName: "plus") {
            if !(datePickerDate > currentDate) {
                trackerCompleteButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                trackerCompleteButton.layer.opacity = 0.7
                
                dataProvider.trackerRecordsStore.addTrackerRecord(tracker: tracker, date: datePickerDate)
                trackerCellDelegate?.trackerCompleted()
            }
        } else {
            trackerCompleteButton.setImage(UIImage(systemName: "plus"), for: .normal)
            trackerCompleteButton.layer.opacity = 1
            
            guard let record = dataProvider.getTrackerRecordByIDAndDate(id: trackerID, date: datePickerDate) else {
                return
            }
            
            dataProvider.trackerRecordsStore.deleteTrackerRecord(record, tracker: tracker)
            trackerCellDelegate?.trackerFailed()
        }
        
        trackerCellDelegate?.updateCollectionViewCell(for: indexPath)
    }
}
