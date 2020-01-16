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
        return viewModel.sections.value.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.value[section].rows.count
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? TypeHeaderView else {
            return nil
        }
        let actualSection = viewModel.sections.value[section]
        view.customize(with: actualSection.name, collapsed: actualSection.collapsed)
        view.onTapped = { [unowned self] sectionName in
            self.viewModel.toggleSection(name: sectionName)
        }
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trick = viewModel.sections.value[indexPath.section].rows[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrickLevelCell.reuseIdentifier(),
                                                       for: indexPath) as? TrickLevelCell else {
                                                        return UITableViewCell()
        }
        cell.customize(with: trick)
        return cell
    }
}
