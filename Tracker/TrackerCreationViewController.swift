//
//  Untitled.swift
//  Tracker
//
//  Created by Алексей Непряхин on 06.06.2025.
//

import Foundation
import UIKit

final class TrackerCreationViewController: UIViewController {
    let habitButton = UIButton()
    let irregularEventButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addNavigationTitle()
        addHabitButton()
        addIrregularEventButton()
    }
    
    private func addNavigationTitle() {
        navigationItem.largeTitleDisplayMode = .never
        title = "Создание трекера"
    }
    
    private func addHabitButton() {
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        habitButton.titleLabel?.textColor = .white
        habitButton.backgroundColor = .ypBlack
        habitButton.layer.cornerRadius = 16
        habitButton.layer.masksToBounds = true
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(habitButton)
        
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -357),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func addIrregularEventButton() {
        irregularEventButton.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        irregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        irregularEventButton.titleLabel?.textColor = .white
        irregularEventButton.backgroundColor = .ypBlack
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.layer.masksToBounds = true
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(irregularEventButton)
        
        NSLayoutConstraint.activate([
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func habitButtonTapped() {
        let newHabitViewController = NewHabitViewController()
        newHabitViewController.modalPresentationStyle = .pageSheet
        present(newHabitViewController, animated: true)
//        navigationController?.pushViewController(newHabitViewController, animated: true)
    }
    
    @objc private func irregularEventButtonTapped() {
        let newIrregularEventViewController = NewIrregularEventViewController()
        newIrregularEventViewController.modalPresentationStyle = .pageSheet
        present(newIrregularEventViewController, animated: true)
//        navigationController?.pushViewController(newIrregularEventViewController, animated: true)
    }
}
