//
//  TrickDetailViewModel.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol TrickDetailViewModelType {
    var onLoad: (() -> Void)? { get set }
    var onStartLoading: (() -> Void)? { get set }
    var isDone: Bool { get }
    func getTrick()
    var trick: Trick? { get set }
    var settings: TrickDetailSettingsType { get }
}

protocol TrickDetailSettingsType {
    var autoPlay: Bool { get set }
    var fullscreen: Bool { get set }
}

class TrickDetailViewModel: TrickDetailViewModelType {
    
    // MARK: Variables

    var onLoad: (() -> Void)?
    var onStartLoading: (() -> Void)?
    var isDone: Bool

    var settings: TrickDetailSettingsType
    
    var trick: Trick?
    var video: MutableProperty<VideoView.Content?> = MutableProperty<VideoView.Content?>(nil)
    var trickName: String
    var loadedPrerequisites: MutableProperty<Bool> = MutableProperty<Bool>(false)

    var thumbnail: MutableProperty<String> = MutableProperty<String>("")

    private var thumbnailURL: ((String) -> String) = { id in
        return "https://img.youtube.com/vi/\(id)/0.jpg"
    }

    private var dataTask: URLSessionDataTask?
    // MARK: Life cycles
    
    init(trick: String, settings: TrickDetailSettingsType, done: Bool) {
        self.isDone = done
        self.settings = settings
        self.trickName = trick
    }
    
    // MARK: Public
    
    func getTrick() {
        TrickManager.shared.getTrickByName(name: trickName,
                                           starting: { [weak self] in
                                            self?.onStartLoading?()
        }, completion: { (trick) in
            self.trick = trick
            self.video.value = self.makeVideoContent(with: trick.videos!)
            self.thumbnail.value = self.thumbnailURL(trick.videos!.youtube)
            self.onLoad?()
        }) { [weak self] in
            self?.onLoad?()
        }
    }

    private func makeVideoContent(with video: Video) -> VideoView.Content {
        return VideoView.Content(imageUrlString: thumbnailURL(video.youtube),
                                 showPlaceholder: settings.autoPlay,
                                 url: video.youtube,
                                 fullScreen: settings.fullscreen,
                                 autoPlay: settings.autoPlay)
    }
}
