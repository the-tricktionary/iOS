//
//  ProfileViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 05/05/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class ProfileViewController: BaseDrawerViewController {
    
    // MARK: Variables
    
    private var viewModel: ProfileViewModel
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    
    // User preview
    private let userPreview: UIView = UIView()
    private let profilePhoto: UIImageView = UIImageView()
    private let userName: UILabel = UILabel()
    private let userEmail: UILabel = UILabel()
    private let tricksTotal: UILabel = UILabel()
    
    let stackView = UIStackView()
    
    // MARK: Life cycles

    init(viewModel: ProfileViewModel) {
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
        
        scrollView.subviews.forEach { view in
            view.isSkeletonable = true
        }
        
        contentView.subviews.forEach { view in
            view.isSkeletonable = true
        }
        
        userName.isSkeletonable = true
        userEmail.isSkeletonable = true
        tricksTotal.isSkeletonable = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "User profile"
        profilePhoto.isSkeletonable = true
        userPreview.subviews.forEach { $0.isSkeletonable = true }
        
        setupViews()
        
        setupViewConstraints()
        
        view.subviews.forEach { view in
            view.isSkeletonable = true
        }
        fillData()
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
//        tricksTotal.text = "Completed tricks: \(10)"
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(userName)
        stackView.addArrangedSubview(userEmail)
        stackView.addArrangedSubview(tricksTotal)
        stackView.subviews.forEach { $0.isSkeletonable = true }
    }
    
    private func fillData() {

        self.userName.text = "hhhhhhhhhhhhhhhhhhhhh"
        self.userEmail.text = "hhhhhhhhhhhhhhhhhhh"
        self.tricksTotal.text = "hhhhhh"

        view.isSkeletonable = true
        view.showAnimatedSkeleton()
        stackView.showAnimatedSkeleton()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 2, animations: {
                if let imageData = self.viewModel.getUserPhotoURL() {
                    self.profilePhoto.image = UIImage(data: imageData)
                } else {
                    self.profilePhoto.image = UIImage(named: "signin")
                }
                
                let userInfo = self.viewModel.getUserInfo()
                
                self.userName.text = userInfo["name"] ?? "Unknown"
                self.userEmail.text = userInfo["email"] ?? "Unknown"
                self.tricksTotal.text = "Completed tricks: \(10)"
                self.view.hideSkeleton()
                self.stackView.hideSkeleton()
            })
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
    }
    
}
