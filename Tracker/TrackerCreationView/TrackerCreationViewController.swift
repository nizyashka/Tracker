//
//  Untitled.swift
//  Tracker
//
//  Created by Алексей Непряхин on 06.06.2025.
//

import UIKit

final class TrackerCreationViewController: UIViewController {
    let viewTitleLabel = UILabel()
    let stackView = UIStackView()
    let habitButton = UIButton()
    let irregularEventButton = UIButton()
    weak var delegate: NewTrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addViewTitleLabel()
        addHabitAndIrregularEventButtonsStackView()
    }
    
    private func addViewTitleLabel() {
        viewTitleLabel.text = "Создание трекера"
        viewTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewTitleLabel)
        
        NSLayoutConstraint.activate([
            viewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    private func addHabitAndIrregularEventButtonsStackView() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 136),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        habitButton.titleLabel?.textColor = .white
        habitButton.backgroundColor = .ypBlack
        habitButton.layer.cornerRadius = 16
        habitButton.layer.masksToBounds = true
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(habitButton)
    
        irregularEventButton.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        irregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        irregularEventButton.titleLabel?.textColor = .white
        irregularEventButton.backgroundColor = .ypBlack
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.layer.masksToBounds = true
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(irregularEventButton)
    }
    
    @objc private func habitButtonTapped() {
        let newTrackerViewController = NewTrackerViewController(cellType: "habitCell", newTrackerViewControllerDelegate: delegate)
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: true)
    }
    
    @objc private func irregularEventButtonTapped() {
        let newTrackerViewController = NewTrackerViewController(cellType: "irregularEventCell", newTrackerViewControllerDelegate: delegate)
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: true)
    }
}
