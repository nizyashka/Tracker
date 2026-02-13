import UIKit

protocol StatisticsViewControllerDelegate: AnyObject {
    func updateCompletedTrackersCountLabel()
}


final class StatisticsViewController: UIViewController {
    let noStatisticsPlaceholderImageView = UIImageView()
    let noStatisticsPlaceholderLabel = UILabel()
    let completedTrackersCountView = UIView()
    let completedTrackersCountLabel = UILabel()
    let completedTrackersLabel = UILabel()
    
    var completedTrackersCount: Int {
        let completedTrackersCount = dataProvider.fetchTrackerRecords()?.count ?? 0
        
        if completedTrackersCount == 0 {
            noStatisticsPlaceholderImageView.isHidden = false
            noStatisticsPlaceholderLabel.isHidden = false
            completedTrackersCountView.isHidden = true
        } else {
            noStatisticsPlaceholderImageView.isHidden = true
            noStatisticsPlaceholderLabel.isHidden = true
            completedTrackersCountView.isHidden = false
        }
        
        return completedTrackersCount
    }
    
    let dataProvider = DataProvider.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBackground
        
        configurePlaceholder()
        addNavigationTitle()
        configureCompletedTrackersView()
    }
    
    private func addNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = NSLocalizedString("statistics", comment: "Navigational title")
    }
    
    private func configurePlaceholder() {
        noStatisticsPlaceholderImageView.image = UIImage(named: "NoStatisticsPlaceholder")
        noStatisticsPlaceholderImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noStatisticsPlaceholderImageView)
        
        noStatisticsPlaceholderLabel.text = "Анализировать пока нечего"
        noStatisticsPlaceholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        noStatisticsPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noStatisticsPlaceholderLabel)
        
        NSLayoutConstraint.activate([
            noStatisticsPlaceholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noStatisticsPlaceholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noStatisticsPlaceholderImageView.widthAnchor.constraint(equalToConstant: 80),
            noStatisticsPlaceholderImageView.heightAnchor.constraint(equalToConstant: 80),
            
            noStatisticsPlaceholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noStatisticsPlaceholderLabel.topAnchor.constraint(equalTo: noStatisticsPlaceholderImageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func configureCompletedTrackersView() {
        completedTrackersCountView.layer.cornerRadius = 16
        completedTrackersCountView.layer.masksToBounds = true
        completedTrackersCountView.backgroundColor = .ypGray30
        completedTrackersCountView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completedTrackersCountView)
        
        completedTrackersCountLabel.text = String(completedTrackersCount)
        completedTrackersCountLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        completedTrackersCountLabel.translatesAutoresizingMaskIntoConstraints = false
        completedTrackersCountView.addSubview(completedTrackersCountLabel)
        
        completedTrackersLabel.text = "Трекеров завершено"
        completedTrackersLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        completedTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        completedTrackersCountView.addSubview(completedTrackersLabel)
        
        NSLayoutConstraint.activate([
            completedTrackersCountView.heightAnchor.constraint(equalToConstant: 90),
            completedTrackersCountView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            completedTrackersCountView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completedTrackersCountView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completedTrackersCountView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            completedTrackersCountLabel.topAnchor.constraint(equalTo: completedTrackersCountView.topAnchor, constant: 12),
            completedTrackersCountLabel.leadingAnchor.constraint(equalTo: completedTrackersCountView.leadingAnchor, constant: 12),
            
            completedTrackersLabel.bottomAnchor.constraint(equalTo: completedTrackersCountView.bottomAnchor, constant: -12),
            completedTrackersLabel.leadingAnchor.constraint(equalTo: completedTrackersCountLabel.leadingAnchor)
        ])
    }
}

extension StatisticsViewController: StatisticsViewControllerDelegate {
    func updateCompletedTrackersCountLabel() {
        completedTrackersCountLabel.text = String(completedTrackersCount)
    }
}
