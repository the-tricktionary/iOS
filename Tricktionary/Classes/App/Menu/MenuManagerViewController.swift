//
//  MenuManagerViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 31/12/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

enum SlideOutState {
    case collapsed
    case expanded
}

class MenuManagerViewController: UIViewController {
    
    // MARK: Variables
    var centerNavigationController: UINavigationController!
    var centerViewController: UIViewController!
    var currentState: SlideOutState = .collapsed
    var menuViewController: MenuViewController = MenuViewController()
    var centerPanelExpandedOffset: CGFloat = 120
    
    // MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = TricksViewController(viewModel: TricksViewModel())
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        title = "Tricks"
        view.addSubview(centerNavigationController.view)
        addChild(centerNavigationController)
        
        centerNavigationController.didMove(toParent: self)
    }
}
