//
//  SpeedTimerViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 17/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import AVFoundation

class SpeedTimerViewController: BaseCenterViewController {

    // MARK: Variables

    var viewModel: SpeedTimerViewModel
    
    init(viewModel: SpeedTimerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Speed timer"
    }
    
//    // TODO: This is string component!
//    fileprivate func timeFormatted(_ totalSeconds: Int, _ miliseconds: Int?) -> String {
//        let seconds: Int = totalSeconds % 60
//        let minutes: Int = (totalSeconds / 60) % 60
//        //     let hours: Int = totalSeconds / 3600
//        if let miliseconds = miliseconds {
//            return String(format: "%02d:%02d:%02d", minutes, seconds, miliseconds)
//        }
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
}
