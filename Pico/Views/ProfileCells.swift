//
//  ProfileCells.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import LBTAComponents
import Firebase
import UIKit

class ProfileView:DatasourceCell{
    lazy var profileImage:UIImageView = {
        let view = UIImageView()
        view.image = myCache.currentCache.profilePic
        view.layer.cornerRadius = self.frame.width/5
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    var editIm:UIImageView = {
        let view = UIImageView()
        view.frame.size = CGSize(width:30,height:30)
        view.isUserInteractionEnabled = true
        view.image = #imageLiteral(resourceName: "edit")
        return view
    }()
    
    lazy var name:UILabel = {
        let label = UILabel()
        label.text = myCache.currentCache.firstName
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    lazy var descriptionLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Bio: \(myCache.currentCache.description)"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    override var datasourceItem: Any?{
        didSet{
            var image:UIImage = (datasourceItem as? UIImage)!
            profileImage.image = image
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        frame.size = CGSize(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height/1.5)
        addSubview(profileImage)
        profileImage.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: self.frame.height/20, leftConstant: self.frame.width/2-self.frame.width/5, bottomConstant: 0, rightConstant: 0, widthConstant: self.frame.width/2.5, heightConstant: self.frame.width/2.5)
        
        addSubview(editIm)
        editIm.anchor(nil, left: profileImage.rightAnchor, bottom: profileImage.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.editImg(tap:)))
        editIm.addGestureRecognizer(tapGesture)
        
        addSubview(name)
        name.anchor(profileImage.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: self.frame.width/2-name.intrinsicContentSize.width/2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(name.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func editImg(tap:UITapGestureRecognizer){
        ProfileController.takePhoto()
    }
}
    

class AddAccountHeader:DatasourceCell{
    
    let addLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Add Account"
        return label
    }()
    
    let addIcon:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "newGroup").withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = ThemeColors.BLUE_GREEN
        
        addSubview(addLabel)
        addLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: self.frame.height/2-addLabel.intrinsicContentSize.height/2, leftConstant: self.frame.width/2-addLabel.intrinsicContentSize.width/2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        addSubview(addIcon)
        addIcon.anchor(self.topAnchor, left: nil, bottom: nil, right: addLabel.leftAnchor, topConstant: self.frame.height/2-10, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 20, heightConstant: 20)
        
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(self.add(tap:)))
        self.addGestureRecognizer(gestureTap)
        
    }
    
    func add(tap:UITapGestureRecognizer){
        ProfileController.own.present(UINavigationController(rootViewController:NewAccountController()), animated: true, completion: nil)
    }

}
class AccountCell:DatasourceCell{
    override var datasourceItem: Any?{
        didSet{
            var account:Account = (datasourceItem as? Account)!
            name.text = account.username
            if account.accountKey.lowercased() == "facebook"{
                accountIcon.image = #imageLiteral(resourceName: "facebook")
            }
            else if account.accountKey.lowercased() == "instagram"{
                accountIcon.image = #imageLiteral(resourceName: "instagram")
            }
            else if account.accountKey.lowercased() == "snapchat"{
                accountIcon.image = #imageLiteral(resourceName: "snapchat")
            }
            else if account.accountKey.lowercased() == "twitter"{
                accountIcon.image = #imageLiteral(resourceName: "twitter")
            }else{
                accountIcon.image = #imageLiteral(resourceName: "defaultIcon")
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor(red:240/255,green:240/255,blue:240/255,alpha:1)
        
        addSubview(accountIcon)
        accountIcon.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        addSubview(name)
        
        addSubview(name)
        name.anchor(topAnchor, left: accountIcon.rightAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    var accountIcon:UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.image = #imageLiteral(resourceName: "defaultIcon")
        view.clipsToBounds = true
        return view
    }()
    
    lazy var name:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
}
