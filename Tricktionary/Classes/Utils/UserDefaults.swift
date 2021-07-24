//
//  UserDefaults.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 24.07.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation

extension UserDefaults {
    @objc var token: String {
        get {
            return self.token
        }
        set {
            self.token = newValue
        }
    }
}
