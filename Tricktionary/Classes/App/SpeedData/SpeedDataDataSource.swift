//
//  SpeedDataDataSource.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

extension SpeedDataViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.speeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SpeedListCell.reuseIdentifier(),
                                                       for: indexPath) as? SpeedListCell else {
            return UITableViewCell()
        }
        let speed = viewModel.speeds[indexPath.row]
        cell.customize(SpeedListCell.Content(name: speed.name ?? "No name",
                                             score: speed.score,
                                             misses: speed.misses,
                                             noMissScore: speed.noMissScore))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let speed = viewModel.speeds[indexPath.row]
            viewModel.speeds.remove(at: indexPath.row)
            SpeedManager.shared.deleteSpeedEvent(speed: speed) { // TODO: Haven`t permition
                self.tableView.reloadData()
            }
            tableView.reloadData()
        }
    }
}
