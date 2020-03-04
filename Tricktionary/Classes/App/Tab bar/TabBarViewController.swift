//
//  TabBarViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 11/05/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseRemoteConfig

class Settings {
    @Persistent(key: PxSettings.ijruLevels, defaultValue: false)
    var showIjru: Bool

    @Persistent(key: PxSettings.irsfLevels, defaultValue: false)
    var showIrsf: Bool

    @Persistent(key: PxSettings.wjrLevels, defaultValue: false)
    var showWjr: Bool

    @Persistent(key: PxSettings.autoplay, defaultValue: false)
    var autoPlay: Bool

    @Persistent(key: PxSettings.fullscreen, defaultValue: false)
    var fullscreen: Bool
}

extension Settings: TricksListSettingsType {}
extension Settings: TrickDetailSettingsType {}


class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        tabBar.isTranslucent = false

        let tricksVM = TricksViewModel(dataProvider: TrickManager.shared,
                                       remoteConfig: RemoteConfig.remoteConfig(),
                                       settings: Settings(),
                                       auth: Auth.auth())
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
