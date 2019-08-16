//
//  SidePanelViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 10/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn
import MMDrawerController

public protocol SidePanelViewControllerDelegate {
    func didSelectMenuItem(viewController: UIViewController)
}

class SidePanelViewController: BaseViewController {
    
    // MARK: Variables
    
    var tableView: UITableView = UITableView()
    
    var delegate: SidePanelViewControllerDelegate?
    
    // MARK: Life cycles
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        delegate = self
        view.backgroundColor = UIColor.red
        
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.red
        tableView.dataSource = self
        tableView.delegate = self
        
        setupViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    // MARK: Public
    
    func openInstagram() {
        let url: URL? = URL(string: Constatnts.instagramApp)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(NSURL(string: Constatnts.instagram)! as URL)
        }
    }
}

extension SidePanelViewController: SidePanelViewControllerDelegate {
    func didSelectMenuItem(viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        let drawerController = UIApplication.shared.keyWindow?.rootViewController as? MMDrawerController
        
        drawerController?.centerViewController.present(navigationController, animated: true, completion: {
            drawerController?.closeDrawer(animated: false, completion: { (_) in
                
            })
        })
    }
}
