//
//  MenuViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 09/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
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
    var centerViewController: MenuItemViewController!
    var currentState: SlideOutState = .collapsed
    var menuViewController: SidePanelViewController?
    var centerPanelExpandedOffset: CGFloat = 120
    
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: Life cycle
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = TricksViewController(viewModel: TricksViewModel())
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChild(centerNavigationController)
        
        centerNavigationController.didMove(toParent: self)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped))
    }
    
    // MARK: Private
    
    fileprivate func addChildSidePanelController(_ sidePanelController: UIViewController) {
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
    }
    
    fileprivate func animateCenterPanel(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                       options: .curveEaseInOut, animations: {
                        self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    fileprivate func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    fileprivate func setupCenterNavigationController(_ rootController: UIViewController) {
        
    }
    
    // MARK: User action
    
    @objc func viewDidTapped() {
        if currentState == .expanded {
            closeMenu()
        }
    }
}

// MARK: Extension

extension MenuManagerViewController: MenuItemDelegate {
    func toggleMenu() {
        let notAlreadyExpanded = currentState == .collapsed
        if notAlreadyExpanded {
            addPanelViewController()
            centerNavigationController.view.addGestureRecognizer(tapGestureRecognizer)
        } else {
            centerNavigationController.view.removeGestureRecognizer(tapGestureRecognizer!)
        }
        animateMenu(shouldExpand: notAlreadyExpanded)
    }
    
    func closeMenu() {
        let expanded = (currentState == .expanded)
        guard expanded else {
            return
        }
        centerNavigationController.view.removeGestureRecognizer(tapGestureRecognizer!)
        animateMenu(shouldExpand: !expanded)
    }
    
    func addPanelViewController() {
        if menuViewController == nil {
            menuViewController = SidePanelViewController()
            menuViewController!.delegate = self
            addChildSidePanelController(menuViewController!)
        }
        
    }
    
    func animateMenu(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .expanded
            showShadowForCenterViewController(shouldShowShadow: shouldExpand)
            animateCenterPanel(targetPosition: centerNavigationController.view.bounds.width - centerPanelExpandedOffset)
        } else {
            animateCenterPanel(targetPosition: 0) { finished in
                self.currentState = .collapsed
                self.showShadowForCenterViewController(shouldShowShadow: shouldExpand)
                
                self.menuViewController?.view.removeFromSuperview()
                if let menuVC = self.menuViewController {
                    menuVC.delegate = nil
                }
                self.menuViewController = nil
            }
        }
    }
}

// MARK: Extension

extension MenuManagerViewController: SidePanelViewControllerDelegate {
    func didSelectMenuItem(viewController: UIViewController) {
        toggleMenu()
        let vc = viewController as! MenuItemViewController
        vc.view.setNeedsLayout()
        vc.delegate = self
        centerViewController.navigationController?.pushViewController(vc, animated: false)
    }
}
