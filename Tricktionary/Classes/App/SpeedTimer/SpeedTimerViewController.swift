//
//  SpeedTimerViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 17/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import AVFoundation

class SpeedTimerViewController: BaseCenterViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.events.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.events[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        customSecondTextField.isHidden = !(row == 4)
    }
    // MARK: Variables
    
    fileprivate let eventPicker = UIPickerView()
    private let customSecondTextField = UITextField()
    
    var viewModel: SpeedTimerViewModel
    
    init(viewModel: SpeedTimerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(eventPicker)
        view.addSubview(customSecondTextField)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Speed Timer"
        view.backgroundColor = UIColor.white
        
        eventPicker.delegate = self
        eventPicker.dataSource = self
        
        customSecondTextField.isHidden = true
        customSecondTextField.placeholder = "Enter time in seconds"
        customSecondTextField.keyboardType = .numberPad
        customSecondTextField.layer.borderWidth = 1
        customSecondTextField.layer.cornerRadius = 5
        customSecondTextField.layer.borderColor = UIColor.gray.cgColor
        
        setupViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        
        customSecondTextField.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalTo(view).inset(40)
            make.height.equalTo(40)
        }
        
        let height = view.frame.height / 2.5
        eventPicker.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(customSecondTextField.snp.bottom)
            make.height.equalTo(height)
        }
    }
    
    
    // TODO: This is string component!
    fileprivate func timeFormatted(_ totalSeconds: Int, _ miliseconds: Int?) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        if let miliseconds = miliseconds {
            return String(format: "%02d:%02d:%02d", minutes, seconds, miliseconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
