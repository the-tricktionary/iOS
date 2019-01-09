//
//  BaseNavigationController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 09/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    
    // MARK: Variables
    
    // MARK: Life cycles
    
    init(contentViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.present(contentViewController, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = UIColor.red
        navigationBar.isTranslucent = false
    }
}
