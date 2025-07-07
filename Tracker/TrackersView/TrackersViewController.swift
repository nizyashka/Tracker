//
//  ViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 26.05.2025.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func getCategories() -> [TrackerCategory]
    func updateCollectionViewSection(newCategories: [TrackerCategory], section: Int, pickedWeekdays: [String])
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
    
    let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController.modalPresentationStyle = .overFullScreen
        present(pageViewController, animated: false, completion: nil)
        
        currentDate = DateFormatter.trackerDateFormatter.string(from: Date())
        pickedWeekday = String(Calendar.current.component(.weekday, from: datePicker.date))
        
        dataProvider.delegate = self
        
        categories = dataProvider.trackerCategories
        completedTrackers = dataProvider.trackerRecords
        
        addNavigationTitle()
        addButton()
        addDatePicker()
        showPlaceholder()
        configureCollectionView()
        registerCellAndSupplementaryView()
        
//        let pageViewController = PageViewController()
//        addChild(pageViewController)
//        view.insertSubview(pageViewController.view, aboveSubview: tabBarController!.view)
//        
//        if let childView = pageViewController.view {
//            childView.translatesAutoresizingMaskIntoConstraints = false
//            childView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//            childView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//            childView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//            childView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        }
//        
//        pageViewController.didMove(toParent: self)
    }
    
    private func addNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Трекеры"
    }
    
    private func addButton() {
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(buttonTapped))
        
        barButton.tintColor = UIColor(named: "YP_Black")
        
        navigationItem.leftBarButtonItem = barButton
    }
    
    private func addDatePicker() {
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
    
    @objc private func buttonTapped() {
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
        let currentCategory = categories[section]
        
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
        
        view.titleLabel.text = categories[indexPath.section].title
        view.titleLabel.text = categories[indexPath.section].title
        
        return view
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
    func updateCollectionViewSection(newCategories: [TrackerCategory], section: Int, pickedWeekdays: [String]) {
        self.categories = newCategories
        if self.collectionView.numberOfSections != 0 && (pickedWeekdays.contains(String(self.pickedWeekday)) || pickedWeekdays.contains(currentDate)) {
            self.collectionView.reloadSections(IndexSet(integer: section))
        } else if pickedWeekdays.contains(String(self.pickedWeekday)) || pickedWeekdays.contains(currentDate) {
            self.collectionView.insertSections(IndexSet(integer: section))
        }
    }
    
    func updateCollectionView() {
        categories = dataProvider.trackerCategories
        collectionView.reloadData()
    }
    
    func getCategories() -> [TrackerCategory] {
        return self.categories
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
