//
//  SubmitViewModel.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 07/04/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation

class SubmitViewModel {
    
    // MARK: Variables
    
    var videoURL: URL?
    
    let organisations: [String] = ["FISAC", "WJR"]
    let types: [String] = ["Basic", "Multiple", "Manipulation", "Power", "Release", "Impossible"]
    
    // MARK: Life cycle
    
    init() {
        self.videoURL = nil
    }
    
    // MARK: Public
    
    func uploadVideo() {
        
    }
}
