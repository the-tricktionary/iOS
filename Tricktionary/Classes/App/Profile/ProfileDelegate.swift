//
//  ProfileDelegate.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 13/09/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let nc = self.navigationController, let trickName = cell?.textLabel?.text else {
            return
        }
        let coord = TrickCoordinator(presenter: nc, trickName: trickName)
        coord.start()
    }
}
