import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func setNewScheduleWeekdays(pickedWeekdays: [String])
}

protocol CategoriesViewModelDelegate: AnyObject {
    func setTrackerCategory(categoryName: String)
}

class NewTrackerViewController: UIViewController {
    var cellType: String
    
    private let scrollView = UIScrollView()
    let viewTitleLabel = UILabel()
    let trackerNameTextField = PaddedTextField()
    private let navigationalTableView = UITableView()
    private let emojiHeaderLabel = UILabel()
    let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let colorHeaderLabel = UILabel()
    let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let cancelButton = UIButton()
    let createButton = UIButton()
    private let cancelCreateButtonsStackView = UIStackView()
    
    private let tableViewOptions = ["Категория", "Расписание"]
    var trackerCategory: String?
    var scheduledWeekdays = ["2", "3", "4", "5", "6", "7", "1"]
    var pickedEmoji: String?
    var pickedColor: String?
   
    let emoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
   
    let colorNames: [String] = ["YP_Red (Color palette)", "YP_Orange (Color palette)", "YP_Blue (Color palette)", "YP_Purple (Color palette)", "YP_Green (Color palette)", "YP_Pink (Color palette)", "YP_PaleBiege (Color palette)", "YP_Cyan (Color palette)", "YP_SaladGreen (Color palette)", "YP_DarkBlue (Color palette)", "YP_DarkOrange (Color palette)", "YP_SoftPink (Color palette)", "YP_Biege (Color palette)", "YP_PaleBlue (Color palette)", "YP_DarkPurple (Color palette)", "YP_DeepPurple (Color palette)", "YP_PalePurple (Color palette)", "YP_BrightGreen (Color palette)"]
    
    weak var newTrackerViewControllerDelegate: NewTrackerViewControllerDelegate?
    
    let dataProvider = DataProvider.shared
    
    var trackerNameTextFieldConstraint: NSLayoutConstraint!
    
    init(cellType: String, newTrackerViewControllerDelegate: NewTrackerViewControllerDelegate? = nil) {
        self.cellType = cellType
        self.newTrackerViewControllerDelegate = newTrackerViewControllerDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - UI Configuration
    
    private func setupUI() {
        view.backgroundColor = .white
        
        configureScrollView()
        configureViewTitleLabel()
        configureTrackerNameTextField()
        configureNavigationalTableView()
        configureEmojiHeaderLabel()
        configureEmojiCollectionView()
        configureColorHeaderLabel()
        configureColorCollectionView()
        configureCancelCreateButtonsStackView()
    }
    
    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureViewTitleLabel() {
        viewTitleLabel.text = cellType == "habitCell" ? "Новая привычка" : "Новое нерегулярное событие"
        viewTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(viewTitleLabel)
        
        NSLayoutConstraint.activate([
            viewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 27)
        ])
    }
    
    private func configureTrackerNameTextField() {
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
        scrollView.addSubview(trackerNameTextField)
        
        trackerNameTextFieldConstraint = trackerNameTextField.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 38)
        trackerNameTextFieldConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureNavigationalTableView() {
        navigationalTableView.dataSource = self
        navigationalTableView.delegate = self
        
        navigationalTableView.register(TrackerTypeCell.self, forCellReuseIdentifier: "optionsCell")
        
        navigationalTableView.layer.cornerRadius = 16
        navigationalTableView.layer.masksToBounds = true
        navigationalTableView.isScrollEnabled = false
        navigationalTableView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(navigationalTableView)
        
        NSLayoutConstraint.activate([
            navigationalTableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            navigationalTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            navigationalTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        if cellType == "habitCell" {
            navigationalTableView.bottomAnchor.constraint(equalTo: navigationalTableView.topAnchor, constant: 150).isActive = true
        } else if cellType == "irregularEventCell" {
            navigationalTableView.bottomAnchor.constraint(equalTo: navigationalTableView.topAnchor, constant: 75).isActive = true
        }
    }
    
    private func configureEmojiHeaderLabel() {
        emojiHeaderLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        emojiHeaderLabel.text = "Emoji"
        emojiHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(emojiHeaderLabel)
        
        NSLayoutConstraint.activate([
            emojiHeaderLabel.topAnchor.constraint(equalTo: navigationalTableView.bottomAnchor, constant: 32),
            emojiHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28)
        ])
    }
    
    private func configureEmojiCollectionView() {
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        
        emojiCollectionView.allowsSelection = true
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(emojiCollectionView)
        
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: emojiHeaderLabel.bottomAnchor, constant: 24),
            emojiCollectionView.bottomAnchor.constraint(equalTo: emojiCollectionView.topAnchor, constant: 204),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
        ])
    }
    
    private func configureColorHeaderLabel() {
        colorHeaderLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        colorHeaderLabel.text = "Цвет"
        colorHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(colorHeaderLabel)
        
        NSLayoutConstraint.activate([
            colorHeaderLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28)
        ])
    }
    
    private func configureColorCollectionView() {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(colorCollectionView)
        
        NSLayoutConstraint.activate([
            colorCollectionView.topAnchor.constraint(equalTo: colorHeaderLabel.bottomAnchor, constant: 24),
            colorCollectionView.bottomAnchor.constraint(equalTo: colorCollectionView.topAnchor, constant: 204),
            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
        ])
    }
    
    private func configureCancelCreateButtonsStackView() {
        cancelCreateButtonsStackView.spacing = 8
        cancelCreateButtonsStackView.axis = .horizontal
        cancelCreateButtonsStackView.distribution = .fillEqually
        cancelCreateButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cancelCreateButtonsStackView)
        
        NSLayoutConstraint.activate([
            cancelCreateButtonsStackView.heightAnchor.constraint(equalToConstant: 60),
            cancelCreateButtonsStackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            cancelCreateButtonsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
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
    
    @objc func cancelButtonTapped() {
        newTrackerViewControllerDelegate?.dismiss()
    }
    
    @objc func createButtonTapped() {
        guard let trackerName = trackerNameTextField.text else {
            print("[NewTrackerViewCell] - createButtonTapped: Unable to get text from trackerNameTextField.")
            return
        }
        
        guard let trackerCategory else {
            print("[NewTrackerViewCell] - createButtonTapped: No category was chosen.")
            return
        }
        
        guard let pickedEmoji else {
            print("[NewTrackerViewCell] - createButtonTapped: No emoji was chosen.")
            return
        }
        
        guard let pickedColor else {
            print("[NewTrackerViewCell] - createButtonTapped: No color was chosen.")
            return
        }
        
        let schedule = cellType == "habitCell" ? scheduledWeekdays : [DateFormatter.trackerDateFormatter.string(from: Date())]
        
        addNewTrackerToCoreData(trackerName: trackerName, trackerCategory: trackerCategory, trackerEmoji: pickedEmoji, trackerColor: pickedColor, scheduledWeekdays: schedule)
    }
    
    //MARK: - Core Data
    
    private func updateCollectionViewSectionCoreData() {
        newTrackerViewControllerDelegate?.updateCollectionView()
        newTrackerViewControllerDelegate?.dismiss()
    }
    
    private func addNewTrackerToCoreData(trackerName: String, trackerCategory: String, trackerEmoji: String, trackerColor: String, scheduledWeekdays: [String]) {
        if dataProvider.trackerCategories.contains(where: { $0.title == trackerCategory }) {
            guard let category = dataProvider.trackerCategoriesStore.getCategory(by: trackerCategory) else {
                print("[NewHabitViewController] - addNewTrackerToCoreData: No category with such title.")
                return
            }
            
            dataProvider.trackersStore.addNewTracker(name: trackerName, category: category, emoji: trackerEmoji, color: trackerColor, schedule: scheduledWeekdays)
            updateCollectionViewSectionCoreData()
        } else {
            guard let category = dataProvider.trackerCategoriesStore.addNewCategory(title: trackerCategory) else {
                print("[NewHabitViewController] - addNewTrackerToCoreData: Error adding a category.")
                return
            }
            
            dataProvider.trackersStore.addNewTracker(name: trackerName, category: category, emoji: trackerEmoji, color: trackerColor, schedule: scheduledWeekdays)
            updateCollectionViewSectionCoreData()
            
            return
        }
    }
}

extension NewTrackerViewController: UITextFieldDelegate {
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

extension NewTrackerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = cellType == "habitCell" ? 2 : 1
        
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
            let viewModel = CategoriesViewModel(delegate: self)
            viewModel.selectedCategory = trackerCategory
            let categoriesViewController = CategoriesViewController(viewModel: viewModel)
            present(categoriesViewController, animated: true)
        } else if tableViewOptions[indexPath.row] == "Расписание" {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.scheduleViewControllerDelegate = self
            if scheduledWeekdays != ["2", "3", "4", "5", "6", "7", "1"] {
                scheduleViewController.pickedWeekdays = scheduledWeekdays.map( { Int($0)! } )
            }
            present(scheduleViewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewTrackerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func setNewScheduleWeekdays(pickedWeekdays: [String]) {
        scheduledWeekdays = pickedWeekdays
    }
}

extension NewTrackerViewController: CategoriesViewModelDelegate {
    func setTrackerCategory(categoryName: String) {
        trackerCategory = categoryName
    }
}
