//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 06.06.2025.
//

import UIKit

protocol NewTrackerViewCellDelegate: AnyObject {
    var cellType: String { get }
    func addNewTrackerToCoreData(trackerName: String, trackerCategory: String, trackerEmoji: String, trackerColor: String, scheduledWeekdays: [String])
    func present(_ viewController: UIViewController)
    func cancel()
}

class NewHabitViewController: UIViewController {
    let cellType: String
    
    let tableView = UITableView()
    
    weak var newHabitViewControllerDelegate: NewTrackerViewControllerDelegate?
    
    let dataProvider = DataProvider.shared
    
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
    
    private func updateCollectionViewSectionCoreData() {
        newHabitViewControllerDelegate?.updateCollectionView()
        newHabitViewControllerDelegate?.dismiss()
    }
}

extension NewHabitViewController: NewTrackerViewCellDelegate {
    func addNewTrackerToCoreData(trackerName: String, trackerCategory: String, trackerEmoji: String, trackerColor: String, scheduledWeekdays: [String]) {
        if dataProvider.trackerCategories.contains(where: { $0.title == trackerCategory }) {
            guard let categoryIndex = dataProvider.trackerCategories.firstIndex(where: { $0.title == trackerCategory }) else {
                return
            }
            
            let category = dataProvider.trackerCategoriesStore.getCategoryByIndex(index: categoryIndex)
            dataProvider.trackersStore.addNewTracker(name: trackerName, category: category, emoji: trackerEmoji, color: trackerColor, schedule: scheduledWeekdays)
            updateCollectionViewSectionCoreData()
        } else {
            guard let category = dataProvider.trackerCategoriesStore.addNewCategory(title: trackerCategory) else {
                print("[NewHabitViewController] - addNewTrackerToCoreData: Error adding a category.")
                return
            }
            
            dataProvider.trackersStore.addNewTracker(name: trackerName, category: category, emoji: trackerEmoji, color: trackerColor, schedule: scheduledWeekdays)
            updateCollectionViewSectionCoreData()
            
            return
        }
    }
    
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func cancel() {
        newHabitViewControllerDelegate?.dismiss()
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
