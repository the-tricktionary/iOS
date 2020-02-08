//
//  ProfileViewModel.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 08/05/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseAuth
import ReactiveCocoa
import ReactiveSwift

protocol ProfileViewModelType {
    var profileInfo: MutableProperty<ProfileInfo> { get }
    var tricksInfo: MutableProperty<[String]> { get }
    var trickList: MutableProperty<[Trick]> { get }
    var completedInLevel: MutableProperty<[(level: Int, tricks: Int)]> { get }
    func loadData()

    var onStartLoading: (() -> Void)? { get }
    var onFinishLoading: (() -> Void)? { get }
}

class ProfileViewModel: ProfileViewModelType {
    // MARK: - Variables
    var profileInfo = MutableProperty<ProfileInfo>(ProfileInfo())
    var tricksInfo = MutableProperty<[String]>([String]())
    var trickList = MutableProperty<[Trick]>([Trick]())
    var completedInLevel = MutableProperty<[(level: Int, tricks: Int)]>([])

    var onFinishLoading: (() -> Void)?
    var onStartLoading: (() -> Void)?

    // MARK: Public
    func loadData() {
        loadProfileInfo()
        loadTricksInfo()
        loadCompletedTricks()
    }
    
    // MARK: Private

    private func loadProfileInfo() {
        let user = getUser()

        let info = ProfileInfo(photo: getUserPhotoURL(),
                               name: user?.displayName ?? "",
                               email: user?.email ?? "")
        profileInfo.value = info
    }

    private func loadTricksInfo() {
        TrickManager.shared.getChecklist(completion: { data in
            guard let data = data else {
                return
            }
            self.tricksInfo.value = data
        }) {
            self.onFinishLoading?()
            self.loadCompletedTricks()
        }
    }

    private func loadCompletedTricks() {

    }

    private func getUserPhotoURL() -> Data? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
        var data: Data?
        
        if let userImageURL = user.photoURL {
            do {
                data = try Data(contentsOf: userImageURL)
            } catch {
                return nil
            }
        }
        
        return data
    }
    
    private func getUser() -> User? {
       return Auth.auth().currentUser
    }

    private func countCompletedByLevel() {
        var levels = Set<Int>()
        trickList.value.forEach { trick in
            levels.insert(trick.level)
        }
        levels.forEach { level in
            let tricks = trickList.value.filter { $0.level == level }
            completedInLevel.value.append((level: level, tricks: tricks.count))
        }
    }
}
