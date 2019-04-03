//
//  SubmitFormView.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 03/04/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SubmitFormView: UIView {
    
    // MARK: Variables
    
    let trickNameTextField: UITextField = UITextField()
    let trickDescriptionTextField: UITextField = UITextField()
    let levelTextField: UITextField = UITextField()
    
    // MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setup()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Privates
    
    fileprivate func setupSubviews() {
        addSubview(trickNameTextField)
        addSubview(trickDescriptionTextField)
        addSubview(levelTextField)
    }
    
    fileprivate func setup() {
        trickNameTextField.placeholder = "Trick name"
        trickNameTextField.delegate = self
        
        trickDescriptionTextField.placeholder = "Description (can add your insta name)"
        trickDescriptionTextField.delegate = self
        
        levelTextField.placeholder = "Level"
        levelTextField.delegate = self
        
    }
    
    fileprivate func setupViewConstraints() {
        
        let height = ((UIScreen.main.bounds.size.height - 200) / 2) / 3
        
        trickNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(height)
        }
        
        trickDescriptionTextField.snp.makeConstraints { (make) in
            make.top.equalTo(trickNameTextField.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(height)
        }
        
        levelTextField.snp.makeConstraints { (make) in
            make.top.equalTo(trickDescriptionTextField.snp.bottom)
            make.leading.equalTo(self)
            make.width.equalTo(UIScreen.main.bounds.size.width / 2)
            make.height.equalTo(height)
        }
    }
}

// Exntension text field delegate

extension SubmitFormView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}
