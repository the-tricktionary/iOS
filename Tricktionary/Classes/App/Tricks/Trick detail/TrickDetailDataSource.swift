//
//  TrickDetailDataSource.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/12/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

extension TrickDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return viewModel.preprequisites.value.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 && viewModel.preprequisites.value != nil {
            let header = PrerequisiteHeaderView()
            header.customize(title: "Requirements", collapsed: true)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrickInfo", for: indexPath) as! TrickInfoCell
            cell.customize(with: TrickInfoCell.Content(id: viewModel.trick?.id,
                                                       name: viewModel.trickName,
                                                       level: viewModel.trick?.levels?.ijru.level ?? "",
                                                       favorite: false, completed: viewModel.isDone))
            cell.doneTapped = { [weak self] id in
                self?.viewModel.markTrickAsDone(id)
            }
            return cell
        case 1:
            let trick = viewModel.preprequisites.value[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrickPrerequisites", for: indexPath) as! TrickLevelCell
            cell.customizePrerequisite(with: TrickLevelCell.Content(title: trick.name,
                                                                    levels: [.ijru : trick.levels?.ijru.level ?? ""],
                                                                    isDone: false))
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrickDescription", for: indexPath) as! DescriptionCell
            cell.descriptionText.text = viewModel.trick?.description
            return cell
        default:
            return UITableViewCell()
        }

    }
}
