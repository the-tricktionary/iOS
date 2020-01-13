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
            return 1
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
                cell.switchButton.setOn(fullscreen, animated: true)
                cell.switchButton.addTarget(self, action: #selector(fullScreen), for: .touchUpInside)
                return cell
            case 1:
                let cell = SwitchCell()
                cell.textLabel?.text = "Auto-Play videos"
                cell.switchButton.setOn(auto, animated: true)
                cell.switchButton.addTarget(self, action: #selector(autoPlay), for: .touchUpInside)
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            let cell = SwitchCell()
            cell.textLabel?.text = "Open prerequisites in new screen"
            cell.switchButton.setOn(UserDefaults.standard.value(forKey: PxSettings.newScreen) as! Bool, animated: true)
            cell.switchButton.addTarget(self, action: #selector(newScreen), for: .touchUpInside)
            return cell
            
        }
    }
    
    // MARK: User action
    
    @objc func fullScreen() {
        fullscreen.toggle()
    }
    
    @objc func autoPlay() {
        auto.toggle()
    }
    
    @objc func newScreen() {
        var state = UserDefaults.standard.value(forKey: PxSettings.newScreen) as! Int
        if state == 0 {
            state = 1
        } else {
            state = 0
        }
        UserDefaults.standard.set(state, forKey: PxSettings.newScreen)
        UserDefaults.standard.synchronize()
        
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
