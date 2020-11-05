//
//  TrickDetailViewModel.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import Combine

protocol TrickDetailViewModelType {
    var onLoad: (() -> Void)? { get set }
    var onStartLoading: (() -> Void)? { get set }

    var isDone: Bool { get }
    var trick: Trick? { get set }
    var preprequisites: CurrentValueSubject<[Trick]?, Never> { get }
    var video: CurrentValueSubject<VideoView.Content?, Never> { get }
    var settings: TrickDetailSettingsType { get }

    var trickName: String { get set }
    func markTrickAsDone(_ id: String?)
    func getTrick()

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
    var preprequisites = CurrentValueSubject<[Trick]?, Never>(nil)
    var video = CurrentValueSubject<VideoView.Content?, Never>(nil)
    var trickName: String

    var thumbnail = PassthroughSubject<String, Never>()

    private var thumbnailURL: ((String) -> String) = { id in
        return "https://img.youtube.com/vi/\(id)/0.jpg"
    }

    private var trickId: String?
    
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
            if let prerequisites = trick.prerequisites {
                self.loadPrerequisites(with: prerequisites)
            }
            self.video.send(self.makeVideoContent(with: trick.videos!)) // TODO: Force unwrapping remove!
            self.thumbnail.send(self.thumbnailURL(trick.videos!.youtube))
            self.onLoad?()
        }) { [weak self] in
            self?.onLoad?()
        }
    }

    func markTrickAsDone(_ id: String?) {
        isDone.toggle()
        TrickManager.shared.markTrickAsDone(isDone: isDone, id: id ?? "")
    }

    private func loadPrerequisites(with ids: [Prerequisites]) {
        ids.forEach { prerequisite in
            TrickManager.shared.getTrickById(id: prerequisite.id, completion: { trick in
                if self.preprequisites.value == nil {
                    self.preprequisites.value = [trick]
                } else {
                    self.preprequisites.value?.append(trick)
                }
            }) {
                //
            }
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
