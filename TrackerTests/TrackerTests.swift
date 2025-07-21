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
        let statisticsViewController = StatisticsViewController()
        let trackersViewController = TrackersViewController()
        trackersViewController.statisticsViewControllerDelegate = statisticsViewController
        
        let firstNavigationController = UINavigationController(rootViewController: trackersViewController)
        firstNavigationController.navigationBar.backgroundColor = .ypBackground
        firstNavigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("trackers", comment: "Trackers tab bar"), image: UIImage(named: "TrackersTabBarImage"), tag: 0)
        
        let secondNavigationController = UINavigationController(rootViewController: statisticsViewController)
        secondNavigationController.navigationBar.backgroundColor = .ypBackground
        secondNavigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("statistics", comment: "Statistics tab bar"), image: UIImage(named: "StatisticsTabBarImage"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .ypBackground
        tabBarController.viewControllers = [firstNavigationController, secondNavigationController]
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        assertSnapshot(matching: tabBarController, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testViewControllerDarkTheme() {
        let statisticsViewController = StatisticsViewController()
        let trackersViewController = TrackersViewController()
        trackersViewController.statisticsViewControllerDelegate = statisticsViewController
        
        let firstNavigationController = UINavigationController(rootViewController: trackersViewController)
        firstNavigationController.navigationBar.backgroundColor = .ypBackground
        firstNavigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("trackers", comment: "Trackers tab bar"), image: UIImage(named: "TrackersTabBarImage"), tag: 0)
        
        let secondNavigationController = UINavigationController(rootViewController: statisticsViewController)
        secondNavigationController.navigationBar.backgroundColor = .ypBackground
        secondNavigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("statistics", comment: "Statistics tab bar"), image: UIImage(named: "StatisticsTabBarImage"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .ypBackground
        tabBarController.viewControllers = [firstNavigationController, secondNavigationController]
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        assertSnapshot(matching: tabBarController, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
