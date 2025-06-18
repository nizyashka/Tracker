//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 06.06.2025.
//

import Foundation
import UIKit

protocol NewTrackerViewCellDelegate: AnyObject {
    var cellType: String { get }
    func cancel()
    func addNewTracker(trackerName: String, trackerCategory: String, trackerEmoji: String, trackerColor: UIColor, scheduledWeekdays: [String])
    func present(_ viewController: UIViewController)
}

class NewHabitViewController: UIViewController {
    let cellType: String
    
    let tableView = UITableView()
    
    weak var newHabitViewControllerDelegate: NewTrackerViewControllerDelegate?
    
    init(cellType: String, newHabitViewControllerDelegate: NewTrackerViewControllerDelegate? = nil) {
        self.cellType = cellType
        self.newHabitViewControllerDelegate = newHabitViewControllerDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        registerCell()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
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
    
    func registerCell() {
        tableView.register(NewHabitViewCell.self, forCellReuseIdentifier: cellType)
    }
    
    private func updateCollectionViewSection(newCategories: [TrackerCategory], section: Int, pickedWeekdays: [String]) {
        newHabitViewControllerDelegate?.updateCollectionViewSection(newCategories: newCategories, section: section, pickedWeekdays: pickedWeekdays)
        newHabitViewControllerDelegate?.dismiss()
    }
    
    private func createTracker(trackerName: String, trackerEmoji: String, trackerColor: UIColor, scheduledWeekdays: [String]) -> Tracker {
        return Tracker(id: UUID.init(),
                       name: trackerName,
                       emoji: trackerEmoji,
                       color: trackerColor,
                       schedule: scheduledWeekdays)
    }
}

extension NewHabitViewController: NewTrackerViewCellDelegate {
    func cancel() {
        newHabitViewControllerDelegate?.dismiss()
    }
    
    func addNewTracker(trackerName: String, trackerCategory: String, trackerEmoji: String, trackerColor: UIColor, scheduledWeekdays: [String]) {
        var categoryIndex: Int = 0
        
        guard var existingCategories = newHabitViewControllerDelegate?.getCategories() else {
            print("[NewHabitViewController]: createButtonTapped - Categories not found.")
            return
        }
        
        if existingCategories.isEmpty {
            let newCategory = TrackerCategory(
                title: trackerCategory,
                trackers: [createTracker(trackerName: trackerName, trackerEmoji: trackerEmoji, trackerColor: trackerColor, scheduledWeekdays: scheduledWeekdays)])
            
            updateCollectionViewSection(newCategories: [newCategory], section: 0, pickedWeekdays: scheduledWeekdays)
            
            return
        }
        
        for existingCategory in existingCategories {
            if existingCategory.title == trackerCategory {
                let newTracker = createTracker(trackerName: trackerName, trackerEmoji: trackerEmoji, trackerColor: trackerColor, scheduledWeekdays: scheduledWeekdays)
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
            trackers: [createTracker(trackerName: trackerName, trackerEmoji: trackerEmoji, trackerColor: trackerColor, scheduledWeekdays: scheduledWeekdays)])
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as? NewHabitViewCell else {
            print("[NewHabitViewController] - tableView: Unable to dequeue a cell.")
            return UITableViewCell()
        }
        
        cell.newTrackerViewCellDelegate = self
        
        return cell
    }
}
