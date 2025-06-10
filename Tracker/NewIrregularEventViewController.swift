//
//  NewIrregularEventViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 06.06.2025.
//

import Foundation
import UIKit

final class NewIrregularEventViewController: NewHabitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addNavigationTitle("Новое нерегулярное событие")
        addTrackerNameTextField()
        registerCell()
        configureTableView(height: 75)
        addCancelCreateButtonsStackView()
    }
}

extension NewIrregularEventViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TrackerTypeCell else {
            return UITableViewCell()
        }
        
        cell.typeLabel.text = "Категория"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
