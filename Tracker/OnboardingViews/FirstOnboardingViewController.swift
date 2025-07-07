//
//  FirstOnboardingViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 04.07.2025.
//

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func dismiss() -> Void
}

class FirstOnboardingViewController: UIViewController {
    let imageView = UIImageView()
    let label = UILabel()
    let button = UIButton()
    
    var onBoardingViewControllerDelegate: OnboardingViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        addImageView()
        addButton()
        addLabel()
    }
    
    func addImageView() {
        guard let image = UIImage(named: "OnboardingScreen_1") else {
            print("No image.")
            return
        }
        
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func addLabel() {
        label.text = "Отслеживайте только то, что хотите"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -160),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func addButton() {
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
//            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 160),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func buttonTapped() {
        onBoardingViewControllerDelegate?.dismiss()
    }
}
