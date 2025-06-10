//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 09.06.2025.
//

import Foundation
import UIKit

final class ScheduleViewController: UIViewController {
    private let tableView = UITableView()
    private let doneButton = UIButton()
    private let weekDays = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addNavigationTitle("Расписание")
        configureTableView()
        registerCell()
        addDoneButton()
    }
    
    private func addNavigationTitle(_ title: String) {
        navigationItem.largeTitleDisplayMode = .never
        self.title = title
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableHeaderView = UIView()
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
//            tableView.heightAnchor.constraint(equalToConstant: 531),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 531),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func registerCell() {
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func addDoneButton() {
        doneButton.setTitle("Готово", for: .normal)
        doneButton.backgroundColor = .ypBlack
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        doneButton.layer.cornerRadius = 16
        doneButton.layer.masksToBounds = true
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ScheduleCell else {
            return UITableViewCell()
        }
        
        cell.dayLabel.text = weekDays[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
