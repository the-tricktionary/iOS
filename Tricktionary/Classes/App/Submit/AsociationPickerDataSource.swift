//
//  AsociationPickerDataSource.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 06/04/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

extension SubmitViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return viewModel.organisations.count
        }
        return viewModel.types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return viewModel.organisations[row]
        }
        return viewModel.types[row]
    }
}
