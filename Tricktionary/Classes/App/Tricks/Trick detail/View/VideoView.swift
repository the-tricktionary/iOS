//
//  VideoView.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 04/03/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation
import YoutubePlayerView
import UIKit

class VideoView: UIView, YoutubePlayerViewDelegate {

    // MARK: - Variables
    // public

    // private
    private let placeholder = UIImageView()
    private let playButton = UIButton()
    private let playerView = YoutubePlayerView()

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
        setupContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Content

    private func setupContent() {
        addSubview(playerView)
        addSubview(placeholder)
        placeholder.addSubview(playButton)

        setupButton()
        playerView.delegate = self
        setupViewContstraints()
    }

    private func setupButton() {
        placeholder.isUserInteractionEnabled = true
        placeholder.contentMode = .scaleToFill
        
        playButton.setImage(UIImage(named: "video-play"), for: .normal)
        playButton.addTarget(self, action: #selector(switchVideo), for: .touchUpInside)
        playButton.isEnabled = false
    }

    private func setupViewContstraints() {
        placeholder.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        playButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(70)
        }

        playerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.placeholder)
        }
    }

    func customize(with content: Content) {
        playerView.isHidden = !content.autoPlay
        placeholder.isHidden = content.autoPlay
        placeholder.kf.setImage(with: URL(string: content.imageUrlString))

        if let url = content.url {
            setVideo(url: url, fullScreen: content.fullScreen, autoPlay: content.autoPlay)
        }
    }

    // TODO: Move to VM
    private func setVideo(url: String, fullScreen: Bool, autoPlay: Bool) {
        let playerVars = [
            "controls": 1,
            "modestbranding": 0,
            "playsinline": fullScreen ? 0 : 1,
            "rel": 1,
            "showinfo": 1,
            "autoplay": autoPlay ? 1 :0
        ]
        playerView.loadWithVideoId(url, with: playerVars)
        playerView.play()
    }

    @objc func switchVideo() {
        placeholder.isHidden = true
        playerView.isHidden = false
        playerView.play()
    }

    // YT Delegate
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        playButton.isEnabled = true
    }
}

extension VideoView {
    struct Content {
        var imageUrlString: String
        var showPlaceholder: Bool

        var url: String?
        var fullScreen: Bool
        var autoPlay: Bool
    }
}
