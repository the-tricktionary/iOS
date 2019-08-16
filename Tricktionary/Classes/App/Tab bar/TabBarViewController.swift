//
//  TabBarViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 11/05/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import MMDrawerController

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        tabBar.tintColor = Color.bar
        tabBar.barTintColor = Color.background
        tabBar.isTranslucent = false

        let tricksVM = TricksViewModel(dataProvider: TrickManager.shared)
        let trVC = TricksViewController(viewModel: tricksVM)
        let tricksViewController = UINavigationController(rootViewController: trVC)
        tricksViewController.tabBarItem = UITabBarItem(title: "Tricks", image: UIImage(named: "tricktionary"), tag: 0)

        let speedsVM = SpeedTimerViewModel()
        let alarmController = UINavigationController(rootViewController: SpeedTimerViewController(viewModel: speedsVM))
        alarmController.tabBarItem = UITabBarItem(title: "Speed", image: UIImage(named: "timer"), tag: 1)
        
        let speedDataVM = SpeedDataViewModel()
        let speedDataVC = UINavigationController(rootViewController: SpeedDataViewController(viewModel: speedDataVM))
        speedDataVC.tabBarItem = UITabBarItem(title: "Speed data", image: UIImage(named: "data"), tag: 2)

        let submitVM = SubmitViewModel()
        let informationController = UINavigationController(rootViewController: SubmitViewController(viewModel: submitVM))
        informationController.tabBarItem = UITabBarItem(title: "Submit", image: #imageLiteral(resourceName: "submit"), tag: 3)

        let settingsController = UINavigationController(rootViewController: SettingsViewController())
        settingsController.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "settings"), tag: 4)

        let controllers: [UIViewController] = [tricksViewController, alarmController, speedDataVC, informationController,
                                               settingsController]

        viewControllers = controllers
    }
}
