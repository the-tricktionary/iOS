//
//  SpeedTimerViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 17/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SpeedTimerViewController: MenuItemViewController {
    
    // MARK: Variables
    
    fileprivate let controllView: ControllView = ControllView()
    fileprivate let clickButton: UIButton = UIButton()
    fileprivate let countLabel: UILabel = UILabel()
    fileprivate let impact: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator()
    fileprivate var timer: Timer?
    fileprivate let timePicker: UIPickerView = UIPickerView()
    fileprivate let toolBar: UIToolbar = UIToolbar()
    
    fileprivate var eventTime: Float = 0.0
    fileprivate var count: Int = 0

    fileprivate var usedTime: Int = 30
    
    var viewModel: SpeedTimerViewModel
    
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
        view.addSubview(timePicker)
        view.addSubview(controllView)
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
        
        timePicker.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        timePicker.dataSource = self
        timePicker.delegate = self
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(setTime))
//        let spaceTool = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        toolBar.setItems([spaceTool, doneButton], animated: true)
//        toolBar.barTintColor = .white
//        toolBar.tintColor = UIColor.red
//        toolBar.sizeToFit()
//        toolBar.isUserInteractionEnabled = true
        timePicker.isHidden = true
        
        controllView.eventTime.text = timeFormatted(usedTime)
        
        if timer == nil {
            controllView.stopButton.isHidden = true
        }
        
        controllView.resetButton.isUserInteractionEnabled = true
        controllView.resetButton.addTarget(self, action: #selector(resetCount), for: .touchDown)
        
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
        
        timePicker.snp.makeConstraints { (make) in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(300)
            make.bottom.equalTo(view)
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
        count += 1
        countLabel.text = "\(count)"
        
    }
    
    @objc func timePickerTapped() {
        timePicker.isHidden = !timePicker.isHidden
        print("TAPPED TIME PICKER")
    }
    
    @objc func eventPickerTapped() {
        print("EVENT PICEKR TAPPED")
    }
    
    @objc func tick() {
        eventTime += 0.1
        if Int(eventTime) == 10 {
            let utterance = AVSpeechUtterance(string: "\(count)")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            let synth = AVSpeechSynthesizer()
            synth.speak(utterance)
            impact.impactOccurred()
        }
        title = "\(timeFormatted(Int(eventTime)))"
        if Int(eventTime) == usedTime {
            eventTime = 0.0
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func resetCount() {
        count = 0
        countLabel.text = "\(count)"
    }
    
//    @objc func setTime() {
//        print("SETOVANO")
//        timePicker.isHidden = true
//        timePicker.endEditing(true)
//    }
}


// Extensions TimePicker

extension SpeedTimerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.timeFormatted(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        usedTime = viewModel.times[row]!
        controllView.eventTime.text = viewModel.timeFormatted(row)
        print("Selected \(viewModel.times[row])")
    }
}
