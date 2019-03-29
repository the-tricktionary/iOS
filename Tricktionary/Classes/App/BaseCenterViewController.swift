//
//  BaseCenterViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 29/03/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import MMDrawerController

class BaseCenterViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = Color.bar
        navigationController?.navigationBar.isTranslucent = false

        
        let menuButton = MMDrawerBarButtonItem(target: self, action: #selector(menuButtonTapped))
        navigationItem.leftBarButtonItem = menuButton

    }
}
