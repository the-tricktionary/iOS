//
//  GradientButton.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 15/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class GradientButton: UIButton {
    
    // MARK: Life cycles
    
    required init() {
        super.init(frame: .zero)
        backgroundColor = Color.bar // TODO: Gradient
        setTitleStyle()
        setBorderStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Privates
    
    fileprivate func setTitleStyle() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
    }
    
    fileprivate func setBorderStyle() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
    }
    
}
