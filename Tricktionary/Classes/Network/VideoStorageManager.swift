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
    
    func uploadVideo(url: URL, metadata: [String : Any], success: @escaping () -> Void, failed: @escaping (String) -> Void) {
        let videoReference = storage.reference().child("submit").child(metadata["name"] as! String)
        
        do {
            let data = try Data(contentsOf: url)
            videoReference.putData(data, metadata: nil) { (metadata, error) in
                if let error = error {
                    failed(error.localizedDescription)
                } else {
                    success()
                }
            }
        } catch {
            failed("Error get video data")
        }
    }
}
