//
//  SpeedDataDelegate.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

extension SpeedDataViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let speed = viewModel.speeds[indexPath.row]
        let detailViewModel = SpeedDataDetailViewModel(speedData: speed)
        navigationController?.pushViewController(SpeedDataDetailViewController(viewModel: detailViewModel), animated: true)
    }
}
