////
////  TrackerEditViewController.swift
////  Tracker
////
////  Created by Алексей Непряхин on 14.07.2025.
////
//
//import UIKit
//
//protocol TrackerEditViewControllerDelegate: AnyObject {
//    
//}
//
//final class TrackerEditViewController: NewHabitViewController {
//    var trackerName: String
//    var trackerCategory: String
//    var trackerSchedule: [String]
//    var trackerEmoji: String
//    var trackerColor: String
//    
//    weak var trackerEditViewControllerDelegate: TrackerEditViewControllerDelegate?
//    
//    init(cellType: String, trackerName: String, trackerCategory: String, trackerSchedule: [String], trackerEmoji: String, trackerColor: String, trackerEditViewControllerDelegate: TrackerEditViewControllerDelegate? = nil) {
//        self.trackerName = trackerName
//        self.trackerCategory = trackerCategory
//        self.trackerSchedule = trackerSchedule
//        self.trackerEmoji = trackerEmoji
//        self.trackerColor = trackerColor
//        self.trackerEditViewControllerDelegate = trackerEditViewControllerDelegate
//        super.init(cellType: cellType)
//    }
//    
//    @MainActor required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func registerCell() {
//        tableView.register(TrackerEditViewCell.self, forCellReuseIdentifier: cellType)
//    }
//}
//
//extension TrackerEditViewController {
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as? TrackerEditViewCell else {
//            print("[TrackerEditViewController] - tableView: Unable to dequeue a cell.")
//            return UITableViewCell()
//        }
//        
//        cell.newTrackerViewCellDelegate = self
//        cell.trackerNameTextField.text = trackerName
//        
//        return cell
//    }
//}
