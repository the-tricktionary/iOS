//
//  EventPicker.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class EventPicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var viewModel: SpeedTimerViewModel!
    var viewController: SpeedTimerViewController!
    
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
        viewController.controllView.eventType.text = viewModel.events[row]
    }
}
