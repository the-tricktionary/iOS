//
//  TricksDelegate.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

extension TricksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.settings.showIjru ||
            viewModel.settings.showIrsf ||
            viewModel.settings.showWjr {
            return 68
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trick = viewModel.sections.value[indexPath.section].rows[indexPath.row]
        let vm = TrickDetailViewModel(trick: trick.title)
        let vc = TrickDetailViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
