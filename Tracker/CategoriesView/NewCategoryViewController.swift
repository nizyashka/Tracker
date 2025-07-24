//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 07.07.2025.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    private let viewTitleLabel = UILabel()
    private let categoryNameTextField = PaddedTextField()
    private let doneButton = UIButton()
    
    private let viewModel: CategoriesViewModel?
    
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
        
        configureViewTitleLabel()
        configureCategoryNameTextField()
        configureDoneButton()
    }
    
    private func configureViewTitleLabel() {
        viewTitleLabel.text = "Новая категория"
        viewTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewTitleLabel)
        
        NSLayoutConstraint.activate([
            viewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    private func configureCategoryNameTextField() {
        categoryNameTextField.delegate = self
        guard let categoryNameTextFieldDelegate = categoryNameTextField.delegate else {
            print("[NewCategoryViewController]: addCategoryNameTextField - No delegate found.")
            return
        }
        
        categoryNameTextFieldDelegate.textFieldDidEndEditing?(categoryNameTextField)
        categoryNameTextFieldDelegate.textFieldDidChangeSelection?(categoryNameTextField)
        categoryNameTextField.becomeFirstResponder()
        categoryNameTextField.returnKeyType = UIReturnKeyType.done
        categoryNameTextField.placeholder = "Введите название категории"
        categoryNameTextField.backgroundColor = .ypGray30
        categoryNameTextField.font = UIFont.systemFont(ofSize: 17)
        categoryNameTextField.layer.cornerRadius = 16
        categoryNameTextField.layer.masksToBounds = true
        categoryNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryNameTextField)
        
        NSLayoutConstraint.activate([
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            categoryNameTextField.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 38),
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureDoneButton() {
        doneButton.setTitle("Готово", for: .normal)
        doneButton.backgroundColor = .ypBlack
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        doneButton.layer.cornerRadius = 16
        doneButton.layer.masksToBounds = true
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func doneButtonTapped() {
        guard let categoryName = categoryNameTextField.text else {
            return
        }
        
        viewModel?.addCategory(categoryName: categoryName)
        dismiss(animated: true)
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.hasText {
            doneButton.backgroundColor = .ypBlack
            doneButton.isEnabled = true
        } else {
            doneButton.backgroundColor = .ypGrayDisabledButton
            doneButton.isEnabled = false
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.hasText {
            doneButton.backgroundColor = .ypBlack
            doneButton.isEnabled = true
        } else {
            doneButton.backgroundColor = .ypGrayDisabledButton
            doneButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
