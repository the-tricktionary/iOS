//
//  TabBarViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 11/05/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import FirebaseRemoteConfig

class Settings {
    @Persistent(key: PxSettings.levelsOnList, defaultValue: false)
    var showLevels: Bool
}

extension Settings: TricksListSettingsType {
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        tabBar.tintColor = UIColor.flatOrange()
        tabBar.unselectedItemTintColor = .white
        tabBar.barTintColor = UIColor.flatRed()
        tabBar.isTranslucent = false

        let tricksVM = TricksViewModel(dataProvider: TrickManager.shared,
                                       remoteConfig: RemoteConfig.remoteConfig(),
                                       settings: Settings())
        let tricksViewController = UINavigationController(rootViewController: TricksViewController(viewModel: tricksVM))
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

        let menuVC = SidePanelViewController()
        let settingsController = UINavigationController(rootViewController: menuVC)
        settingsController.tabBarItem = UITabBarItem(title: "More", image: #imageLiteral(resourceName: "settings"), tag: 4)

        let controllers: [UIViewController] = [tricksViewController, alarmController, speedDataVC, informationController,
                                               settingsController]

        viewControllers = controllers
    }
}
