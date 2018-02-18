//
//  Objects.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import UIKit

class Cache{
    var userID:String = ""
    var email:String = ""
    var firstName:String = ""
    var lastName:String = ""
    var profilePic:UIImage = #imageLiteral(resourceName: "userBlank")
    var description:String = ""
    var accounts:[Account] = []
    var scanned:[ScannedUser] = []
    
    init(userID:String,email:String,firstName:String,lastName:String,profilePic:UIImage,description:String,accounts:[Account],scanned:[ScannedUser]) {
        self.userID = userID
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.profilePic = profilePic
        self.description = description
        self.accounts = accounts
        self.scanned = scanned
    }
    
    init(){
        
    }
}

class Account{
    var accountKey:String = ""
    var username:String = ""
    var toggled:Bool = true
    
    init(accountKey:String,username:String,toggled:Bool){
        self.accountKey = accountKey
        self.username = username
        self.toggled = toggled
    }
    
    init() {
        
    }
}

class ScannedUser{
    var userID:String = ""
    var accountKeys:[String] = []
    
    init(userID:String,accountKeys:[String]){
        self.userID = userID
        self.accountKeys = accountKeys
    }
}


class myCache{
    static var currentCache = Cache()
}
