//
//  VideoStorageManager.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 07/04/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import Firebase

class VideoStorageManager {
    
    static var shared: VideoStorageManager {
        get {
            return VideoStorageManager()
        }
    }
    
    fileprivate let storage = Storage.storage()
    
    func uploadVideo(url: URL, metadata: [String : Any]) {
        
    }
}
