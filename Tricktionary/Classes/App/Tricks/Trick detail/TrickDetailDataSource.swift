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
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let videoCell = tableView.dequeueReusableCell(withIdentifier: VideoCell.identity, for: indexPath) as! VideoCell
        if let video = viewModel.video {
            videoCell.setVideo(url: video.youtube,
                               fullScreen: viewModel.settings.fullscreen,
                               autoPlay: viewModel.settings.autoPlay)
        }
        return videoCell
    }
}
