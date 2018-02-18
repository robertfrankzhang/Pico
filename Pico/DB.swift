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
                if let scanned = (userDictionaryRef["scannedIDs"] as? [String:AnyObject]){
                    for user in scanned.keys{
                        let userReal = scanned[user] as! [String:String]
                        var accountKeys:[String] = []
                        for accounts in userReal.keys{
                            accountKeys.append(accounts)
                        }
                        var newScanned = ScannedUser(userID: user as! String, accountKeys: accountKeys)
                        scannedArray.append(newScanned)
                    }
                }
                
                
                if let profileImageURL = userDictionaryRef["profileURL"]{
                    let url = NSURL(string: profileImageURL as! String)
                    URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
                        if error != nil{
                            print(error)
                            return
                        }
                        DispatchQueue.main.async {
                            let image = UIImage(data:data!)!
                            returnUser = Cache(userID:userDictionaryRef["userID"] as! String,email: userDictionaryRef["email"] as! String, firstName: userDictionaryRef["firstName"] as! String, lastName: "", profilePic: image, description: userDictionaryRef["description"] as! String, accounts: accountsArray, scanned: scannedArray)
                            
                            if returnUser == nil{
                                completionHandler(nil)
                            }else{
                                completionHandler(returnUser)
                            }
                        }
                    }).resume()
                }else{
                    returnUser = Cache(userID:userDictionaryRef["userID"] as! String,email: userDictionaryRef["email"] as! String, firstName: userDictionaryRef["firstName"] as! String, lastName: "", profilePic:#imageLiteral(resourceName: "userBlank"), description: userDictionaryRef["description"] as! String, accounts: accountsArray, scanned: scannedArray)
                    if returnUser == nil{
                        completionHandler(nil)
                    }else{
                        completionHandler(returnUser)
                    }
                }
            }
        }, withCancel: nil)
    }
    
    static func addAccount(account:Account){
        let ref = Database.database().reference(fromURL: "https://pico-be4e4.firebaseio.com/")
        let usersReference = ref.child("users").child(myCache.currentCache.userID).child("accounts")
        
        var accounts:[String:[String:String]] = [:]
        
        for account in myCache.currentCache.accounts{
            var toggle:String = account.toggled ? "true" : "false"
            accounts[account.accountKey] = ["username":account.username,"toggled":toggle]
        }
        
        usersReference.updateChildValues(accounts, withCompletionBlock: { (err,ref) in
            if err != nil{
                print(err)
                return
            }
            
            print("Saved user successfully into Firebase DB")
            NewAccountController.own.dismiss(animated: true, completion: nil)
            return
        })
    }
    
    static func addUser(user:Cache){
        let ref = Database.database().reference(fromURL: "https://pico-be4e4.firebaseio.com/")
        let usersReference = ref.child("users").child(myCache.currentCache.userID).child("scannedIDs")
        
        var scanned:[String:[String:String]] = [:]
        
        for friend in myCache.currentCache.scanned{
            var scanned2:[String:String] =  [:]
            for account in friend.accountKeys{
                scanned2[account] = "placeholder"
            }
            scanned[friend.userID] = scanned2
        }
        
        usersReference.updateChildValues(scanned, withCompletionBlock: { (err,ref) in
            if err != nil{
                print(err)
                return
            }
            
            print("Saved user successfully into Firebase DB")
            return
        })
    }
    
    static func updateProfilePicture(image:UIImage){
        let storageRef = Storage.storage().reference().child("myProfile\(myCache.currentCache.userID)")
        if let uploadData = UIImageJPEGRepresentation(image, 1){
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error)
                    return
                }
                print(metadata)
                let ref = Database.database().reference(fromURL: "https://pico-be4e4.firebaseio.com/")
                let userRef = ref.child("users").child(myCache.currentCache.userID).child("profileURL")
                userRef.setValue(metadata?.downloadURL()?.absoluteString)
                print("stored")
                
            })
        }
        
    }
    
    static func getCurrentUserID()->String?{
        return Auth.auth().currentUser?.uid
    }
}
