//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 06.06.2025.
//

import Foundation
import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func setNewScheduleWeekdays(pickedWeekdays: [String])
}

class NewHabitViewController: UIViewController {
    private let viewTitleLabel = UILabel()
    private let trackerNameTextField = PaddedTextField()
    private let tableView = UITableView()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    private let cancelCreateButtonsStackView = UIStackView()
    
    var newHabitViewControllerDelegate: NewHabitViewControllerDelegate?
    
    private let tableViewOptions = ["Категория", "Расписание"]
    private var scheduledWeekdays = ["2", "3", "4", "5", "6", "7", "1"]
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addViewTitleLabel(title: "Новая привычка")
        addTrackerNameTextField()
        configureTableView(height: 150)
        registerCell()
        addCancelCreateButtonsStackView()
    }
    
    //MARK: - UI Components Configuration Functions
    func addViewTitleLabel(title: String) {
        viewTitleLabel.text = title
        viewTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewTitleLabel)
        
        NSLayoutConstraint.activate([
            viewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    func addTrackerNameTextField() {
        trackerNameTextField.delegate = self
        guard let trackerNameTextFieldDelegate = trackerNameTextField.delegate else {
            print("[NewHabitViewController]: addTrackerNameTextField - No delegate found.")
            return
        }
        
        trackerNameTextFieldDelegate.textFieldDidEndEditing?(trackerNameTextField)
        trackerNameTextField.becomeFirstResponder()
        trackerNameTextField.returnKeyType = UIReturnKeyType.done
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.backgroundColor = .ypGray30
        trackerNameTextField.font = UIFont.systemFont(ofSize: 17)
        trackerNameTextField.layer.cornerRadius = 16
        trackerNameTextField.layer.masksToBounds = true
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackerNameTextField)
        
        NSLayoutConstraint.activate([
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameTextField.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 38),
            trackerNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func configureTableView(height: CGFloat) {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: height),
            tableView.leadingAnchor.constraint(equalTo: trackerNameTextField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trackerNameTextField.trailingAnchor)
        ])
    }
    
    func registerCell() {
        tableView.register(TrackerTypeCell.self, forCellReuseIdentifier: "cell")
    }
    
    func addCancelCreateButtonsStackView() {
        cancelCreateButtonsStackView.spacing = 8
        cancelCreateButtonsStackView.axis = .horizontal
        cancelCreateButtonsStackView.distribution = .fillEqually
        cancelCreateButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelCreateButtonsStackView)
        
        NSLayoutConstraint.activate([
            cancelCreateButtonsStackView.heightAnchor.constraint(equalToConstant: 60),
            cancelCreateButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelCreateButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelCreateButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.tintColor = .red
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelCreateButtonsStackView.addArrangedSubview(cancelButton)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.isEnabled = false
        createButton.setTitle("Создать", for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.backgroundColor = .ypGrayDisabledButton
        createButton.setTitleColor(.white, for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.translatesAutoresizingMaskIntoConstraints = false
        cancelCreateButtonsStackView.addArrangedSubview(createButton)
    }
    
    //MARK: - UI Components Actions
    @objc private func cancelButtonTapped() {
        newHabitViewControllerDelegate?.dismiss()
    }
    
    @objc private func createButtonTapped() {
        var categoryIndex: Int = 0
        let trackerCategory = "Категория 1" //В теории берется из UI
        let trackerColor: UIColor = .ypGreen //В теории берется из UI
        let trackerEmoji = "🍎" //В теории берется из UI
        
        guard let trackerName = trackerNameTextField.text else {
            print("[NewHabitViewController]: createButtonTapped - No text in trackerNameTextField.")
            return
        }
        
        guard var existingCategories = newHabitViewControllerDelegate?.getCategories() else {
            print("[NewHabitViewController]: createButtonTapped - Categories not found.")
            return
        }
        
        if existingCategories.isEmpty {
            let newCategory = TrackerCategory(
                title: trackerCategory,
                trackers: [createTracker(trackerName: trackerName, trackerColor: trackerColor, trackerEmoji: trackerEmoji)])
            
            updateCollectionViewSection(newCategories: [newCategory], section: 0, pickedWeekdays: scheduledWeekdays)
            
            return
        }
        
        for existingCategory in existingCategories {
            if existingCategory.title == trackerCategory {
                let newTracker = createTracker(trackerName: trackerName, trackerColor: trackerColor, trackerEmoji: trackerEmoji)
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
            trackers: [createTracker(trackerName: trackerName, trackerColor: trackerColor, trackerEmoji: trackerEmoji)])
        
        let newCategories = existingCategories + [newCategory]
        
        updateCollectionViewSection(newCategories: newCategories, section: newCategories.count - 1, pickedWeekdays: scheduledWeekdays)
    }
    
    private func updateCollectionViewSection(newCategories: [TrackerCategory], section: Int, pickedWeekdays: [String]) {
        newHabitViewControllerDelegate?.updateCollectionViewSection(newCategories: newCategories, section: section, pickedWeekdays: pickedWeekdays)
        newHabitViewControllerDelegate?.dismiss()
    }
    
    func createTracker(trackerName: String, trackerColor: UIColor, trackerEmoji: String) -> Tracker {
        return Tracker(id: UUID.init(),
                       name: trackerName,
                       color: trackerColor,
                       emoji: trackerEmoji,
                       schedule: scheduledWeekdays)
    }
}

extension NewHabitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TrackerTypeCell else {
            print("[NewHabitViewController]: tableView - Was unable to dequeue a cell.")
            return UITableViewCell()
        }
        
        cell.typeLabel.text = tableViewOptions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewOptions[indexPath.row] == "Категория" {
            print("Переход на категория")
        } else if tableViewOptions[indexPath.row] == "Расписание" {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.scheduleViewControllerDelegate = self
            present(scheduleViewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewHabitViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.hasText {
            createButton.backgroundColor = .ypBlack
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .ypGrayDisabledButton
            createButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

extension NewHabitViewController: ScheduleViewControllerDelegate {
    func setNewScheduleWeekdays(pickedWeekdays: [String]) {
        scheduledWeekdays = pickedWeekdays
    }
}
