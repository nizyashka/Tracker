//
//  SecondOnboardingViewController.swift
//  Tracker
//
//  Created by Алексей Непряхин on 04.07.2025.
//

import UIKit

final class SecondOnboardingViewController: FirstOnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "OnboardingScreen_2") else {
            print("No image.")
            return
        }
        
        imageView.image = image
        label.text = "Даже если это не литры воды и йога"
    }
}
