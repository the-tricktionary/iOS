//
//  SubmitViewModel.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 07/04/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseAuth

class SubmitViewModel {
    
    // MARK: Variables
    
    var videoURL: URL?
    
    let types: [String] = ["Basic", "Multiple", "Manipulation", "Power", "Release", "Impossible"]
    var metadata: VideoMetadata
    
    // MARK: Life cycle
    
    init() {
        self.videoURL = nil
        self.metadata = VideoMetadata()
    }
    
    // MARK: Public
    
    func uploadVideo(success: @escaping () -> Void, failed: @escaping (String) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        metadata.name = "\(Int(Date().timeIntervalSince1970)).mp4"
        metadata.uid = user.uid
        metadata.email = user.email ?? "Unknown email"
        
        VideoStorageManager.shared.uploadVideo(url: videoURL!, metadata: metadata.asDisctionary(), success: {
            success()
        }, failed: { (error) in
            failed(error)
        })
    }
    
    func isValid() -> Bool {
        return metadata.isValid()
    }
}
