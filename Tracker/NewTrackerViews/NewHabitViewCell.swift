//
//  NewTrackerViewCell.swift
//  Tracker
//
//  Created by Алексей Непряхин on 16.06.2025.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func setNewScheduleWeekdays(pickedWeekdays: [String])
}

class NewHabitViewCell: UITableViewCell {
    let viewTitleLabel = UILabel()
    private let trackerNameTextField = PaddedTextField()
    let navigationalTableView = UITableView()
    private let emojiHeaderLabel = UILabel()
    private let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let colorHeaderLabel = UILabel()
    private let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    private let cancelCreateButtonsStackView = UIStackView()
    
    weak var newTrackerViewCellDelegate: NewTrackerViewCellDelegate?
    
    private let tableViewOptions = ["Категория", "Расписание"]
    private var scheduledWeekdays = ["2", "3", "4", "5", "6", "7", "1"]
    private let emoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                         "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                         "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
//    private let colors: [UIColor] = [.ypRedColorPalette, .ypOrangeColorPalette, .ypBlueColorPalette, .ypPurpleColorPalette, .ypGreenColorPalette, .ypPinkColorPalette, .ypPaleBiegeColorPalette, .ypCyanColorPalette, .ypSaladGreenColorPalette, .ypDarkBlueColorPalette, .ypDarkOrangeColorPalette, .ypSoftPinkColorPalette, .ypBiegeColorPalette, .ypPaleBlueColorPalette, .ypDarkPurpleColorPalette, .ypDeepPurpleColorPalette, .ypPalePurpleColorPalette, .ypBrightGreenColorPalette]
    
    private let colorNames: [String] = ["YP_Red (Color palette)", "YP_Orange (Color palette)", "YP_Blue (Color palette)", "YP_Purple (Color palette)", "YP_Green (Color palette)", "YP_Pink (Color palette)", "YP_PaleBiege (Color palette)", "YP_Cyan (Color palette)", "YP_SaladGreen (Color palette)", "YP_DarkBlue (Color palette)", "YP_DarkOrange (Color palette)", "YP_SoftPink (Color palette)", "YP_Biege (Color palette)", "YP_PaleBlue (Color palette)", "YP_DarkPurple (Color palette)", "YP_DeepPurple (Color palette)", "YP_PalePurple (Color palette)", "YP_BrightGreen (Color palette)"]
    
    private var pickedCategory = ""
    private var pickedEmoji = ""
    private var pickedColor = ""
    
    let dataProvider = DataProvider.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        
        addViewTitleLabel()
        addTrackerNameTextField()
        configureTableView()
        registerCell()
        addEmojiHeaderLabel()
        configureEmojiCollectionView()
        registerCollectionViewCell()
        configureColorHeaderLabel()
        configureColorCollectionView()
        registerColorCell()
        addCancelCreateButtonsStackView()
    }
    
    private func addViewTitleLabel() {
        viewTitleLabel.text = "Новая привычка"
        viewTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewTitleLabel)
        
        NSLayoutConstraint.activate([
            viewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            viewTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            viewTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27)
        ])
    }
    
    private func addTrackerNameTextField() {
        trackerNameTextField.delegate = self
        guard let trackerNameTextFieldDelegate = trackerNameTextField.delegate else {
            print("[NewHabitViewController]: addTrackerNameTextField - No delegate found.")
            return
        }
        
        trackerNameTextFieldDelegate.textFieldDidEndEditing?(trackerNameTextField)
        trackerNameTextFieldDelegate.textFieldDidChangeSelection?(trackerNameTextField)
        trackerNameTextField.becomeFirstResponder()
        trackerNameTextField.returnKeyType = UIReturnKeyType.done
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.backgroundColor = .ypGray30
        trackerNameTextField.font = UIFont.systemFont(ofSize: 17)
        trackerNameTextField.layer.cornerRadius = 16
        trackerNameTextField.layer.masksToBounds = true
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trackerNameTextField)
        
        NSLayoutConstraint.activate([
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameTextField.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 38),
            trackerNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureTableView() {
        navigationalTableView.dataSource = self
        navigationalTableView.delegate = self
        
        navigationalTableView.layer.cornerRadius = 16
        navigationalTableView.layer.masksToBounds = true
        navigationalTableView.isScrollEnabled = false
        navigationalTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(navigationalTableView)
        
        NSLayoutConstraint.activate([
            navigationalTableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            navigationalTableView.bottomAnchor.constraint(equalTo: navigationalTableView.topAnchor, constant: 150),
            navigationalTableView.leadingAnchor.constraint(equalTo: trackerNameTextField.leadingAnchor),
            navigationalTableView.trailingAnchor.constraint(equalTo: trackerNameTextField.trailingAnchor)
        ])
    }
    
    private func registerCell() {
        navigationalTableView.register(TrackerTypeCell.self, forCellReuseIdentifier: "optionsCell")
    }
    
    private func addEmojiHeaderLabel() {
        emojiHeaderLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        emojiHeaderLabel.text = "Emoji"
        emojiHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiHeaderLabel)
        
        NSLayoutConstraint.activate([
            emojiHeaderLabel.topAnchor.constraint(equalTo: navigationalTableView.bottomAnchor, constant: 32),
            emojiHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28)
        ])
    }
    
    private func configureEmojiCollectionView() {
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiCollectionView)
        
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: emojiHeaderLabel.bottomAnchor, constant: 24),
            emojiCollectionView.bottomAnchor.constraint(equalTo: emojiCollectionView.topAnchor, constant: 204),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18)
        ])
    }
    
    private func registerCollectionViewCell() {
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
    }
    
    private func configureColorHeaderLabel() {
        colorHeaderLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        colorHeaderLabel.text = "Цвет"
        colorHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorHeaderLabel)
        
        NSLayoutConstraint.activate([
            colorHeaderLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28)
        ])
    }
    
    private func configureColorCollectionView() {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorCollectionView)
        
        NSLayoutConstraint.activate([
            colorCollectionView.topAnchor.constraint(equalTo: colorHeaderLabel.bottomAnchor, constant: 24),
            colorCollectionView.bottomAnchor.constraint(equalTo: colorCollectionView.topAnchor, constant: 204),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18)
        ])
    }
    
    private func registerColorCell() {
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
    }
    
    private func addCancelCreateButtonsStackView() {
        cancelCreateButtonsStackView.spacing = 8
        cancelCreateButtonsStackView.axis = .horizontal
        cancelCreateButtonsStackView.distribution = .fillEqually
        cancelCreateButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cancelCreateButtonsStackView)
        
        NSLayoutConstraint.activate([
            cancelCreateButtonsStackView.heightAnchor.constraint(equalToConstant: 60),
            cancelCreateButtonsStackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            cancelCreateButtonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cancelCreateButtonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelCreateButtonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
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
        newTrackerViewCellDelegate?.cancel()
    }
    
    @objc private func createButtonTapped() {
        guard let trackerName = trackerNameTextField.text else {
            print("[NewTrackerViewCell] - createButtonTapped: Unable to get text from trackerNameTextField.")
            return
        }
        
        let schedule = newTrackerViewCellDelegate?.cellType == "newHabitCell" ? scheduledWeekdays : [DateFormatter.trackerDateFormatter.string(from: Date())]
        
        newTrackerViewCellDelegate?.addNewTrackerToCoreData(trackerName: trackerName, trackerCategory: "Категория 1", trackerEmoji: pickedEmoji, trackerColor: pickedColor, scheduledWeekdays: schedule)
    }
}

extension NewHabitViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = newTrackerViewCellDelegate?.cellType == "newHabitCell" ? 2 : 1
        
        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell", for: indexPath) as? TrackerTypeCell else {
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
            newTrackerViewCellDelegate?.present(scheduleViewController)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewHabitViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.hasText {
            createButton.backgroundColor = .ypBlack
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .ypGrayDisabledButton
            createButton.isEnabled = false
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
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

extension NewHabitViewCell: ScheduleViewControllerDelegate {
    func setNewScheduleWeekdays(pickedWeekdays: [String]) {
        scheduledWeekdays = pickedWeekdays
    }
}

extension NewHabitViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emoji.count
        } else if collectionView == colorCollectionView {
            return colorNames.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCell else {
                print("[NewTrackerViewCell] - collectionView: Unable to dequeue a cell.")
                return UICollectionViewCell()
            }
            
            cell.emojiLabel.text = emoji[indexPath.row]
            
            return cell
        } else if collectionView == colorCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCell else {
                print("[NewTrackerViewCell] - collectionView: Unable to dequeue a cell.")
                return UICollectionViewCell()
            }
            
            cell.roundedColorRect.backgroundColor = UIColor(named: colorNames[indexPath.row])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else {
                print("[NewTrackerViewCell] - collectionView: Could not find a cell at this indexPath")
                return
            }
            
            guard let emoji = cell.emojiLabel.text else {
                print("[NewTrackerViewCell] - collectionView: Could not get emoji from label.")
                return
            }
            
            cell.layer.cornerRadius = 12
            cell.layer.masksToBounds = true
            
            cell.backgroundColor = .lightGray.withAlphaComponent(0.3)
            
            pickedEmoji = emoji
        } else if collectionView == colorCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell,
            let color = UIColor(named: colorNames[indexPath.row]) else {
                print("[NewTrackerViewCell] - collectionView: Could not find a cell at this indexPath")
                return
            }
            
            cell.layer.cornerRadius = 12
            cell.layer.masksToBounds = true
            
            cell.layer.borderWidth = 3
            cell.layer.borderColor = color.withAlphaComponent(0.4).cgColor
            
            pickedColor = colorNames[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            print("[NewTrackerViewCell] - collectionView: Could not find a cell at this indexPath")
            return
        }
        
        if collectionView == emojiCollectionView {
            cell.backgroundColor = .white
        } else if collectionView == colorCollectionView {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = .none
        }
    }
}
