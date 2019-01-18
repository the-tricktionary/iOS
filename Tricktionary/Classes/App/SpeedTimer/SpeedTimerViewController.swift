//
//  SpeedTimerViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 17/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SpeedTimerViewController: MenuItemViewController {
    
    // MARK: Variables
    
    fileprivate let clickButton: UIButton = UIButton()
    fileprivate let countLabel: UILabel = UILabel()
    fileprivate let impact: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator()
    fileprivate var timer: Timer?
    
    fileprivate var eventTime: Float = 0.0
    fileprivate var count: Int = 0
    
    // MARK: Life cycles
    
    override func loadView() {
        super.loadView()
        view.addSubview(clickButton)
        clickButton.addSubview(countLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Speed Timer"
        view.backgroundColor = UIColor.white
        
        let timePickerButton = UIBarButtonItem(image: UIImage(named: "timer"),
                                         landscapeImagePhone: nil,
                                         style: .plain,
                                         target: self,
                                         action: #selector(timePickerTapped))
        
        let eventPickerButton = UIBarButtonItem(image: UIImage(named: "writer"),
                                                landscapeImagePhone: nil,
                                                style: .plain,
                                                target: self,
                                                action: #selector(eventPickerTapped))
        
        navigationItem.setRightBarButtonItems([eventPickerButton, timePickerButton], animated: true)
        
        countLabel.textColor = UIColor.red
        countLabel.font = UIFont.boldSystemFont(ofSize: 38)
        countLabel.textAlignment = .center
        countLabel.text = "\(count)"
        
        clickButton.isUserInteractionEnabled = true
        clickButton.addTarget(self, action: #selector(click), for: .touchDown)

        setupViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        
        clickButton.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.leading.equalTo(clickButton)
            make.trailing.equalTo(clickButton)
            make.centerY.equalTo(clickButton)
        }
    }
    
    fileprivate func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(tick),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    fileprivate func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: Public
    
    // MARK: User action
    
    @objc func click() {
        if timer == nil {
            setupTimer()
        }
        impact.impactOccurred()
        count += 1
        countLabel.text = "\(count)"
    }
    
    @objc func timePickerTapped() {
        print("TAPPED TIME PICKER")
    }
    
    @objc func eventPickerTapped() {
        print("EVENT PICEKR TAPPED")
    }
    
    @objc func tick() {
        eventTime += 0.1
        if eventTime > 10 {
            timer?.invalidate()
        }
        title = "\(timeFormatted(Int(eventTime)))"
    }
}
