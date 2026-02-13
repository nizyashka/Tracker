import UIKit

protocol ScheduleCellDelegate: AnyObject {
    func changeWeekday(isOn: Bool, weekday: String)
}

final class ScheduleViewController: UIViewController, ScheduleCellDelegate {
    private let viewTitleLabel = UILabel()
    private let tableView = UITableView()
    private let doneButton = UIButton()
    
    weak var scheduleViewControllerDelegate: ScheduleViewControllerDelegate?
    
    private let weekdays = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    var pickedWeekdays = [2, 3, 4, 5, 6, 7, 1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureViewTitleLabel()
        configureTableView()
        configureDoneButton()
    }
    
    private func configureViewTitleLabel() {
        viewTitleLabel.text = "Расписание"
        viewTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewTitleLabel)
        
        NSLayoutConstraint.activate([
            viewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: "cell")
        
        tableView.tableHeaderView = UIView()
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 531),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureDoneButton() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
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
    
    @objc func doneButtonTapped() {
        let pickedWeekdaysString = pickedWeekdays.map { String($0) }
        scheduleViewControllerDelegate?.setNewScheduleWeekdays(pickedWeekdays: pickedWeekdaysString)
        dismiss(animated: true)
    }
    
    func changeWeekday(isOn: Bool, weekday: String) {
        guard let weekdayIndex = weekdays.firstIndex(of: weekday) else {
            print("[ScheduleViewController]: changeWeekday - Weekdays has no such weekday.")
            return
        }
        
        let removedElement = pickedWeekdays.remove(at: weekdayIndex)
        pickedWeekdays.insert(-removedElement, at: weekdayIndex)
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ScheduleCell else {
            print("[ScheduleViewController]: tableView - Unable to dequeue a cell.")
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.dayLabel.text = weekdays[indexPath.row]
        cell.switcher.isOn = pickedWeekdays[indexPath.row] > 0 ? true : false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
