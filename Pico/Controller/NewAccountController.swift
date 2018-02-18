//
//  NewAccountController.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import LBTAComponents
import UIKit

class NewAccountController: DatasourceController, UITextFieldDelegate {
    static var own = NewAccountController()
    
    lazy var platformTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Social Media Platform (e.g. Snapchat)"
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .words
        tf.returnKeyType = .done
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            // Disables the password autoFill accessory view.
            tf.textContentType = UITextContentType("")
        }
        return tf
    }()
    
    lazy var usernameTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Your Platform Username"
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .words
        tf.returnKeyType = .done
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            // Disables the password autoFill accessory view.
            tf.textContentType = UITextContentType("")
        }
        return tf
    }()
    
    let doneButton:UIButton = {
        let imageView = UIButton()
        imageView.setImage(#imageLiteral(resourceName: "check").withRenderingMode(.alwaysOriginal), for: .normal)
        imageView.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return imageView
    }()
    
    func buttonPressed(){
        if !(platformTextField.text?.isEmpty)! && !(usernameTextField.text?.isEmpty)!{
            var account = Account(accountKey: platformTextField.text!, username: usernameTextField.text!, toggled: true)
            myCache.currentCache.accounts.append(account)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = ThemeColors.CALM_BLUE//ThemeColor.whitish
        collectionView?.showsVerticalScrollIndicator = false
        setupNavigationBarItems()
        collectionView?.allowsMultipleSelection = true
        
        view.addSubview(platformTextField)
        platformTextField.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 50, leftConstant: view.frame.width/2-view.frame.width/3, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width*2/3, heightConstant: 80)
        
        view.addSubview(usernameTextField)
        usernameTextField.anchor(platformTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: view.frame.width/2-view.frame.width/3, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width*2/3, heightConstant: 80)
        
        view.addSubview(doneButton)
        doneButton.anchor(usernameTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: view.frame.width/2-50, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        NewAccountController.own = self
    }
    
    var userProfileButton = UIButton()
    
    func setupNavigationBarItems(){
        var calendarLabel = UILabel()
        calendarLabel.text = "Add Account"
        calendarLabel.textColor = .white//ThemeColor.whitish
        calendarLabel.font = UIFont.boldSystemFont(ofSize: 25)
        navigationItem.titleView = calendarLabel
        
        let backButton = UIButton(type: .system)
        backButton.setImage(#imageLiteral(resourceName: "x").withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView:backButton)
        
        navigationController?.navigationBar.barTintColor = .red//ThemeColor.red
        let bounds = self.navigationController!.navigationBar.bounds
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height*1.5)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func handleKeyboardNotification(notification:Notification){
        if let userInfo = notification.userInfo{
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue!
            
            let isKeyShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            if isKeyShowing{
                
            }else{
                
            }
        }
    }
    
    func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {      //Pressing done/enter after text
        self.view.endEditing(true)
        dismissKeyboard()
        
        return false
    }
    
    func dismissKeyboard(){                                             //Puts keyboard back down
        if let text:String = platformTextField.text{
            if let num = Int(text){
                if num >= 0{
                    platformTextField.resignFirstResponder()
                }
            }else if text == ""{
                platformTextField.resignFirstResponder()
                
            }
            
        }
        
        if let text:String = usernameTextField.text{
            if let num = Int(text){
                if num >= 0{
                    usernameTextField.resignFirstResponder()
                }
            }else if text == ""{
                usernameTextField.resignFirstResponder()
            }
        }
    }
    
}



