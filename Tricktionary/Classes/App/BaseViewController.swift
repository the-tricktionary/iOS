//
//  BaseViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 04/03/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import MMDrawerController

class BaseViewController: UIViewController {
    
    // MARK: Variables
    
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    var centerContainer: MMDrawerController?
    // MARK: Life cycles
    
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false

        
        centerContainer = UIApplication.shared.keyWindow?.rootViewController as? MMDrawerController
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        activityIndicatorView.layer.zPosition = 999
        activityIndicatorView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        setupActivitiIndicatorViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupActivitiIndicatorViewConstraints() {
        activityIndicatorView.snp.makeConstraints { (make) in
            make.size.equalTo(view)
            make.center.equalTo(view)
        }
    }
    
    // MARK: User actions
    
    @objc func menuButtonTapped() {
        centerContainer?.toggle(MMDrawerSide.left, animated: true, completion: { (_) in
            
        })
    }
}
