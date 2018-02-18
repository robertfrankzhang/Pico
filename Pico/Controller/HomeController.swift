//
//  HomeController.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents
import Firebase

class HomeController: DatasourceController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white//ThemeColor.whitish
        collectionView?.showsVerticalScrollIndicator = false
        setupNavigationBarItems()
        collectionView?.allowsMultipleSelection = true
    }
    
    var userProfileButton = UIButton()
    
    func setupNavigationBarItems(){
        var calendarLabel = UILabel()
        calendarLabel.text = "My Calendar"
        calendarLabel.textColor = .white//ThemeColor.whitish
        calendarLabel.font = UIFont.boldSystemFont(ofSize: 25)
        navigationItem.titleView = calendarLabel
        
        let signOutButton = UIButton(type: .system)
        signOutButton.setImage(#imageLiteral(resourceName: "signOut").withRenderingMode(.alwaysOriginal), for: .normal)
        signOutButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView:signOutButton)
        
        userProfileButton = UIButton(type: .system)
        userProfileButton.setImage(myCache.currentCache.profilePic.withRenderingMode(.alwaysOriginal), for: .normal)
        userProfileButton.imageView?.contentMode = .scaleAspectFill
        userProfileButton.translatesAutoresizingMaskIntoConstraints = false
        userProfileButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        userProfileButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        userProfileButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        userProfileButton.layer.cornerRadius = 15
        userProfileButton.layer.masksToBounds = true
        userProfileButton.addTarget(self, action: #selector(viewProfile), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView:userProfileButton)
        
        navigationController?.navigationBar.barTintColor = .red//ThemeColor.red
        let bounds = self.navigationController!.navigationBar.bounds
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height*1.5)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func viewProfile(){
        let profileController = ProfileController()
        present(UINavigationController(rootViewController: profileController),animated:true,completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser == nil){
            print("no user")
            perform(#selector(signOut), with: nil, afterDelay: 0)
        }
    }
    
    func signOut(){
        let loginController = LoginController()
        //Signout
        do{
            try Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError)
        }
        //
        myCache.currentCache = Cache()
        present(loginController,animated:true,completion: nil)
        print("signed out")
    }
    
}

