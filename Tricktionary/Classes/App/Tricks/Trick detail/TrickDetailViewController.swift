//
//  TrickDetailViewController.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import YouTubePlayerSwift

class TrickDetailViewController: UIViewController {
    
    // MARK: Variables
    
    var viewModel: TrickDetailViewModel
    var playerView: YouTubePlayerView = YouTubePlayerView()
    var descriptionLabel: UILabel = UILabel()
    
    // MARK: Life cycles
    
    init(viewModel: TrickDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(playerView)
        view.addSubview(descriptionLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.trick.name
        
        view.backgroundColor = UIColor.lightGray
        
        playerView.backgroundColor = UIColor.black
        playerView.play(videoID: viewModel.trick.videos.youtube!)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.contentMode = .scaleAspectFit
        descriptionLabel.baselineAdjustment = .alignBaselines
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.text = viewModel.trick.description
        descriptionLabel.autoresizesSubviews = true
        
        setupViewConstraints()
    }
    
    // MARK: Private
    
    fileprivate func setupViewConstraints() {
        playerView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(250)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(8)
            make.leading.equalTo(view).inset(10)
            make.trailing.equalTo(view).inset(10)
            make.height.equalTo(55)
        }
    }
}
