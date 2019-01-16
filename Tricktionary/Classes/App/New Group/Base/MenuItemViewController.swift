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
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "list"),
                                         style: .plain,
                                         target: self, action: #selector(menuTapped))
        navigationItem.leftBarButtonItem = menuButton
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        delegate?.closeMenu()
    }
    
    // MARK: User aciton
    
    @objc func menuTapped() {
        delegate?.toggleMenu()
    }
}