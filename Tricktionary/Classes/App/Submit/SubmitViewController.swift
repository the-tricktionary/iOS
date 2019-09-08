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
import ReactiveCocoa
import FirebaseAuth
import SkeletonView

class SubmitViewController: BaseCenterViewController, UIPickerViewDelegate {
    
    // MARK: Variables
    
    let descriptionLabel: UILabel = UILabel()
    let videoPlayer: AVPlayerViewController = AVPlayerViewController()
    
    let trickNameTextField: UITextField = UITextField()
    let trickDescriptionTextField: UITextField = UITextField()
    let saveButton: GradientButton = GradientButton()
    let typeTextField: UITextField = UITextField()
    
    let asocPicker: UIPickerView = UIPickerView()
    let typePicker: UIPickerView = UIPickerView()
    
    private lazy var placeholder: UIView = {
        let placeholder = UIView()
        placeholder.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        self.view.addSubview(placeholder)
        placeholder.layer.zPosition = 999
        placeholder.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        return placeholder
    }()
    
    internal let scrollView: UIScrollView = UIScrollView()
    internal let contentView: UIView = UIView()
    internal var viewModel: SubmitViewModel
    
    // MARK: Life cycle
    
    init(viewModel: SubmitViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(scrollView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(videoPlayer.view)
        contentView.addSubview(trickNameTextField)
        contentView.addSubview(trickDescriptionTextField)
        contentView.addSubview(typeTextField)
        contentView.addSubview(saveButton)
        scrollView.addSubview(contentView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        activityIndicatorView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        view.backgroundColor = .white
        
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
        
        scrollView.isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        
        scrollView.isScrollEnabled = true
        
        trickNameTextField.placeholder = "Trick name"
        trickNameTextField.delegate = self
        trickNameTextField.isUserInteractionEnabled = true
        trickNameTextField.reactive.continuousTextValues.observeValues { (value) in
            self.viewModel.metadata.trickName = value ?? ""
            self.enableSave()
        }
        
        trickDescriptionTextField.placeholder = "Description (can add your insta name)"
        trickDescriptionTextField.delegate = self
        trickDescriptionTextField.isUserInteractionEnabled = true
        trickDescriptionTextField.reactive.continuousTextValues.observeValues { (value) in
            self.viewModel.metadata.desc = value ?? ""
            self.enableSave()
        }
        
        asocPicker.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        asocPicker.dataSource = self
        asocPicker.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.red.withAlphaComponent(0.5)
        toolBar.sizeToFit()
        
        let doneTimeButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneTimeButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        typeTextField.isUserInteractionEnabled = true
        typeTextField.placeholder = "Trick type"
        typeTextField.inputView = asocPicker
        typeTextField.inputAccessoryView = toolBar
        typeTextField.reactive.continuousTextValues.observeValues { (value) in
            self.viewModel.metadata.trickType = value ?? ""
            self.enableSave()
        }
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.isUserInteractionEnabled = true
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        initVideoPlayer()
        initFormView()
        initNavigationItems()
        
        setupViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            placeholder.isHidden = false
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            placeholder.isHidden = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(view)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(20)
            make.leading.equalTo(contentView).inset(16)
            make.trailing.equalTo(contentView).inset(16)
        }
        
        videoPlayer.view.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(UIScreen.main.bounds.size.height / 2)
        }
        
        let height = ((UIScreen.main.bounds.size.height - 200) / 2) / 5
        
        trickNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(videoPlayer.view.snp.bottom)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(height)
        }
        
        trickDescriptionTextField.snp.makeConstraints { (make) in
            make.top.equalTo(trickNameTextField.snp.bottom)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(height)
        }
        
        typeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(trickDescriptionTextField.snp.bottom)
            make.leading.equalTo(contentView).inset(16)
            make.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(height)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(typeTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(height)
            make.bottom.equalTo(contentView)
        }
    }
    
    fileprivate func initVideoPlayer() {
        videoPlayer.view.isHidden = true
        videoPlayer.player = nil
    }
    
    fileprivate func initFormView() {
        trickDescriptionTextField.isHidden = true
        trickNameTextField.isHidden = true
        typeTextField.isHidden = true
        saveButton.isHidden = true
        descriptionLabel.isHidden = false
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
        trickDescriptionTextField.isHidden = false
        trickNameTextField.isHidden = false
        typeTextField.isHidden = false
        saveButton.isHidden = false
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor.gray
        descriptionLabel.isHidden = true
    }
    
    fileprivate func setupVideoFormControll() {
        let canceButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        
        navigationItem.rightBarButtonItem = canceButton
    }
    
    fileprivate func enableSave() {
        saveButton.isEnabled = viewModel.metadata.isValid()
        if saveButton.isEnabled {
            saveButton.backgroundColor = Color.bar
        } else {
            saveButton.backgroundColor = UIColor.gray
        }
    }
    
    // MARK: User action
    
    @objc func cancelButtonTapped() {
        initVideoPlayer()
        initFormView()
        initNavigationItems()
    }
    
    @objc func donePicker() {
        typeTextField.text = viewModel.types[asocPicker.selectedRow(inComponent: 0)]
        typeTextField.endEditing(true)
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
                imagePickerController.cameraCaptureMode = .video
                imagePickerController.allowsEditing = true
                imagePickerController.videoQuality = .typeIFrame1280x720
                
                
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
    
    @objc func saveButtonTapped() {
        activityIndicatorView.startAnimating()
        viewModel.uploadVideo(success: {
            self.activityIndicatorView.stopAnimating()
            self.initVideoPlayer()
            self.initFormView()
            self.initNavigationItems()
        }) { (error) in
            self.activityIndicatorView.stopAnimating()
            self.errorAlert(title: "Error", message: error)
        }
    }
    
    // MARK: Keyboard
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height

        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension SubmitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let mediaURL = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? NSURL
        
        if let media = mediaURL {
            viewModel.videoURL = media.absoluteURL!
            setupVideoPlayer(with: media.absoluteURL!)
            setupVideoFormControll()
            setupFormView()
            videoPlayer.player?.play()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// Exntension text field delegate

extension SubmitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
