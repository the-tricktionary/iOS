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

    var isDone: Bool { get set }
    var trick: Trick? { get set }
    var preprequisites: CurrentValueSubject<[Trick], Never> { get }
    var video: CurrentValueSubject<VideoViewWrapper.Content?, Never> { get }
    var settings: TrickDetailSettingsType { get }
    var tricksManager: TricksContentManager { get }

    func markTrickAsDone(_ id: String, done: Bool)
    func getTrick(by name: String)

}

protocol TrickDetailSettingsType {
    var autoPlay: Bool { get set }
    var fullscreen: Bool { get set }
}

class TrickDetailViewModel: TrickDetailViewModelType, ObservableObject {
    
    // MARK: Variables
    // published
    @Published var isDone: Bool = false
    @Published var uiTrick: Trick?
    @Published var uiPreprequisites: [Trick]?
    @Published var videoThumbnail: URL?
    @Published var uiViedeo: VideoViewWrapper.Content?

    var onLoad: (() -> Void)?
    var onStartLoading: (() -> Void)?

    var settings: TrickDetailSettingsType
    
    var trick: Trick?
    var preprequisites = CurrentValueSubject<[Trick], Never>([])
    var video = CurrentValueSubject<VideoViewWrapper.Content?, Never>(nil)

    var thumbnail = PassthroughSubject<String, Never>()

    private var thumbnailURL: ((String) -> String) = { id in
        "https://img.youtube.com/vi/\(id)/0.jpg"
    }

    private var trickId: String?
    private var dataProvider: TrickDetailDataProviderType
    private var cancelable = Set<AnyCancellable>()
    let tricksManager: TricksContentManager
    
    // MARK: Life cycles
    
    init(dataProvider: TrickDetailDataProviderType,
         settings: TrickDetailSettingsType,
         tricksManager: TricksContentManager) {
        self.dataProvider = dataProvider
        self.settings = settings
        self.tricksManager = tricksManager
    }
    
    // MARK: Public
    
    func getTrick(by name: String) {
        dataProvider.getTrickByName(name: name)
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
                self.uiTrick = trick
                self.isDone = self.tricksManager.completedTricks.contains(trick.id ?? "")
                if let prerequisites = trick.prerequisites {
                    self.loadPrerequisites(with: prerequisites)
                }
                if let video = trick.videos {
                    self.video.send(self.makeVideoContent(with: video)) // deprecated
                    self.uiViedeo = self.makeVideoContent(with: video)
                    self.videoThumbnail = URL(string: self.thumbnailURL(video.youtube))
                    self.thumbnail.send(self.thumbnailURL(video.youtube))
                }
                self.onLoad?()
            }.store(in: &cancelable)
    }

    func markTrickAsDone(_ id: String, done: Bool) {
        var ids = tricksManager.completedTricks
        if done {
            ids.append(id)
        } else {
            ids.removeAll { trickId in
                trickId == id
            }
        }

        TrickManager.shared.markTrickAsDone(ids: ids)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                //
            } receiveValue: { success in
                if success {
                    self.isDone = done
                    self.tricksManager.completedTricks = ids
                    self.onLoad?()
                }
            }
            .store(in: &cancelable)
    }

    private func loadPrerequisites(with ids: [Prerequisites]) {
        Publishers.MergeMany(ids.map {dataProvider.getTrickById($0.id)})
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                //
            } receiveValue: { (trick) in
                self.preprequisites.value.append(trick)
                self.uiPreprequisites = nil
                self.uiPreprequisites = self.preprequisites.value
            }
            .store(in: &cancelable)
    }

    private func makeVideoContent(with video: Video) -> VideoViewWrapper.Content {
        return VideoViewWrapper.Content(imageUrlString: thumbnailURL(video.youtube),
                                 showPlaceholder: settings.autoPlay,
                                 url: video.youtube,
                                 fullScreen: settings.fullscreen,
                                 autoPlay: settings.autoPlay)
    }
}
