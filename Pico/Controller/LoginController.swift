//
//  LoginController.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents
import Firebase

class LoginController: DatasourceController, UITextFieldDelegate {
    
    static var own:LoginController = LoginController()
    
    let inputContainerView:UIView = {                   //Box inside of text boxes
        let view = UIView()
        view.backgroundColor = ThemeColors.DARK_GRAY
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //Dark blue, Navy, gray, dark gray, orange, red, salmon, green, light green main, dark green, blue green, lime green, olive green
    lazy var loginRegisterButton: UIButton = {          //Login Button
        let button = UIButton(type: .system)
        button.backgroundColor = ThemeColors.DARK_BLUE
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLoginOrRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var nameTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            // Disables the password autoFill accessory view.
            tf.textContentType = UITextContentType("")
        }
        return tf
    }()
    
    let nameSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = .gray//ThemeColor.lightGray
        return view
    }()
    
    lazy var emailTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.delegate = self
        if #available(iOS 11, *) {
            // Disables the password autoFill accessory view.
            tf.textContentType = UITextContentType("")
        }
        return tf
    }()
    
    func handleKeyboardNotification(notification:Notification){
        if let userInfo = notification.userInfo{
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue!
            
            let isKeyShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            if isKeyShowing{
                
            }else{
                
            }
        }
    }
    
    let emailSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = .gray//ThemeColor.lightGray
        return view
    }()
    
    lazy var passwordTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password (at least 6 characters)"
        tf.isSecureTextEntry = true
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.delegate = self
        if #available(iOS 11, *) {
            // Disables the password autoFill accessory view.
            tf.textContentType = UITextContentType("")
        }
        return tf
    }()
    
    lazy var loginRegisterSegmentedControl:UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.tintColor = .white//ThemeColor.whitish
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleRegisterLoginChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginOrRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        }else{
            handleSignIn()
        }
    }
    
    func handleLogin(){
        guard let email2 = emailTextField.text, let password2 = passwordTextField.text else{
            return
        }
        
        Auth.auth().signIn(withEmail: email2, password: password2, completion: {
            (user,error) in
            if error != nil{
                print(error)
                return
            }
            
            LoginController.own.dismiss(animated: true, completion: nil)
        })
    }
    
    func handleSignIn(){
        guard let email2 = emailTextField.text, let password2 = passwordTextField.text, let name2 = nameTextField.text else{
            return
        }
        
        Auth.auth().createUser(withEmail: email2, password: password2, completion: {(user:User?, error) in
            if error != nil{
                print(error)
                return
            }
            
            guard let uid = user?.uid else{
                return
            }
            
            //successfully authenticated user
            let ref = Database.database().reference(fromURL: "https://pico-be4e4.firebaseio.com/")
            let usersReference = ref.child("users").child(uid) //opens new directory under unique User ID
            
            let values = ["name":name2,"email":email2]
            usersReference.updateChildValues(values, withCompletionBlock: { (err,ref) in
                if err != nil{
                    print(err)
                    return
                }
                
                print("Saved user successfully into Firebase DB")
                LoginController.own.dismiss(animated: true, completion: nil)
                return
            })
        })
    }
    
    func handleRegisterLoginChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        nameTextFieldHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 50
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    var inputContainerViewHeightAnchor:NSLayoutConstraint?
    var nameTextFieldHeightAnchor:NSLayoutConstraint?
    
    override func viewDidLoad() {
        LoginController.own = self
        collectionView?.backgroundColor = ThemeColors.LIGHT_GREEN_MAIN
        
        let logo = UIImageView(image: #imageLiteral(resourceName: "icon"))              //Change to Pico picture
        view.addSubview(logo)
        logo.contentMode = .scaleAspectFill
        logo.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: view.frame.height/8, leftConstant: view.frame.width/3, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width/3, heightConstant: view.frame.width/3)
        
        view.addSubview(loginRegisterSegmentedControl)
        loginRegisterSegmentedControl.anchor(logo.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width-24, heightConstant: 30)
        
        view.addSubview(inputContainerView)
        inputContainerView.anchor(loginRegisterSegmentedControl.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width-24, heightConstant: 150)
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameTextField)
        nameTextField.anchor(inputContainerView.topAnchor, left: inputContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width-48, heightConstant: 50)
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 50)
        nameTextFieldHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameSeparatorView)
        nameSeparatorView.anchor(nameTextField.bottomAnchor, left: inputContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width-24, heightConstant: 1)
        
        inputContainerView.addSubview(emailTextField)
        emailTextField.anchor(nameSeparatorView.bottomAnchor, left: inputContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width-48, heightConstant: 50)
        
        inputContainerView.addSubview(emailSeparatorView)
        emailSeparatorView.anchor(emailTextField.bottomAnchor, left: inputContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width-24, heightConstant: 1)
        
        inputContainerView.addSubview(passwordTextField)
        passwordTextField.anchor(emailSeparatorView.bottomAnchor, left: inputContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width-48, heightConstant: 50)
        
        view.addSubview(loginRegisterButton)
        loginRegisterButton.anchor(inputContainerView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width-24, heightConstant: 50)
 
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
 
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard(){
        if let text:String = nameTextField.text{
            if let num = Int(text){
                if num >= 0{
                    nameTextField.resignFirstResponder()
                }
            }else if text == ""{
                nameTextField.resignFirstResponder()
            }
        }
        
        if let text:String = emailTextField.text{
            if let num = Int(text){
                if num >= 0{
                    emailTextField.resignFirstResponder()
                }
            }else if text == ""{
                emailTextField.resignFirstResponder()
            }
        }
        
        if let text:String = passwordTextField.text{
            if let num = Int(text){
                if num >= 0{
                    passwordTextField.resignFirstResponder()
                }
            }else if text == ""{
                passwordTextField.resignFirstResponder()
            }
        }
    }
    
}
