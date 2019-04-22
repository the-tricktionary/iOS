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
    
    // MARK: Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = Color.bar
        navigationController?.navigationBar.isTranslucent = false

        
        let menuButton = MMDrawerBarButtonItem(target: self, action: #selector(menuButtonTapped))
        navigationItem.leftBarButtonItem = menuButton

    }
    
    // MARK: Public
    
    func errorAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
