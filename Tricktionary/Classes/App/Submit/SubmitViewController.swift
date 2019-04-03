//
//  SubmitViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 02/04/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class SubmitViewController: BaseCenterViewController {
    
    // MARK: Variables
    
    let descriptionLabel: UILabel = UILabel()
    let videoPlayer: AVPlayerViewController = AVPlayerViewController()
    
    let formView: SubmitFormView = SubmitFormView()
    
    // MARK: Life cycle
    
    override func loadView() {
        super.loadView()
        view.addSubview(descriptionLabel)
        view.addSubview(videoPlayer.view)
        view.addSubview(formView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.background
        
        title = "Submit trick"
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        
        var description = "\u{2022} You may submit videos of either single trick to be included in the Tricktionary, or you may submit a video to be featured on our instagram page @jumpropetricktionary\n\n"
        description += "\u{2022} Videos can be of any jump rope trick, whether the trick is already in the Tricktionary or not\n\n"
        description += "\u{2022} Please record your video in landscape\n\n"
        description += "\u{2022} Your video can be no larger than 100Mb\n\n"
        description += "\u{2022} If you are able to record in slowmotion please do!\n\n"
        description += "\u{2022} Please keep your recording as stable as possible, or set up your camera\n\n"
        description += "\u{2022} Try to find a plain background that contrasts the color of your rope\n\n"
        
        descriptionLabel.text = description
        
        formView.backgroundColor = Color.background
        
        initVideoPlayer()
        initFormView()
        initNavigationItems()
        
        setupViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.leading.equalTo(view).inset(16)
            make.trailing.equalTo(view).inset(16)
        }
        
        videoPlayer.view.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(UIScreen.main.bounds.size.height / 2)
        }
        
        formView.snp.makeConstraints { (make) in
            make.top.equalTo(videoPlayer.view.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    fileprivate func initVideoPlayer() {
        videoPlayer.view.isHidden = true
        videoPlayer.player = nil
        videoPlayer.view.addGestureRecognizer(endEditingGesture!)
    }
    
    fileprivate func initFormView() {
        formView.isHidden = true
    }
    
    fileprivate func initNavigationItems() {
        navigationItem.rightBarButtonItems = nil
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    fileprivate func setupVideoPlayer(with url: URL) {
        let player = AVPlayer(url: url)
        videoPlayer.view.isHidden = false
        videoPlayer.player = player
    }
    
    fileprivate func setupFormView() {
        formView.isHidden = false
    }
    
    fileprivate func setupVideoFormControll() {
        let canceButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [canceButton, saveButton]
    }
    
    // MARK: User action
    
    @objc func cancelButtonTapped() {
        initVideoPlayer()
        initFormView()
        initNavigationItems()
    }
    
    @objc func addButtonTapped() {
        let actionSheet = UIAlertController(title:  "Pick video", message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.red
        
        actionSheet.addAction(UIAlertAction(title: "From gallery", style: .default, handler:{ (nil) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.mediaTypes = ["public.movie"]
                imagePickerController.delegate = self
                
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error",
                                                        message: "Some error", preferredStyle: .alert)
                alertController.view.tintColor = UIColor.red
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion:   nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "From camera", style: .default, handler: { (nil) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.mediaTypes = ["public.movie"]
                imagePickerController.showsCameraControls = true
                
                imagePickerController.delegate = self
                imagePickerController.modalPresentationStyle = .fullScreen
                
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error",
                                                        message: "Some error", preferredStyle: .alert)
                alertController.view.tintColor = UIColor.red
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion:   nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension SubmitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let mediaURL = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? NSURL
        
        if let media = mediaURL {
            setupVideoPlayer(with: media.absoluteURL!)
            setupVideoFormControll()
            setupFormView()
            videoPlayer.player?.play()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
