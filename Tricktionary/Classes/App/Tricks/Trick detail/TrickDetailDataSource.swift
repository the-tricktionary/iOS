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
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrickInfo", for: indexPath) as! TrickInfoCell
            cell.customize(with: TrickInfoCell.Content(name: viewModel.trickName,
                                                       level: viewModel.trick?.levels?.ijru.level ?? "",
                                                       favorite: false, completed: viewModel.isDone))
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrickDescription", for: indexPath) as! DescriptionCell
            cell.descriptionText.text = viewModel.trick?.description
            return cell
        default:
            return UITableViewCell()
        }

    }
}
