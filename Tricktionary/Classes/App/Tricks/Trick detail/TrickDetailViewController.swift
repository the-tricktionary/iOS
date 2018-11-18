//
//  TrickDetailViewController.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class TrickDetailViewController: UIViewController {
    
    // MARK: Variables
    
    var viewModel: TrickDetailViewModel
    
    // MARK: Life cycles
    
    init(viewModel: TrickDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.trick.name!
        
        view.backgroundColor = UIColor.lightGray
    }
}
