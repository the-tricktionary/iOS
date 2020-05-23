//
//  TrickDetailDelegate.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/12/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

extension TrickDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 92
        case 1:
            return 68
        default:
            return 45
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 && viewModel.preprequisites.value != nil {
            return 45
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let trick = viewModel.preprequisites.value?[indexPath.row] else {
                return
            }
            let vm = TrickDetailViewModel(trick: trick.name, settings: viewModel.settings, done: false)
            let vc = TrickDetailViewController(viewModel: vm)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
