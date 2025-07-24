//
//  CategoriesView.swift
//  Tracker
//
//  Created by Алексей Непряхин on 07.07.2025.
//

import UIKit

final class CategoriesViewController: UIViewController {
    let viewTitleLabel = UILabel()
    let newCategoryButton = UIButton()
    let categoriesTableView = UITableView()
    
    let viewModel: CategoriesViewModel?
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        bind()
        configureViewTitleLabel()
        configureNewCategoryButton()
        configureCategoriesTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.selectCategory(tableView: categoriesTableView)
    }
    
    private func configureViewTitleLabel() {
        viewTitleLabel.text = "Категория"
        viewTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewTitleLabel)
        
        NSLayoutConstraint.activate([
            viewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    private func configureNewCategoryButton() {
        newCategoryButton.setTitle("Добавить категорию", for: .normal)
        newCategoryButton.backgroundColor = .ypBlack
        newCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        newCategoryButton.layer.cornerRadius = 16
        newCategoryButton.layer.masksToBounds = true
        newCategoryButton.addTarget(self, action: #selector(newCategoryButtonTapped), for: .touchUpInside)
        newCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newCategoryButton)
        
        NSLayoutConstraint.activate([
            newCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            newCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            newCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func newCategoryButtonTapped() {
        guard let viewModel = viewModel else {
            print("[CategoriesViewController] - newCategoryButtonTapped: No viewModel found.")
            return
        }
        
        let newCategoryViewController = NewCategoryViewController(viewModel: viewModel)
        present(newCategoryViewController, animated: true)
    }
    
    private func configureCategoriesTableView() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        
        categoriesTableView.register(CategoryCell.self, forCellReuseIdentifier: "categoryCell")
        
        categoriesTableView.allowsMultipleSelection = false
        categoriesTableView.separatorInset = UIEdgeInsets(top: 1, left: 16, bottom: 0, right: 16)
        categoriesTableView.layer.cornerRadius = 16
        categoriesTableView.layer.masksToBounds = true
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoriesTableView)
        
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 24),
            categoriesTableView.bottomAnchor.constraint(equalTo: newCategoryButton.topAnchor, constant: -16),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func bind() {
        viewModel?.categoryAdded = { [weak self] in
            self?.insertNewCategory()
        }
        
        viewModel?.tableView = { [weak self] tableView, indexPath in
            self?.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
    
    private func insertNewCategory() {
        categoriesTableView.reloadData()
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = viewModel?.trackerCategories?.count ?? 0
        
        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell,
              let categories = viewModel?.trackerCategories else {
            print("[CategoriesViewController] - tableView: Error dequeueing a cell or getting trackerCategories from viewModel.")
            return UITableViewCell()
        }
        
        cell.categoryNameLabel.text = categories[indexPath.row].title
        
        if indexPath.row == 0 && categories.count == 1 {
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.masksToBounds = true
        } else if indexPath.row == 0 && categories.count > 1 {
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == categories.count - 1 {
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.contentView.layer.cornerRadius = 0
            cell.contentView.layer.masksToBounds = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectCell(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
