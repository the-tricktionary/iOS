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

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Video settings"
        case 1:
            return "Tricktionary settings"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = SwitchCell()
                cell.textLabel?.text = "Automatic full screen"
                cell.switchButton.setOn(vm.fullscreen, animated: true)
                cell.onSwitch = { [weak self] isOn in
                    self?.vm.fullscreen = isOn
                }
                return cell
            case 1:
                let cell = SwitchCell()
                cell.textLabel?.text = "Auto-Play videos"
                cell.switchButton.setOn(vm.auto, animated: true)
                cell.onSwitch = { [weak self] isOn in
                    self?.vm.auto = isOn
                }
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            switch indexPath.row {
            case 0:
                let cell = SwitchCell()
                cell.textLabel?.text = "Show IJRU levels on trick list"
                cell.switchButton.setOn(vm.showIjru, animated: true)
                cell.onSwitch = { [weak self] isOn in
                    self?.vm.showIjru = isOn
                }
                return cell
            case 1:
                let cell = SwitchCell()
                cell.textLabel?.text = "Show IRSF levels on trick list"
                cell.switchButton.setOn(vm.showIrsf, animated: true)
                cell.onSwitch = { [weak self] isOn in
                    self?.vm.showIrsf = isOn
                }
                return cell
            case 2:
                let cell = SwitchCell()
                cell.textLabel?.text = "Show WJR levels on trick list"
                cell.switchButton.setOn(vm.showWjr, animated: true)
                cell.onSwitch = { [weak self] isOn in
                    self?.vm.showWjr = isOn
                }
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
}

@propertyWrapper
struct Persistent<Value> {
    private var key: String
    private let defaultValue: Value

    init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    var wrappedValue: Value {
        get {
            return (UserDefaults.standard.object(forKey: key) ?? defaultValue) as! Value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
