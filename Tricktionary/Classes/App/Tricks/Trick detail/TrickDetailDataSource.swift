//
//  TrickDetailDataSource.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/12/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class TrickDetailDataSource: NSObject, UITableViewDataSource {
    
    // MARK: Variables
    
    var viewModel: TrickDetailViewModel!
    var prerequisiteIndex: Int = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let trick = viewModel.trick {
            return 4 + (trick.prerequisites.count + 1)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let descriptionCell = DescriptionCell()
            descriptionCell.descriptionText.text = viewModel.trick!.description
            return descriptionCell
        } else if indexPath.row == 1 {
            let videoCell = VideoCell()
            videoCell.setVideo(url: viewModel.trick!.videos.youtube)
            return videoCell
        } else if indexPath.row == 2 {
            let infoCell = InformationCell()
            infoCell.title.text = "Level WJR:"
            infoCell.info.text = viewModel.trick!.levels.wjr.level
            return infoCell
        } else if indexPath.row == 3 {
            let infoCell = InformationCell()
            infoCell.title.text = "Level FISAC-IJRF:"
            infoCell.info.text = viewModel.trick!.levels.irsf.level
            return infoCell
        }
        if viewModel.trick!.prerequisites.count > 0 {
            if indexPath.row == 4 {
                let cell = UITableViewCell()
                cell.textLabel?.text = "Prerequisites"
                return cell
            }
            let infoCell = InformationCell()
            let prerequsite = viewModel.trick!.prerequisites[prerequisiteIndex]
            infoCell.title.text = prerequsite
            if viewModel.trick!.prerequisites.count > prerequisiteIndex + 1 {
                prerequisiteIndex += 1
            }
            return infoCell
        }
        
        return UITableViewCell()
    }
}
