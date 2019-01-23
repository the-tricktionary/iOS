//
//  ControllView.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 20/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class ControllView: UIView {
    
    // MARK: Variables
    
    let playButton: UIButton = UIButton()
    let stopButton: UIButton = UIButton()
    let resetButton: UIButton = UIButton()
    let eventTime: UITextField = UITextField()
    let eventType: UITextField = UITextField()
    
    // MARK: Life cycles
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
        setupViewConstraints()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Privates
    
    fileprivate func setupSubviews() {
        addSubview(playButton)
        addSubview(stopButton)
        addSubview(resetButton)
        addSubview(eventTime)
        addSubview(eventType)
    }
    
    fileprivate func setup() {
        playButton.setImage(UIImage(named: "playButton"), for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.imageView?.tintColor = UIColor.black
        
        stopButton.setImage(UIImage(named: "stopButton"), for: .normal)
        stopButton.imageView?.contentMode = .scaleAspectFit
        stopButton.imageView?.tintColor = UIColor.black
        
        resetButton.setImage(UIImage(named: "resetButton"), for: .normal)
        resetButton.imageView?.contentMode = .scaleAspectFit
        resetButton.imageView?.tintColor = UIColor.black
        
        eventTime.font = UIFont.systemFont(ofSize: 22)
        eventTime.textColor = UIColor.gray
        eventTime.textAlignment = .center
        
        eventType.font = UIFont.systemFont(ofSize: 22)
        eventType.textColor = UIColor.gray
        eventType.textAlignment = .center
    }
    
    fileprivate func setupViewConstraints() {
        
        let width = (UIScreen.main.bounds.width - 100) / 2
        
        playButton.snp.makeConstraints { (make) in
            make.size.equalTo(40)
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(10)
        }
        
        resetButton.snp.makeConstraints { (make) in
            make.size.equalTo(40)
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(10)
        }
        
        stopButton.snp.makeConstraints { (make) in
            make.size.equalTo(40)
            make.centerY.equalTo(self)
            make.trailing.equalTo(resetButton)
        }
        
        eventTime.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.centerY.equalTo(self)
            make.leading.equalTo(playButton.snp.trailing).offset(5)
            make.width.equalTo(width)
        }
        
        eventType.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.centerY.equalTo(self)
            make.leading.equalTo(eventTime.snp.trailing)
            make.width.equalTo(width)
        }
    }
}
