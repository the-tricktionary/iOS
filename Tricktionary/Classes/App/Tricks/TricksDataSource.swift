//
//  TricksDataSource.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

extension TricksViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let types = viewModel.getTrickTypes()
        return types.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let types = viewModel.getTrickTypes()
        return viewModel.getTricks(types[section]).count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TypeHeaderView()
        view.setTitleLabel(viewModel.getTrickTypes()[section])
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let trick = viewModel.getTricks(viewModel.getTrickTypes()[indexPath.section])[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: TrickLevelCell.reuseIdentifier(), for: indexPath) as! TrickLevelCell
            cell.title.text = trick.name
            cell.isTopBorderVisible(false)
            return cell
    }
    
    
}
