//
//  BaseDrawerViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 12/06/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class BaseDrawerViewController: BaseViewController {
    
    // MARK: Variables
    
    var onClose: (() -> Void)?
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeButton = UIBarButtonItem(image: UIImage(named: "clear"), style: .plain, target: self, action: #selector(close))
        navigationItem.setLeftBarButtonItems([closeButton], animated: true)
    }
    
    @objc func close() {
        navigationController?.dismiss(animated: true, completion: onClose)
    }
}
