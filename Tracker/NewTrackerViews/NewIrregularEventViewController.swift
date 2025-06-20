//
//  NewIrregularEventViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 06.06.2025.
//

import UIKit

final class NewIrregularEventViewController: NewHabitViewController {
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI(title: "Новое нерегулярное событие", height: 75)
    }
    
    override func createTracker(trackerName: String, trackerColor: UIColor, trackerEmoji: String) -> Tracker {
        return Tracker(id: UUID.init(),
                       name: trackerName,
                       color: trackerColor,
                       emoji: trackerEmoji,
                       schedule: [DateFormatter.trackerDateFormatter.string(from: Date())])
    }
}

extension NewIrregularEventViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TrackerTypeCell else {
            print("[NewIrregularEventViewController]: tableView - Unable to dequeue a cell.")
            return UITableViewCell()
        }
        
        cell.typeLabel.text = "Категория"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
