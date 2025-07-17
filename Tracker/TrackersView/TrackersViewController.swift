//
//  ViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 26.05.2025.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func updateCollectionView()
    func dismiss()
}

protocol TrackerCellDelegate: AnyObject {
    func trackerCompleted()
    func trackerFailed()
    func getCurrentDate() -> Date?
    func getDatePickerDate() -> Date?
    func updateCollectionViewCell(for indexPath: IndexPath)
}

final class TrackersViewController: UIViewController {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let noTrackersPlaceholderImageView = UIImageView()
    let noTrackersPlaceholderLabel = UILabel()
    let datePicker = UIDatePicker()
    
    let dataProvider = DataProvider.shared
    
    var categories: [TrackerCategory] = []
    var filteredTrackers: [Tracker] = []
    var filteredCategories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate: String = ""
    var pickedWeekday: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDate = DateFormatter.trackerDateFormatter.string(from: Date())
        pickedWeekday = String(Calendar.current.component(.weekday, from: datePicker.date))
        
        dataProvider.delegate = self
        
        categories = dataProvider.trackerCategories
        completedTrackers = dataProvider.trackerRecords
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showOnboarding()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        configureNavigationTitle()
        configureBarButton()
        configureDatePicker()
        showPlaceholder()
        configureCollectionView()
        registerCellAndSupplementaryView()
    }
    
    private func showOnboarding() {
        if !UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
            let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            pageViewController.modalPresentationStyle = .overFullScreen
            present(pageViewController, animated: false, completion: nil)
        }
    }
    
    private func configureNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Трекеры"
    }
    
    private func configureBarButton() {
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(barButtonTapped))
        
        barButton.tintColor = UIColor(named: "YP_Black")
        
        navigationItem.leftBarButtonItem = barButton
    }
    
    private func configureDatePicker() {
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc private func datePickerChanged() {
        currentDate = DateFormatter.trackerDateFormatter.string(from: datePicker.date)
        pickedWeekday = String(Calendar.current.component(.weekday, from: datePicker.date))
        collectionView.reloadData()
    }
    
    @objc private func barButtonTapped() {
        let trackerCreationViewController = TrackerCreationViewController()
        trackerCreationViewController.delegate = self
        trackerCreationViewController.modalPresentationStyle = .pageSheet
        present(trackerCreationViewController, animated: true)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func registerCellAndSupplementaryView() {
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CategoryHeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    private func showPlaceholder() {
        noTrackersPlaceholderImageView.image = UIImage(named: "NoTrackersPlaceholder")
        noTrackersPlaceholderImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noTrackersPlaceholderImageView)
        
        noTrackersPlaceholderLabel.text = "Что будем отслеживать?"
        noTrackersPlaceholderLabel.font = UIFont.systemFont(ofSize: 12)
        noTrackersPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noTrackersPlaceholderLabel)
        
        NSLayoutConstraint.activate([
            noTrackersPlaceholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTrackersPlaceholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noTrackersPlaceholderImageView.widthAnchor.constraint(equalToConstant: 80),
            noTrackersPlaceholderImageView.heightAnchor.constraint(equalToConstant: 80),
            
            noTrackersPlaceholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTrackersPlaceholderLabel.topAnchor.constraint(equalTo: noTrackersPlaceholderImageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func removePlaceholder() {
        noTrackersPlaceholderImageView.removeFromSuperview()
        noTrackersPlaceholderLabel.removeFromSuperview()
    }
    
    private func contextualMenuEditTabTapped(for tracker: Tracker, in category: TrackerCategory) {
        let cellType = tracker.schedule.count > 1 ? "habitCell" : "irregularEventCell"
        let daysCount = completedTrackers.count(where: { $0.completedTrackerID == tracker.id })
        
        let trackerEditViewController = TrackerEditViewController(cellType: cellType)
        trackerEditViewController.modalPresentationStyle = .pageSheet
        trackerEditViewController.setProperties(trackerID: tracker.id,
                                                trackerName: tracker.name,
                                                trackerCategory: category.title,
                                                schedule: tracker.schedule,
                                                emoji: tracker.emoji,
                                                color: tracker.color,
                                                daysCount: daysCount)
        present(trackerEditViewController, animated: true)
    }
    
    private func contextualMenuDeleteTabTapped(for tracker: Tracker) {
        let actionSheet = UIAlertController(title: nil, message: "Уверены, что хотите удалить трекер?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            self.dataProvider.trackerCategoriesStore.delete(tracker: tracker)
            self.updateCollectionView()
        }))
        
        self.present(actionSheet, animated: true)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numberOfSections = 0
        filteredCategories = []
        
        for category in categories {
            let scheduledHabitTrackersInCategory = category.trackers.filter( { $0.schedule.contains(pickedWeekday) } ).count
            
            guard let currentDateTemp = getDatePickerDate() else {
                print("[TrackersViewController]: numberOfSections - Unable to get a date.")
                return 0
            }
            
            let scheduledIrregularEventTrackersInCategory = category.trackers.filter({ tracker in
                tracker.schedule.contains(currentDate) ||
                (tracker.schedule.count == 1 && DateFormatter.trackerDateFormatter.date(from: tracker.schedule.first ?? "") ?? Date.distantFuture < currentDateTemp && !completedTrackers.contains(where: { $0.completedTrackerID == tracker.id } )) } ).count //
            
            let scheduledTrackersInCategory = scheduledHabitTrackersInCategory + scheduledIrregularEventTrackersInCategory
            
            if scheduledTrackersInCategory > 0 {
                filteredTrackers = category.trackers.filter( { $0.schedule.contains(pickedWeekday) } )
                filteredTrackers += category.trackers.filter({ tracker in
                    tracker.schedule.contains(currentDate) ||
                    (tracker.schedule.count == 1 && DateFormatter.trackerDateFormatter.date(from: tracker.schedule.first ?? "") ?? Date.distantFuture < currentDateTemp && !completedTrackers.contains(where: { $0.completedTrackerID == tracker.id } )) } )
                filteredCategories += [TrackerCategory(title: category.title, trackers: filteredTrackers)]
                numberOfSections += 1
            }
        }
        
        
        if numberOfSections == 0 {
            showPlaceholder()
        } else {
            removePlaceholder()
        }
        
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let currentCategory = filteredCategories[section]
        
        let scheduledHabitTrackersInCategory = currentCategory.trackers.filter( { $0.schedule.contains(pickedWeekday) } ).count
        
        guard let currentDateTemp = getDatePickerDate() else {
            print("[TrackersViewController]: collectionView - Unable to get a date.")
            return 0
        }
        
        let scheduledIrregularEventTrackersInCategory = currentCategory.trackers.filter({ tracker in
            tracker.schedule.contains(currentDate) ||
            (tracker.schedule.count == 1 && DateFormatter.trackerDateFormatter.date(from: tracker.schedule.first ?? "") ?? Date.distantFuture < currentDateTemp && !completedTrackers.contains(where: { $0.completedTrackerID == tracker.id } )) } ).count
        
        let scheduledTrackersInCategory = scheduledHabitTrackersInCategory + scheduledIrregularEventTrackersInCategory
        
        return scheduledTrackersInCategory
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCell,
        let currentDate = getCurrentDate(),
        let pickedDate = getDatePickerDate() else {
            print("[TrackersViewController]: collectionView - Unable to dequeue a cell or a value.")
            return UICollectionViewCell()
        }
        
        let id = filteredCategories[indexPath.section].trackers[indexPath.row].id
        
        cell.trackerCompleteButton.isEnabled = currentDate < pickedDate ? false : true
        
        cell.indexPath = indexPath
        cell.trackerCellDelegate = self
        cell.trackerID = id
        cell.trackerEmojiSticker.text = filteredCategories[indexPath.section].trackers[indexPath.row].emoji
        cell.trackerCard.backgroundColor = UIColor(named: filteredCategories[indexPath.section].trackers[indexPath.row].color)
        cell.trackerCompleteButton.backgroundColor = UIColor(named: filteredCategories[indexPath.section].trackers[indexPath.row].color)
        
        cell.trackerNameLabel.text = filteredCategories[indexPath.section].trackers[indexPath.row].name
        
        if completedTrackers.contains(where: { $0.completedTrackerID == id && $0.completedTrackerDate == pickedDate}) {
            cell.trackerCompleteButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.trackerCompleteButton.layer.opacity = 0.7
        } else {
            cell.trackerCompleteButton.setImage(UIImage(systemName: "plus"), for: .normal)
            cell.trackerCompleteButton.layer.opacity = 1
        }
        
        let dayCounter: Int = completedTrackers.filter( { id == $0.completedTrackerID } ).count
        
        if [0, 5, 6, 7, 8, 9].contains(dayCounter % 10) || [11, 12, 13, 14].contains(dayCounter % 100) {
            cell.trackerDayCounterLabel.text = "\(dayCounter) дней"
        } else if [2, 3, 4].contains(dayCounter % 10) {
            cell.trackerDayCounterLabel.text = "\(dayCounter) дня"
        } else if dayCounter % 10 == 1 {
            cell.trackerDayCounterLabel.text = "\(dayCounter) день"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? CategoryHeaderSupplementaryView else {
            return UICollectionReusableView()
        }
        
        view.titleLabel.text = filteredCategories[indexPath.section].title
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        let indexPath = indexPaths[0]
        
        let category = filteredCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Редактировать") { [weak self] _ in self?.contextualMenuEditTabTapped(for: tracker, in: category) },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in self?.contextualMenuDeleteTabTapped(for: tracker) }
            ])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else {
            print("[TrackersViewController] - collectionView: Error getting a cell by index path.")
            return nil
        }
        
        return UITargetedPreview(view: cell.trackerCard)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else {
            print("[TrackersViewController] - collectionView: Error getting a cell by index path.")
            return nil
        }
        
        return UITargetedPreview(view: cell.trackerCard)
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - 41
        return CGSize(width: (availableWidth / 2), height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 20)
    }
}

extension TrackersViewController: NewTrackerViewControllerDelegate {
    func updateCollectionView() {
        categories = dataProvider.trackerCategories
        collectionView.reloadData()
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func trackerCompleted() {
        completedTrackers = dataProvider.trackerRecords
    }
    
    func trackerFailed() {
        completedTrackers = dataProvider.trackerRecords
    }
    
    func getCurrentDate() -> Date? {
        let currentDateString = DateFormatter.trackerDateFormatter.string(from: Date())
        guard let currentDate = DateFormatter.trackerDateFormatter.date(from: currentDateString) else {
            print("[TrackersViewController]: getCurrentDate - Unable to get a date.")
            return nil
        }
        
        return currentDate
    }
    
    func getDatePickerDate() -> Date? {
        let datePickerDateString = DateFormatter.trackerDateFormatter.string(from: datePicker.date)
        guard let datePickerDate = DateFormatter.trackerDateFormatter.date(from: datePickerDateString) else {
            print("[TrackersViewController]: getDatePickerDate - Unable to get a date.")
            return nil
        }
        
        return datePickerDate
    }
    
    func updateCollectionViewCell(for indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}

extension TrackersViewController: DataProviderDelegate {
    func updateEverything(index: IndexPath) {
        categories = dataProvider.trackerCategories
        collectionView.reloadData()
    }
}
