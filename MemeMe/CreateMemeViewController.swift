//
//  CreateMemeViewController.swift
//  MemeMe1
//
//  Created by Frank Feng on 22/01/20.
//  Copyright © 2020 vend. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CreateMemeViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Items initialization
    // MARK: TopToolBarItems
    private var topToolBar = UIToolbar()
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    private lazy var shareButton: UIBarButtonItem = {
        let b = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMemedImage))
        b.style = .plain
        return b
    }()
    private lazy var cancelButton: UIBarButtonItem = {
        let b = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEdit))
        b.style = .plain
        return b
    }()
    
    
    // MARK: BottomToolBarItems
    private var bottomToolBar = UIToolbar()
    private lazy var pickButtom: UIBarButtonItem = {
        let b = UIButton(frame: .zero)
        b.setTitle("Album", for: .normal)
        b.setTitleColor(.blue, for: .normal)
        b.addTarget(self, action: #selector(pickAnImageFromAlbum), for: .touchUpInside)
        let bi = UIBarButtonItem(customView: b)
        bi.style = .plain
        return bi
    }()
    
    private var cameraButton: UIBarButtonItem = {
        let b = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(pickAnImageFromCamera))
        b.style = .plain
        return b
    }()
    
    // MARK: ImageViewItems
    private var imageView: UIImageView = {
        let i = UIImageView(frame: .zero)
        i.backgroundColor = .black
        i.contentMode = .scaleAspectFit
        return i
    }()
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .equalSpacing
        return stack
    }()
    private var topTextField = UITextField()
    private var bottomTextField = UITextField()
    private let topTextFieldPlaceHolder = "TOP"
    private let bottomTextFieldPlaceHolder = "BOTTOM"
    
    // MARK: ToolBarConstraints
    private var topToolBarHeightConstraint: Constraint?
    private var bottomToolBarHeightConstraint: Constraint?
    
    private var keyboardHeight: CGFloat = 0
    
    // MARK: TextField style settings
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -4.0
    ]
    
    // MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextField(topTextField, topTextFieldPlaceHolder)
        setTextField(bottomTextField, bottomTextFieldPlaceHolder)
        setToolBar(toolBar: topToolBar, items: [shareButton, flexibleSpace, cancelButton])
        setToolBar(toolBar: bottomToolBar, items: [flexibleSpace, cameraButton, flexibleSpace, pickButtom, flexibleSpace])
        updateShareButton()
        view.backgroundColor = .white
        
        view.addSubview(topToolBar)
        view.addSubview(imageView)
        view.addSubview(bottomToolBar)
        view.addSubview(textStackView)
        
        textStackView.addArrangedSubview(topTextField)
        textStackView.addArrangedSubview(bottomTextField)
        
        topToolBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            topToolBarHeightConstraint = make.bottom.equalTo(topToolBar.snp.top).constraint
        }
        
        bottomToolBar.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            bottomToolBarHeightConstraint = make.bottom.equalTo(bottomToolBar.snp.top).constraint
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(topToolBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomToolBar.snp.top)
        }
        
        textStackView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(imageView)
        }
        
        showToolbars(shouldShow: true)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    private func setToolBar(toolBar: UIToolbar, items: [UIBarButtonItem]) {
        toolBar.setItems(items, animated: false)
        toolBar.sizeToFit()
        toolBar.center = CGPoint(x: view.frame.width/2, y: 0)
        toolBar.backgroundColor = .darkGray
    }
    
    private func setTextField(_ textField: UITextField, _ defaultText: String) {
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.autocapitalizationType = .allCharacters
        textField.borderStyle = .none
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 10.0
    }
    
    func showToolbars(shouldShow: Bool) {
        topToolBar.isHidden = shouldShow == false
        bottomToolBar.isHidden = shouldShow == false
        shouldShow ? topToolBarHeightConstraint?.deactivate() : topToolBarHeightConstraint?.activate()
        shouldShow ? bottomToolBarHeightConstraint?.deactivate() : bottomToolBarHeightConstraint?.activate()
    }
    
    func updateShareButton() {
        shareButton.isEnabled = imageView.image != nil
    }
    
    @objc func cancelEdit() {
        /// Reset everything
        imageView.image = nil
        topTextField.text = topTextFieldPlaceHolder
        bottomTextField.text = bottomTextFieldPlaceHolder
        updateShareButton()
        self.dismiss(animated: true)
    }
    
    // MARK: - Notification Observers
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        /// Remove all the observers
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard Methods
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: - Image Picking
    @objc func pickAnImageFromAlbum(_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    @objc func pickAnImageFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }
    
    private func presentImagePickerWith(sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
    
    // MARK: - Meme Methods
    func generateMemedImage() -> UIImage {
        
        // Hide toolbars
        showToolbars(shouldShow: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbars
        showToolbars(shouldShow: true)
        
        return memedImage
    }
    
    func save(_ memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        Memes.memes.append(meme)
    }
    
    @objc func shareMemedImage() {
        let memedImage = generateMemedImage()
        let v = UIActivityViewController.init(activityItems: [memedImage], applicationActivities: nil)
        v.completionWithItemsHandler = { [weak self]
            (activity, success, items, error) in
            guard let this = self else { return }
            if success == true {
                this.save(memedImage)
                this.dismiss(animated: true)
            }
        }
        present(v, animated: true)
    }
}

extension CreateMemeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == topTextFieldPlaceHolder || textField.text == bottomTextFieldPlaceHolder {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            if textField == topTextField {
                textField.text = topTextFieldPlaceHolder
            } else {
                textField.text = bottomTextFieldPlaceHolder
            }
        }
        return view.endEditing(true)
    }
}

extension CreateMemeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        updateShareButton()
        picker.dismiss(animated: true, completion: nil)
    }
}
