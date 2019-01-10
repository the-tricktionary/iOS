//
//  MenuItemViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 10/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

protocol MenuItemDelegate {
    func toggleMenu()
    func closeMenu()
    func addPanelViewController()
    func animateMenu(shouldExpand: Bool)
}

class MenuItemViewController: UIViewController {
    
    // MARK: Variables
    
    var delegate: MenuItemDelegate?
    
    // MARK: Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        delegate?.closeMenu()
    }
}
