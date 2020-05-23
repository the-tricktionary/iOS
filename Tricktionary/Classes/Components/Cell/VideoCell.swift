//
//  VideoCell.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/12/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import YoutubePlayerView
import AVFoundation

class VideoCell: UITableViewCell {
    
    // MARK: Variables
    static let identity = "VideoCell"
    
    let videoView: YoutubePlayerView = YoutubePlayerView()
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
        
        videoView.backgroundColor = UIColor.black
        
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
    
    func setVideo(url: String, fullScreen: Bool, autoPlay: Bool) {
        let playerVars = [
            "controls": 1,
            "modestbranding": 0,
            "playsinline": fullScreen ? 0 : 1,
            "rel": 1,
            "showinfo": 1,
            "autoplay": autoPlay ? 1 :0
        ]
        videoView.loadWithVideoId(url, with: playerVars)
        
        videoView.play()
    }
}
