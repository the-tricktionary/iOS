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
        if let _ = viewModel.trick {
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "Levels"
        }
        if section == 3 {
            if let trick = viewModel.trick, trick.prerequisites.count > 0 {
                return "Prerequisites"
            }
            return ""
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let trick = viewModel.trick {
            switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return 2
            case 3:
                return trick.prerequisites.count
            default:
                return 0
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let trick = viewModel.trick {
            if indexPath.section == 0 {
                let descriptionCell = DescriptionCell()
                descriptionCell.descriptionText.text = trick.description
                return descriptionCell
            } else if indexPath.section == 1 {
                let videoCell = VideoCell()
                videoCell.setVideo(url: trick.videos.youtube)
                return videoCell
            } else if indexPath.section == 2 {
                switch indexPath.row {
                case 0:
                    let infoCell = InformationCell()
                    infoCell.title.text = "Level FISAC-IJRF:"
                    infoCell.info.text = trick.levels.irsf.level
                    return infoCell
                case 1:
                    let infoCell = InformationCell()
                    infoCell.title.text = "Level WJR:"
                    infoCell.info.text = trick.levels.wjr.level
                    return infoCell
                default:
                    return UITableViewCell()
                }
            } else if indexPath.section == 3 {
                if viewModel.trick!.prerequisites.count > 0 {
                    let infoCell = InformationCell()
                    infoCell.accessoryType = .disclosureIndicator
                    let prerequsite = trick.prerequisites[indexPath.row]
                    infoCell.title.text = prerequsite
                    return infoCell
                }
            }
        }
        return UITableViewCell()
    }
}
