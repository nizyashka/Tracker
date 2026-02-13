import UIKit

final class FiltersViewController: UIViewController {
    let viewTitleLabel = UILabel()
    let filtersTableView = UITableView()
    
    let filters = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    
    weak var filtersViewControllerDelegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        configureViewTitleLabel()
        configureFiltersTableView()
    }
    
    private func configureViewTitleLabel() {
        viewTitleLabel.text = "Фильтры"
        viewTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewTitleLabel)
        
        NSLayoutConstraint.activate([
            viewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    private func configureFiltersTableView() {
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        
        filtersTableView.register(FilterCell.self, forCellReuseIdentifier: "filterCell")
        
        filtersTableView.layer.cornerRadius = 16
        filtersTableView.layer.masksToBounds = true
        filtersTableView.allowsMultipleSelection = false
        filtersTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        filtersTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersTableView)
        
        NSLayoutConstraint.activate([
            filtersTableView.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 38),
            filtersTableView.bottomAnchor.constraint(equalTo: filtersTableView.topAnchor, constant: 299),
            filtersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func saveSelectedFilter(filterIndex: Int) {
        UserDefaults.standard.set(filterIndex, forKey: "selectedFilter")
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = filtersTableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as? FilterCell else {
            print("[FiltersViewController] - tableView: Was unable to dequeue a cell")
            return UITableViewCell()
        }
        
        cell.filterNameLabel.text = filters[indexPath.row]
        
        let selectedIndex = UserDefaults.standard.integer(forKey: "selectedFilter")
        
        if indexPath.row == selectedIndex && indexPath.row > 1 {
            cell.checkmarkImageView.isHidden = false
        } else {
            cell.checkmarkImageView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for visibleIndexPath in filtersTableView.indexPathsForVisibleRows ?? [] {
            if let cell = filtersTableView.cellForRow(at: visibleIndexPath) as? FilterCell {
                cell.checkmarkImageView.isHidden = true
            }
        }
        
        if let selectedCell = filtersTableView.cellForRow(at: indexPath) as? FilterCell,
           indexPath.row > 1 {
            selectedCell.checkmarkImageView.isHidden = false
        }
        
        filtersTableView.deselectRow(at: indexPath, animated: true)
        
        saveSelectedFilter(filterIndex: indexPath.row)
        filtersViewControllerDelegate?.updateCollectionViewWithoutChanges()
        
        dismiss(animated: true)
    }
}
