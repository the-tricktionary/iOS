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
    var keyboardHeight = CurrentValueSubject<CGFloat, Never>(0)
    
    deinit {
        print("Cancel all of cancelables")
        disposable.forEach { $0.cancel() }
        unregisterObservers()
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
        registerObservers()
    }
    
    private func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func unregisterObservers() {
        
    }
    
    // MARK: Public
    
    func errorAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    // MARK: - Selectors
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            keyboardHeight.send(0)
        } else {
            keyboardHeight.send(keyboardViewEndFrame.height - view.safeAreaInsets.bottom)
        }
    }
}
