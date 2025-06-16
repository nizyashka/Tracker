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
    }
    
    override func createTracker(trackerName: String, trackerColor: UIColor, trackerEmoji: String, scheduledWeekdays: [String]) -> Tracker {
        return Tracker(id: UUID.init(),
                       name: trackerName,
                       color: trackerColor,
                       emoji: trackerEmoji,
                       schedule: [DateFormatter.trackerDateFormatter.string(from: Date())])
    }
}
