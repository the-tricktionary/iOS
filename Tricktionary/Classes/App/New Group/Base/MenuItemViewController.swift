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
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(menuTapped))
        swipeRight.direction = .right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(menuClose))
        swipeLeft.direction = .left
        
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeLeft)
        
        becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            delegate?.toggleMenu()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        delegate?.closeMenu()
    }
    
    // MARK: User aciton
    
    @objc func menuTapped() {
        delegate?.toggleMenu()
    }
    
    @objc func menuClose() {
        delegate?.closeMenu()
    }
}
