//
//  SpeedTimerDataSource.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 11/01/2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

struct SpeedTableSection: Hashable {
    let rows: [SpeedEvent]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rows)
    }
}

class SpeedTimerDataSource: UITableViewDiffableDataSource<SpeedTableSection, String> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        nil
    }
}
