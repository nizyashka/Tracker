//
//  TrackerEditViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 14.07.2025.
//

import UIKit

protocol TrackerEditViewControllerDelegate: AnyObject {
    
}

final class TrackerEditViewController: NewTrackerViewController {
    let daysCounterLabel = UILabel()
    
    var trackerID: UUID?
    var daysCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTitleLabel.text = cellType == "habitCell" ? "Редактирование привычки" : "Редактирование нерегулярного события"
        createButton.setTitle("Сохранить", for: .normal)
        configureDaysCounterLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectEmojiAndColor()
    }
    
    func setProperties(trackerID: UUID, trackerName: String, trackerCategory: String, schedule: [String], emoji: String, color: String, daysCount: Int) {
        self.trackerID = trackerID
        trackerNameTextField.text = trackerName
        self.trackerCategory = trackerCategory
        self.scheduledWeekdays = schedule
        self.pickedEmoji = emoji
        self.pickedColor = color
        self.daysCount = daysCount
    }
    
    func selectEmojiAndColor() {
        guard let pickedEmoji,
              let pickedColor,
              let rowEmoji = emoji.firstIndex(of: pickedEmoji),
              let rowColor = colorNames.firstIndex(of: pickedColor) else {
                return
            }
        
        emojiCollectionView.selectItem(at: IndexPath(row: rowEmoji, section: 0), animated: false, scrollPosition: [])
        emojiCollectionView.delegate?.collectionView?(emojiCollectionView, didSelectItemAt: IndexPath(row: rowEmoji, section: 0))
        
        colorCollectionView.selectItem(at: IndexPath(row: rowColor, section: 0), animated: false, scrollPosition: [])
        colorCollectionView.delegate?.collectionView?(colorCollectionView, didSelectItemAt: IndexPath(row: rowColor, section: 0))
    }
    
    private func configureDaysCounterLabel() {
        daysCounterLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        if [0, 5, 6, 7, 8, 9].contains(daysCount % 10) || [11, 12, 13, 14].contains(daysCount % 100) {
            daysCounterLabel.text = "\(daysCount) дней"
        } else if [2, 3, 4].contains(daysCount % 10) {
            daysCounterLabel.text = "\(daysCount) дня"
        } else if daysCount % 10 == 1 {
            daysCounterLabel.text = "\(daysCount) день"
        }
        
        daysCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(daysCounterLabel)
        
        trackerNameTextFieldConstraint.isActive = false
        
        NSLayoutConstraint.activate([
            daysCounterLabel.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 38),
            daysCounterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerNameTextField.topAnchor.constraint(equalTo: daysCounterLabel.bottomAnchor, constant: 40)
        ])
    }
    
    @objc override func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc override func createButtonTapped() {
        saveChangesToCoreData()
    }
    
    //MARK: - Core Data
    
    private func saveChangesToCoreData() {
        guard let trackers = dataProvider.fetchTrackers(),
              let trackerCategory,
              let trackerCategoryCoreData = dataProvider.trackerCategoriesStore.getCategory(by: trackerCategory),
              let categories = dataProvider.fetchedResultsController.fetchedObjects,
              let tracker = trackers.first(where: { $0.id == trackerID }) else {
            print("[TrackerEditViewController] - saveChangesToCoreData: Unexpected error.")
            return
        }
        
        tracker.name = trackerNameTextField.text
        tracker.category = trackerCategoryCoreData
        tracker.schedule = scheduledWeekdays
        tracker.emoji = pickedEmoji
        tracker.color = pickedColor
        
        let category = categories[0]
        category.setValue(category.value(forKey: "title"), forKey: "title")
        
        do {
            try CoreDataStack.shared.saveContext()
            newTrackerViewControllerDelegate?.updateCollectionView()
            dismiss(animated: true)
        } catch {
            print("[TrackerEditViewController] - saveChangesToCoreData: Error saving context.")
        }
    }
}
