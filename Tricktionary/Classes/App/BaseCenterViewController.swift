//
//  BaseCenterViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 29/03/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import Combine

class BaseCenterViewController: BaseViewController {
    
    // MARK: Variables
    
    var disposable = Set<AnyCancellable>()
    
    deinit {
        print("Cancel all of cancelables")
        disposable.forEach { $0.cancel() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = Color.red
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationController?.navigationBar.barTintColor = Color.red
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }

        let backButton = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        backButton.tintColor = UIColor.flatYellow()
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        tabBarController?.tabBar.barTintColor = Color.red
        tabBarController?.tabBar.unselectedItemTintColor = .white
        tabBarController?.tabBar.tintColor = UIColor.flatYellow()
    }
    
    // MARK: Public
    
    func errorAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
