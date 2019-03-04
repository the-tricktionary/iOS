//
//  SpeedDataDetailDelegate.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 24/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

extension SpeedDataDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 10 {
            return 250
        }
        return UITableView.automaticDimension
    }
}

