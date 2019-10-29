//
//  ProfileViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 05/05/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: BaseDrawerViewController {
    
    // MARK: Variables
    
    var viewModel: ProfileViewModelType
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let tableView = UITableView()
    
    // User preview
    private let userPreview: UIView = UIView()
    private let profilePhoto: UIImageView = UIImageView()
    private let userName: UILabel = UILabel()
    private let userEmail: UILabel = UILabel()
    private let tricksTotal: UILabel = UILabel()
    
    let stackView = UIStackView()
    
    // MARK: Life cycles

    init(viewModel: ProfileViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        userPreview.addSubview(profilePhoto)
        userPreview.addSubview(stackView)
        contentView.addSubview(userPreview)
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "User profile"
        
        setupViews()
        bind()
        setupViewConstraints()
        viewModel.loadData()
    }
    
    // MARK: Private
    
    private func setupViews() {
        profilePhoto.layer.cornerRadius = 25
        profilePhoto.clipsToBounds = true
        profilePhoto.backgroundColor = .lightGray
        
        userName.font = UIFont.boldSystemFont(ofSize: 16)
        userName.numberOfLines = 1
        userName.sizeToFit()
        
        userEmail.font = UIFont.systemFont(ofSize: 16)
        userEmail.numberOfLines = 1
        userEmail.sizeToFit()
        
        tricksTotal.font = UIFont.systemFont(ofSize: 16)
        tricksTotal.numberOfLines = 1
        tricksTotal.sizeToFit()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(userName)
        stackView.addArrangedSubview(userEmail)
        stackView.addArrangedSubview(tricksTotal)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func bind() {
        viewModel.profileInfo.producer.startWithValues { [weak self] info in
            self?.userName.text = info.name
            self?.userEmail.text = info.email
            if let photo = info.photo {
                self?.profilePhoto.image = UIImage(data: photo)
            } else {
                self?.profilePhoto.image = nil
            }
        }

        viewModel.tricksInfo.producer.startWithValues { tricks in
            self.tricksTotal.text = "Completed tricks: \(tricks.count)"
        }

        viewModel.trickList.producer.startWithValues { tricks in
            self.tableView.reloadData()
        }
    }
    
    private func setupViewConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(view)
        }
        
        let sizeOfPhoto = UIScreen.main.bounds.size.width / 4
        
        userPreview.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).inset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView)
            make.height.equalTo(sizeOfPhoto)
        }
        
        profilePhoto.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.equalTo(view).inset(16)
            make.size.equalTo(sizeOfPhoto)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalTo(userPreview)
            make.leading.equalTo(profilePhoto.snp.trailing).offset(10)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view)
        }
    }
    
}
