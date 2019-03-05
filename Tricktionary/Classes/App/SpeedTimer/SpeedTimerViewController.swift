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

class SpeedTimerViewController: MenuItemViewController {
    
    // MARK: Variables
    
    fileprivate let clickButton: UIButton = UIButton()
    fileprivate let countLabel: UILabel = UILabel()
    fileprivate let timePickerTextField: UITextField = UITextField()
    fileprivate let impact: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator()
    fileprivate var timer: Timer?
    fileprivate let timePicker: UIPickerView = UIPickerView()
    fileprivate let eventPicker: UIPickerView = UIPickerView()
    fileprivate let toolBar: UIToolbar = UIToolbar()
    fileprivate var speachUtil: SpeachUtil = SpeachUtil()
    fileprivate let synth = AVSpeechSynthesizer()
    
    fileprivate var eventTime: Int = 0
    fileprivate var count: Int = 0
    
    var jumpsPerSecond: Int = 0
    
    fileprivate var timePickerDelegate: TimePicker = TimePicker()
    fileprivate var eventPickerDelegate: EventPicker = EventPicker()
    
    let controllView: ControllView = ControllView()
    var usedTime: Int = 30
    var viewModel: SpeedTimerViewModel
    
    var timeToSpeek: Int = 1
    let speekBy: Int = 10
    var miliseconds: Int = 0
    // MARK: Life cycles
    
    init(viewModel: SpeedTimerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(clickButton)
        view.addSubview(controllView)
        view.addSubview(timePickerTextField)
        clickButton.addSubview(countLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Speed Timer"
        view.backgroundColor = UIColor.white
        
        synth.delegate = self
        
        countLabel.textColor = UIColor.red
        countLabel.font = UIFont.boldSystemFont(ofSize: 38)
        countLabel.textAlignment = .center
        countLabel.text = "\(count)"
        
        clickButton.isUserInteractionEnabled = true
        clickButton.addTarget(self, action: #selector(click), for: .touchDown)
        
        timePicker.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        timePickerDelegate.viewModel = viewModel
        timePickerDelegate.viewController = self
        timePicker.dataSource = timePickerDelegate
        timePicker.delegate = timePickerDelegate
        
        eventPicker.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        eventPickerDelegate.viewModel = viewModel
        eventPickerDelegate.viewController = self
        eventPicker.dataSource = eventPickerDelegate
        eventPicker.delegate = eventPickerDelegate
        
        let timeToolBar = UIToolbar()
        timeToolBar.barStyle = UIBarStyle.default
        timeToolBar.isTranslucent = true
        timeToolBar.tintColor = UIColor.red.withAlphaComponent(0.5)
        timeToolBar.sizeToFit()
        
        let eventToolBar = UIToolbar()
        eventToolBar.barStyle = UIBarStyle.default
        eventToolBar.isTranslucent = true
        eventToolBar.tintColor = UIColor.red.withAlphaComponent(0.5)
        eventToolBar.sizeToFit()
        
        let doneTimeButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneTimePicker))
        let doneEventButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneEventPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        timeToolBar.setItems([spaceButton, doneTimeButton], animated: false)
        timeToolBar.isUserInteractionEnabled = true
        
        eventToolBar.setItems([spaceButton, doneEventButton], animated: false)
        eventToolBar.isUserInteractionEnabled = true
        
        controllView.eventType.inputView = eventPicker
        controllView.eventType.inputAccessoryView = eventToolBar
        
        controllView.eventTime.inputView = timePicker
        controllView.eventTime.inputAccessoryView = timeToolBar
        
        controllView.eventTime.text = "Speed time"
        controllView.eventType.text = "Event type"
        
        if timer == nil {
            controllView.stopButton.isHidden = true
        }
        
        controllView.resetButton.isUserInteractionEnabled = true
        controllView.resetButton.addTarget(self, action: #selector(resetCount), for: .touchDown)
        
        controllView.playButton.isUserInteractionEnabled = true
        controllView.playButton.addTarget(self, action: #selector(playTapped), for: .touchDown)
        
        controllView.stopButton.isUserInteractionEnabled = true
        controllView.stopButton.addTarget(self, action: #selector(stopTapped), for: .touchDown)
        
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
        
        controllView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(10)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(32)
        }
    }
    
    fileprivate func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(tick),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    fileprivate func timeFormatted(_ totalSeconds: Int, _ miliseconds: Int?) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        if let miliseconds = miliseconds {
            return String(format: "%02d:%02d:%02d", minutes, seconds, miliseconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    fileprivate func playBeginSpeech() {
        let begin = "Single rope speed. One by \(usedTime)."
        speek(begin)
    }
    
    fileprivate func speek(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(utterance)
    }
    
    // MARK: User action
    
    @objc func click() {
        impact.impactOccurred()
        count += 1
        countLabel.text = "\(count)"
        jumpsPerSecond += 1
        
    }
    
    @objc func doneTimePicker() {
        controllView.eventTime.endEditing(true)
    }
    
    @objc func doneEventPicker() {
        controllView.eventType.endEditing(true)
    }
    
    @objc func tick() {
        title = "\(timeFormatted(eventTime, miliseconds))"
        if miliseconds == 10 {
            eventTime += 1
            viewModel.speed.graphData.append(Double(jumpsPerSecond))
            jumpsPerSecond = 0
            miliseconds = 0
        }
        miliseconds += 1
        if eventTime == usedTime {
            timer?.invalidate()
            timer = nil
            eventTime = 0
            miliseconds = 0
            clickButton.isUserInteractionEnabled = false
            timeToSpeek = 0
            navigationItem.title = "Speed Timer"
            controllView.stopButton.isHidden = true
            controllView.resetButton.isHidden = false
            controllView.eventTime.isEnabled = true
            controllView.eventType.isEnabled = true
            viewModel.speed.avgJumps = Double(count) / Double(usedTime)
            viewModel.speed.score = count
            print(viewModel.speed.avgJumps)
            var second = 1
            viewModel.speed.graphData.forEach { (value) in
                print("In \(second) second: \(value) jumps")
                second += 1
            }
            viewModel.speed.duration = usedTime
            viewModel.speed.created = Date()
            viewModel.speed.maxJumps = viewModel.speed.graphData.max()!
            SpeedManager.shared.saveSpeedEvent(speed: viewModel.speed)
        }
    }
    
    @objc func resetCount() {
        count = 0
        countLabel.text = "\(count)"
        controllView.playButton.isHidden = false
        clickButton.isUserInteractionEnabled = true
    }
    
    @objc func playTapped() {
        resetCount()
        clickButton.isUserInteractionEnabled = false
        controllView.eventTime.isEnabled = false
        controllView.eventType.isEnabled = false
        controllView.resetButton.isHidden = true
        controllView.stopButton.isHidden = false
        controllView.playButton.isHidden = true
        playBeginSpeech()
    }
    
    @objc func stopTapped() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        eventTime = 0
        navigationItem.title = "Speed Timer"
        controllView.stopButton.isHidden = true
        controllView.resetButton.isHidden = false
        controllView.eventTime.isEnabled = true
        controllView.eventType.isEnabled = true
    }
}

// Extension speech

extension SpeedTimerViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if timer == nil && count == 0 {
            clickButton.isUserInteractionEnabled = true
            setupTimer()
        }
    }
}
