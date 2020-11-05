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
    var preprequisites: CurrentValueSubject<[Trick], Never> { get }
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
    var preprequisites = CurrentValueSubject<[Trick], Never>([])
    var video = CurrentValueSubject<VideoView.Content?, Never>(nil)
    var trickName: String

    var thumbnail = PassthroughSubject<String, Never>()

    private var thumbnailURL: ((String) -> String) = { id in
        return "https://img.youtube.com/vi/\(id)/0.jpg"
    }

    private var trickId: String?
    private var dataProvider: TrickDetailDataProviderType
    private var cancelable = Set<AnyCancellable>()
    
    // MARK: Life cycles
    
    init(trick: String, dataProvider: TrickDetailDataProviderType, settings: TrickDetailSettingsType, done: Bool) {
        self.trickName = trick
        self.dataProvider = dataProvider
        self.settings = settings
        self.isDone = done
    }
    
    // MARK: Public
    
    func getTrick() {
        dataProvider.getTrickByName(name: trickName)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    self.onLoad?()
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
            } receiveValue: { trick in
                self.trick = trick
                if let prerequisites = trick.prerequisites {
                    self.loadPrerequisites(with: prerequisites)
                }
                if let video = trick.videos {
                    self.video.send(self.makeVideoContent(with: video))
                    self.thumbnail.send(self.thumbnailURL(video.youtube))
                }
                self.onLoad?()
            }.store(in: &cancelable)
    }

    func markTrickAsDone(_ id: String?) {
        isDone.toggle()
        TrickManager.shared.markTrickAsDone(isDone: isDone, id: id ?? "")
    }

    private func loadPrerequisites(with ids: [Prerequisites]) {
        dataProvider.getPrerequisites(ids: ids)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("### Error \(error.localizedDescription)")
                default:
                    break
                }
            } receiveValue: { trick in
                self.preprequisites.value.append(trick)
            }.store(in: &cancelable)
    }

    private func makeVideoContent(with video: Video) -> VideoView.Content {
        return VideoView.Content(imageUrlString: thumbnailURL(video.youtube),
                                 showPlaceholder: settings.autoPlay,
                                 url: video.youtube,
                                 fullScreen: settings.fullscreen,
                                 autoPlay: settings.autoPlay)
    }
}
