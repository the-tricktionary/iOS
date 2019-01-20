//
//  Picker.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 19/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class Picker: UIView {
    
    // MARK: Variables
    
    fileprivate let textField: UITextField = UITextField()
    fileprivate let picker: UIPickerView = UIPickerView()
    fileprivate let toolbar: UIToolbar = UIToolbar()
    
    // MARK: Life cycles
    
    init() {
        super.init(frame: .zero)
        
        setupSubviews()
//        setupViewConstraints()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Privates
    
    fileprivate func setupSubviews() {
        addSubview(textField)
    }
    
    fileprivate func setup() {
        backgroundColor = UIColor.white
        
        layer.borderWidth = 0
    }
    
}
