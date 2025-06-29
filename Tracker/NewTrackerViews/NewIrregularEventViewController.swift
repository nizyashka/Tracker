//
//  NewIrregularEventViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 06.06.2025.
//

import UIKit

final class NewIrregularEventViewController: NewHabitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func registerCell() {
        tableView.register(NewIrregularEventViewCell.self, forCellReuseIdentifier: cellType)
    }
}

extension NewIrregularEventViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as? NewIrregularEventViewCell else {
            print("[NewHabitViewController] - tableView: Unable to dequeue a cell.")
            return UITableViewCell()
        }
        
        cell.newTrackerViewCellDelegate = self
        
        return cell
    }
}
