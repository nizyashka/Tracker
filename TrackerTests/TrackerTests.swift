//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Алексей Непряхин on 20.07.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testViewControllerLightTheme() {
        let firstNavigationController = UINavigationController(rootViewController: TrackersViewController())
        firstNavigationController.navigationBar.backgroundColor = .ypBackground
        firstNavigationController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "TrackersTabBarImage"), tag: 0)
        
        let secondNavigationController = UINavigationController(rootViewController: StatisticsViewController())
        secondNavigationController.navigationBar.backgroundColor = .ypBackground
        secondNavigationController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "StatisticsTabBarImage"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .ypBackground
        tabBarController.viewControllers = [firstNavigationController, secondNavigationController]
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        assertSnapshot(matching: tabBarController, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testViewControllerDarkTheme() {
        let firstNavigationController = UINavigationController(rootViewController: TrackersViewController())
        firstNavigationController.navigationBar.backgroundColor = .ypBackground
        firstNavigationController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "TrackersTabBarImage"), tag: 0)
        
        let secondNavigationController = UINavigationController(rootViewController: StatisticsViewController())
        secondNavigationController.navigationBar.backgroundColor = .ypBackground
        secondNavigationController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "StatisticsTabBarImage"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .ypBackground
        tabBarController.viewControllers = [firstNavigationController, secondNavigationController]
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        assertSnapshot(matching: tabBarController, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
