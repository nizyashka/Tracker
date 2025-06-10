//
//  ViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 26.05.2025.
//

import UIKit

class TrackersViewController: UIViewController {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let noTrackersPlaceholderImageView = UIImageView()
    let noTrackersPlaceholderLabel = UILabel()
    
//    var categories: [TrackerCategory] = [TrackerCategory(title: "Категория 1", trackers: [(Tracker(id: UUID.init(),
//                                                                                                   name: "trackerName",
//                                                                                                   color: .black,
//                                                                                                   emoji: "trackerEmoji",
//                                                                                                   schedule: Date()))]), TrackerCategory(title: "Категория 2", trackers: [])]
    
    var categories: [TrackerCategory] = [TrackerCategory(title: "Категория 1", trackers: []), TrackerCategory(title: "Категория 2", trackers: [])]
    var completedTrackers: [TrackerRecord]?
    var currentDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationTitle()
        addButton()
        addDatePicker()
        showPlaceholder()
        addCollectionView()
        registerCellAndSupplementaryView()
    }
    
    func updateCollectionView(newCategories: [TrackerCategory], section: Int) {
        DispatchQueue.main.async {
            self.categories = newCategories
            self.collectionView.reloadData()
        }
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
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc func buttonTapped() {
        let trackerCreationViewController = TrackerCreationViewController()
        trackerCreationViewController.modalPresentationStyle = .pageSheet
        present(trackerCreationViewController, animated: true)
        
        //removePlaceholder()
//        trackerCreationViewController.modalPresentationStyle = .pageSheet
//        navigationController?.pushViewController(trackerCreationViewController, animated: true)
        
//        let navigationViewController = UINavigationController(rootViewController: trackerCreationViewController)
//        navigationViewController.modalPresentationStyle = .pageSheet
//        present(navigationViewController, animated: true)
    }
    
    private func addCollectionView() {
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
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
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
//        guard let numberOfSections = categories?.count else {
//            return 0
//        }
        
        let numberOfSections = categories.count
        
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trackersInSection = categories[section].trackers else {
            return 0
        }
        
        let numberOfItemsInSection = trackersInSection.count
        
        return numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
//        guard let trackers = categories[indexPath.section].trackers else {
//            return UICollectionViewCell()
//        }
        
        cell.trackerNameLabel.text = categories[indexPath.section].trackers?[indexPath.row].name
        print(cell.trackerNameLabel.text)
        cell.trackerEmojiSticker.text = categories[indexPath.section].trackers?[indexPath.row].emoji
        cell.trackerDayCounterLabel.text = "1 день"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
        
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

