//
//  SpeedTimerDelegate.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 14/01/2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//
import UIKit

extension SpeedTimerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SpeedEventCell else {
            return
        }
        // TODO: Observe selected event - start event VC/view .... 
    }
}
