//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 26.05.2025.
//

import Foundation
import UIKit

final class StatisticsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationTitle()
    }
    
    private func addNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Статистика"
    }
}
