//
//  VideoCell.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/12/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import YouTubePlayerSwift

class VideoCell: UITableViewCell {
    
    // MARK: Variables
    
    let videoView: YouTubePlayerView = YouTubePlayerView()
    fileprivate let view: UIView = UIView()
    
    
    // MARK: Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setup()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Privates
    
    fileprivate func setupSubviews() {
        contentView.addSubview(view)
        view.addSubview(videoView)
    }
    
    fileprivate func setup() {
        contentView.backgroundColor = UIColor.black
        view.backgroundColor = UIColor.black
        selectionStyle = .none
    }
    
    fileprivate func setupViewConstraints() {
        
        view.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.height.equalTo(250)
        }
        
        videoView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
    }
    
    // MARK: Publics
    
    func setVideo(url: String) {
        videoView.play(videoID: url)
    }
}
