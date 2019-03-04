//
//  SpeedDataDetailDataSource.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

extension SpeedDataDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getMirror().children.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = viewModel.speedData.name ?? "No named"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Created"
            cell.detailTextLabel?.text = viewModel.speedData.created?.description
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Event"
            cell.detailTextLabel?.text = viewModel.speedData.event ?? "No event"
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "Jumps lost"
            cell.detailTextLabel?.text = "\(viewModel.speedData.jumpsLost)"
        } else if indexPath.row == 4 {
            cell.textLabel?.text = "Max jumps"
            cell.detailTextLabel?.text = "\(viewModel.speedData.maxJumps)"
        } else if indexPath.row == 5 {
            cell.textLabel?.text = "Misses"
            cell.detailTextLabel?.text = "\(viewModel.speedData.misses)"
        } else if indexPath.row == 6 {
            cell.textLabel?.text = "No miss score"
            cell.detailTextLabel?.text = "\(viewModel.speedData.noMissScore)"
        } else if indexPath.row == 7 {
            cell.textLabel?.text = "Score"
            cell.detailTextLabel?.text = "\(viewModel.speedData.score)"
        } else if indexPath.row == 8 {
            cell.textLabel?.text = "Duration"
            cell.detailTextLabel?.text = DateTimeUtil.timeFormatted(viewModel.speedData.duration)
        } else if indexPath.row == 9 {
            cell.textLabel?.text = "Avg Jumps"
            cell.detailTextLabel?.text = "\(viewModel.speedData.avgJumps)"
        } else if indexPath.row == 10 {
            cell = GraphCell(chartData: viewModel.getSpeedChartData())
        }

        return cell
    }
}
