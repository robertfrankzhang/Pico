//
//  DB.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import Firebase

class DB{
    static func getUser(userID:String,completionHandler:@escaping (_ group:Cache?)->()){
        var userDictionaryRef:[String:AnyObject] = [:]
        var returnUser:Cache? = nil
        
        Database.database().reference().child("users").child(userID).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                userDictionaryRef = dictionary
                
                var accountsArray:[Account] = []
                if let accounts = (userDictionaryRef["accounts"] as? [String:AnyObject]){
                    for account in accounts.keys{
                        let accountReal = accounts[account] as! [String:String]
                        let username = accountReal["username"]
                        let toggled = accountReal["toggled"] == "true" ? true : false
                        
                        var newAccount = Account(accountKey: account, username: username!, toggled: toggled)
                        accountsArray.append(newAccount)
                    }
                }
                
                var scannedArray:[ScannedUser] = []
                if let scanned = (userDictionaryRef["scannedUsers"] as? [String:AnyObject]){
                    for user in scanned.keys{
                        let userReal = scanned[user] as! [String:String]
                        var accountKeys:[String] = []
                        for accounts in userReal.keys{
                            accountKeys.append(accounts)
                        }
                        var newScanned = ScannedUser(userID: userReal as! String, accountKeys: accountKeys)
                        scannedArray.append(newScanned)
                    }
                }
                
                returnUser = Cache(email: userDictionaryRef["email"] as! String, firstName: userDictionaryRef["email"] as! String, lastName: "", profilePic: UIImage(), description: userDictionaryRef["description"] as! String, accounts: accountsArray, scanned: scannedArray)
            }
            
            if returnUser == nil{
                completionHandler(nil)
            }else{
                completionHandler(returnUser)
            }
        }, withCancel: nil)
    }
}
