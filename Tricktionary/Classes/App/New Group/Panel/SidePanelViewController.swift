//
//  SidePanelViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 10/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

public protocol SidePanelViewControllerDelegate {
    func didSelectMenuItem(viewController: UIViewController)
}

class SidePanelViewController: UIViewController {
    
    // MARK: Variables
    
    fileprivate let loginItem: MenuItemView = MenuItemView()
    fileprivate let tricksItem: MenuItemView = MenuItemView()
    
    var delegate: SidePanelViewControllerDelegate?
    
    // MARK: Life cycles
    
    override func loadView() {
        super.loadView()
        view.addSubview(loginItem)
        view.addSubview(tricksItem)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        
        loginItem.title.text = "Login"
        loginItem.isUserInteractionEnabled = true
        loginItem.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(loginTapped)))
        
        tricksItem.title.text = "Tricks"
        tricksItem.isUserInteractionEnabled = true
        tricksItem.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                            action: #selector(tricksTapped)))
        
        setupViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        
        tricksItem.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(40)
        }
        
        loginItem.snp.makeConstraints { (make) in
            make.top.equalTo(tricksItem.snp.bottom).offset(1)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(tricksItem.snp.height)
        }
    }
    
    // MARK: User actions
    
    @objc func loginTapped() {
        delegate?.didSelectMenuItem(viewController: LoginViewController())
    }
    
    @objc func tricksTapped() {
        delegate?.didSelectMenuItem(viewController: TricksViewController(viewModel: TricksViewModel()))
    }
}
