//
//  SettingsDataSource.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 25/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

class SettingsDataSource: NSObject, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell()
                cell.textLabel?.text = "Video settings"
                cell.backgroundColor = Color.backgroundHeader
                return cell
            case 1:
                let cell = SwitchCell()
                cell.title.text = "Automatic full screen"
                cell.switchButton.setOn(!(UserDefaults.standard.value(forKey: PxSettings.fullscreen) as! Bool), animated: true)
                cell.switchButton.addTarget(self, action: #selector(fullScreen), for: .touchUpInside)
                return cell
            case 2:
                let cell = SwitchCell()
                cell.title.text = "Auto-Play Videos"
                cell.switchButton.setOn(UserDefaults.standard.value(forKey: PxSettings.autoplay) as! Bool, animated: true)
                cell.switchButton.addTarget(self, action: #selector(autoPlay), for: .touchUpInside)
                return cell
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    // MARK: User action
    
    @objc func fullScreen() {
        var state = UserDefaults.standard.value(forKey: PxSettings.fullscreen) as! Int
        if state == 0 {
            state = 1
        } else {
            state = 0
        }
        UserDefaults.standard.set(state, forKey: PxSettings.fullscreen)
        UserDefaults.standard.synchronize()
    }
    
    @objc func autoPlay() {
        var state = UserDefaults.standard.value(forKey: PxSettings.autoplay) as! Int
        if state == 0 {
            state = 1
        } else {
            state = 0
        }
        UserDefaults.standard.set(state, forKey: PxSettings.autoplay)
        UserDefaults.standard.synchronize()
    }
}
