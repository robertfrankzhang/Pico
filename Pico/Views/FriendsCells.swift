//
//  FriendsCells.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import LBTAComponents
import UIKit

class FriendCell:DatasourceCell{
    
    var user:Cache = Cache()
    
    let name:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = ""
        return label
    }()
    
    let profile:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "userBlank").withRenderingMode(.alwaysOriginal)
        return view
    }()
    
    
    override var datasourceItem: Any?{
        didSet{
            var friend:ScannedUser = (datasourceItem as? ScannedUser)!
            var currentUser:Cache? = Cache()
            DB.getUser(userID: friend.userID, completionHandler: { (user:Cache?) in
                print("cache received")
                currentUser = user
                if let currentUserExists = currentUser{
                    self.profile.image = currentUserExists.profilePic
                    self.name.text = currentUserExists.firstName
                    self.user = currentUserExists
                }else{
                    print("networkerror")
                    //Some Network Error
                }
                //
            })
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(profile)
        profile.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 56, heightConstant: 56)
        
        addSubview(name)
        name.anchor(topAnchor, left: profile.rightAnchor, bottom: nil, right: nil, topConstant: self.frame.height/2-name.intrinsicContentSize.height/2, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(self.add(tap:)))
        self.addGestureRecognizer(gestureTap)
        self.backgroundColor = .white
    }
    
    func add(tap:UITapGestureRecognizer){
        FriendsController.own.present(UINavigationController(rootViewController:UserViewController(user:user)), animated: true, completion: nil)
    }
}
