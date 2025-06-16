//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 06.06.2025.
//

import Foundation
import UIKit

protocol NewTrackerViewCellDelegate: AnyObject {
    func cancel()
    func addNewTracker(trackerName: String, trackerCategory: String, trackerColor: UIColor, trackerEmoji: String, scheduledWeekdays: [String])
    func present(_ viewController: UIViewController)
}

class NewHabitViewController: UIViewController {
    private let tableView = UITableView()
    
    weak var newHabitViewControllerDelegate: NewHabitViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NewTrackerViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updateCollectionViewSection(newCategories: [TrackerCategory], section: Int, pickedWeekdays: [String]) {
        newHabitViewControllerDelegate?.updateCollectionViewSection(newCategories: newCategories, section: section, pickedWeekdays: pickedWeekdays)
        newHabitViewControllerDelegate?.dismiss()
    }
    
    func createTracker(trackerName: String, trackerColor: UIColor, trackerEmoji: String, scheduledWeekdays: [String]) -> Tracker {
        return Tracker(id: UUID.init(),
                       name: trackerName,
                       color: trackerColor,
                       emoji: trackerEmoji,
                       schedule: scheduledWeekdays)
    }
}

extension NewHabitViewController: NewTrackerViewCellDelegate {
    func cancel() {
        newHabitViewControllerDelegate?.dismiss()
    }
    
    func addNewTracker(trackerName: String, trackerCategory: String, trackerColor: UIColor, trackerEmoji: String, scheduledWeekdays: [String]) {
        var categoryIndex: Int = 0
        
        guard var existingCategories = newHabitViewControllerDelegate?.getCategories() else {
            print("[NewHabitViewController]: createButtonTapped - Categories not found.")
            return
        }
        
        if existingCategories.isEmpty {
            let newCategory = TrackerCategory(
                title: trackerCategory,
                trackers: [createTracker(trackerName: trackerName, trackerColor: trackerColor, trackerEmoji: trackerEmoji, scheduledWeekdays: scheduledWeekdays)])
            
            updateCollectionViewSection(newCategories: [newCategory], section: 0, pickedWeekdays: scheduledWeekdays)
            
            return
        }
        
        for existingCategory in existingCategories {
            if existingCategory.title == trackerCategory {
                let newTracker = createTracker(trackerName: trackerName, trackerColor: trackerColor, trackerEmoji: trackerEmoji, scheduledWeekdays: scheduledWeekdays)
                let newTrackers = (existingCategory.trackers ?? []) + [newTracker]
                let newCategory = TrackerCategory(
                    title: trackerCategory,
                    trackers: newTrackers)
                
                if let index = existingCategories.firstIndex(where: { $0.title == newCategory.title }) {
                    categoryIndex = index
                    existingCategories[index] = newCategory
                }
                
                let newCategories = existingCategories
                
                updateCollectionViewSection(newCategories: newCategories, section: categoryIndex, pickedWeekdays: scheduledWeekdays)
                
                return
            }
        }
        
        let newCategory = TrackerCategory(
            title: trackerCategory,
            trackers: [createTracker(trackerName: trackerName, trackerColor: trackerColor, trackerEmoji: trackerEmoji, scheduledWeekdays: scheduledWeekdays)])
        
        let newCategories = existingCategories + [newCategory]
        
        updateCollectionViewSection(newCategories: newCategories, section: newCategories.count - 1, pickedWeekdays: scheduledWeekdays)
    }
    
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
}

extension NewHabitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewTrackerViewCell else {
            print("[NewHabitViewController] - tableView: Unable to dequeue a cell.")
            return UITableViewCell()
        }
        
        cell.newTrackerViewCellDelegate = self
        
        return cell
    }
}
