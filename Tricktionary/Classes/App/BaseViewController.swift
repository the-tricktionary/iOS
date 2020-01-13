//
//  BaseViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 04/03/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import LifetimeTracker

class BaseViewController: UIViewController, LifetimeTrackable {
    
    // MARK: Variables
    
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)

    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "VC")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        trackLifetime()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycles

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
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
}
